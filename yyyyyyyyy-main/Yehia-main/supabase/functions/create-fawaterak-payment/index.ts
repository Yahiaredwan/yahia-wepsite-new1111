import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

// In-memory cache to reduce DB queries during high traffic
let siteContentCache: {
  clientId?: string;
  clientSecret?: string;
  env?: string;
  price?: number;
  timestamp: number;
} | null = null;

const CACHE_TTL = 5 * 60 * 1000; // 5 minutes

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { subscriptionId, customer } = await req.json();

    if (!subscriptionId || !customer) {
      throw new Error("Missing required body parameters.");
    }

    // Initialize Supabase Client with service role key to query DB if needed
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Get credentials and price securely from Cache or DB
    const now = Date.now();
    if (!siteContentCache || now - siteContentCache.timestamp > CACHE_TTL) {
      let envClientId = Deno.env.get("FAWATERAK_CLIENT_ID") || "";
      let envClientSecret = Deno.env.get("FAWATERAK_CLIENT_SECRET") || "";
      let envFawaterak = Deno.env.get("FAWATERAK_ENV") || "";
      let defaultPrice = 700;

      const { data: dbContent } = await supabase
        .from("site_content")
        .select("id, content")
        .in("id", ["fawaterak_client_id", "fawaterak_client_secret", "fawaterak_env", "cta_new_price"]);

      if (dbContent) {
        dbContent.forEach((item) => {
          if (item.id === "fawaterak_client_id" && item.content) envClientId = item.content;
          if (item.id === "fawaterak_client_secret" && item.content) envClientSecret = item.content;
          if (item.id === "fawaterak_env" && item.content) envFawaterak = item.content;
          if (item.id === "cta_new_price" && item.content) {
            // Extract numbers only
            const parsed = parseFloat(item.content.replace(/[^0-9.]/g, ''));
            if (!isNaN(parsed) && parsed > 0) defaultPrice = parsed;
          }
        });
      }
      
      siteContentCache = {
        clientId: envClientId,
        clientSecret: envClientSecret,
        env: envFawaterak,
        price: defaultPrice,
        timestamp: now
      };
    }

    const { clientId, clientSecret, env: fawaterakEnv, price: realCartTotal } = siteContentCache;

    // Default env to staging if not specified
    if (!fawaterakEnv) {
      fawaterakEnv = "staging";
    }

    if (!clientId || !clientSecret) {
      throw new Error("Fawaterak Client ID or Client Secret is not configured.");
    }

    const baseUrl = fawaterakEnv.toLowerCase() === "live"
      ? "https://app.fawaterk.com"
      : "https://staging.fawaterk.com";

    // 1. Get OAuth Access Token
    console.log(`Requesting OAuth token from: ${baseUrl}/oauth/token`);
    const tokenRes = await fetch(`${baseUrl}/oauth/token`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify({
        client_id: clientId,
        client_secret: clientSecret,
        grant_type: "client_credentials",
      }),
    });

    if (!tokenRes.ok) {
      const errText = await tokenRes.text();
      throw new Error(`Fawaterak OAuth failed: status ${tokenRes.status} - ${errText}`);
    }

    const tokenData = await tokenRes.json();
    const accessToken = tokenData.access_token;

    if (!accessToken) {
      throw new Error("OAuth response did not contain access_token.");
    }

    // 2. Create Fawaterak checkout transaction
    const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
    // Clean trailing slash if present
    const cleanedSupabaseUrl = supabaseUrl.endsWith("/") ? supabaseUrl.slice(0, -1) : supabaseUrl;

    const reqOrigin = req.headers.get("origin") || req.headers.get("referer") || "http://localhost:5500";
    const originUrl = reqOrigin.endsWith("/") ? reqOrigin.slice(0, -1) : reqOrigin;

    const redirectionUrls = {
      successUrl: `${originUrl}/success.html`,
      failUrl: `${originUrl}/index.html?status=fail`,
      pendingUrl: `${originUrl}/index.html?status=pending`,
      webhookUrl: `${cleanedSupabaseUrl}/functions/v1/fawaterak-webhook`,
    };

    const transactionPayload = {
      cartTotal: realCartTotal.toString(),
      currency: "EGP",
      customer: {
        first_name: customer.first_name || "Customer",
        last_name: customer.last_name || "Fawaterak",
        email: customer.email || "customer@example.com",
        phone: customer.phone,
      },
      cartItems: [
        {
          name: "باقة دورة الحماية من الابتزاز الإلكتروني",
          price: realCartTotal.toString(),
          quantity: "1",
        },
      ],
      redirectionUrls: redirectionUrls,
    };

    console.log("Creating transaction payload:", JSON.stringify(transactionPayload));

    const transRes = await fetch(`${baseUrl}/api/v3/createTransaction`, {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${accessToken}`,
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify(transactionPayload),
    });

    if (!transRes.ok) {
      const errText = await transRes.text();
      throw new Error(`Fawaterak createTransaction failed: status ${transRes.status} - ${errText}`);
    }

    const transData = await transRes.json();
    console.log("Fawaterak transaction response:", JSON.stringify(transData));

    if (transData.status !== "success" || !transData.data || !transData.data.url) {
      throw new Error(transData.message || "Failed to create checkout session URL.");
    }

    // Save Fawaterak transaction key / details to our subscription record for tracking
    const intentKey = transData.data.intent_key || "";
    const invoiceId = transData.data.invoice_id || "";

    await supabase
      .from("subscriptions")
      .update({
        transfer_number: `fawaterak_${invoiceId}`,
        receipt_url: `${baseUrl}/transactions/${intentKey}`,
      })
      .eq("id", subscriptionId);

    return new Response(
      JSON.stringify({ url: transData.data.url }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("create-fawaterak-payment error:", error.message);
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200, // Returning 200 so the frontend can parse the JSON error body
      }
    );
  }
});
