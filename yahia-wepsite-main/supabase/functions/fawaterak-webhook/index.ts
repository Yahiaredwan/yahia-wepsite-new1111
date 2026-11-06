import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  // CORS Preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const payload = await req.json();
    console.log("Fawaterak Webhook received payload:", JSON.stringify(payload));

    // Extract invoice identifier (support different formats)
    const invoiceId = payload.invoice_id || payload.invoiceId || payload.invoice_key || payload.invoiceKey || (payload.data && (payload.data.invoice_id || payload.data.invoiceId));
    
    if (!invoiceId) {
      console.warn("Could not find invoice identifier in payload.");
      return new Response(JSON.stringify({ success: false, error: "Missing invoice identifier" }), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 400,
      });
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // Get credentials to double-check status directly from Fawaterak API for security
    let clientId = Deno.env.get("FAWATERAK_CLIENT_ID") || "";
    let clientSecret = Deno.env.get("FAWATERAK_CLIENT_SECRET") || "";
    let fawaterakEnv = Deno.env.get("FAWATERAK_ENV") || "";

    if (!clientId || !clientSecret || !fawaterakEnv) {
      const { data: dbContent } = await supabase
        .from("site_content")
        .select("id, content")
        .in("id", ["fawaterak_client_id", "fawaterak_client_secret", "fawaterak_env"]);

      if (dbContent) {
        dbContent.forEach((item) => {
          if (item.id === "fawaterak_client_id" && item.content) clientId = item.content;
          if (item.id === "fawaterak_client_secret" && item.content) clientSecret = item.content;
          if (item.id === "fawaterak_env" && item.content) fawaterakEnv = item.content;
        });
      }
    }

    if (!fawaterakEnv) fawaterakEnv = "staging";

    const baseUrl = fawaterakEnv.toLowerCase() === "live"
      ? "https://app.fawaterk.com"
      : "https://staging.fawaterk.com";

    let isPaid = false;

    // Double check with Fawaterak API directly if we have client credentials
    if (clientId && clientSecret) {
      try {
        // Fetch OAuth Token
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

        if (tokenRes.ok) {
          const tokenData = await tokenRes.json();
          const accessToken = tokenData.access_token;

          if (accessToken) {
            // Get Transaction Data
            const checkRes = await fetch(`${baseUrl}/api/v3/getTransactionData`, {
              method: "POST",
              headers: {
                "Authorization": `Bearer ${accessToken}`,
                "Content-Type": "application/json",
                "Accept": "application/json",
              },
              body: JSON.stringify({
                invoice_id: invoiceId.toString(),
              }),
            });

            if (checkRes.ok) {
              const checkData = await checkRes.json();
              console.log("Fawaterak API check response:", JSON.stringify(checkData));
              
              const invoiceStatus = checkData.data?.invoice_status || checkData.data?.status;
              if (invoiceStatus && (invoiceStatus.toLowerCase() === "paid" || invoiceStatus.toLowerCase() === "success")) {
                isPaid = true;
              }
            } else {
              console.warn("Failed to retrieve transaction status from API, falling back to payload values.");
            }
          }
        }
      } catch (checkErr) {
        console.error("Error verifying payment with Fawaterak API:", checkErr);
      }
    }

    // Fallback to payload status if API check was not conclusive
    if (!isPaid) {
      const payloadStatus = payload.invoice_status || payload.status || (payload.data && (payload.data.invoice_status || payload.data.status));
      if (payloadStatus && (payloadStatus.toLowerCase() === "paid" || payloadStatus.toLowerCase() === "success")) {
        isPaid = true;
      }
    }

    if (isPaid) {
      console.log(`Payment confirmed for Fawaterak Invoice ID: ${invoiceId}`);

      // 1. Find subscription by invoice ID tracking or intent key
      const { data: matchedSubscriptions, error: subError } = await supabase
        .from("subscriptions")
        .select("*")
        .or(`transfer_number.eq.fawaterak_${invoiceId},receipt_url.ilike.%${invoiceId}%`);

      if (subError) {
        throw subError;
      }

      if (matchedSubscriptions && matchedSubscriptions.length > 0) {
        const sub = matchedSubscriptions[0];
        console.log(`Found matching subscription: ${sub.id} (Name: ${sub.full_name}, Phone: ${sub.phone})`);

        // Update subscription status to 'paid' (active subscription)
        const { error: updateError } = await supabase
          .from("subscriptions")
          .update({ status: "paid" })
          .eq("id", sub.id);

        if (updateError) {
          throw updateError;
        }

        // 2. Automatically approve user account in user_approvals
        if (sub.phone) {
          // Normalize phone (remove leading zeros or non-digits if necessary, or check both)
          const cleanPhone = sub.phone.trim();
          const cleanPhoneNoZero = cleanPhone.startsWith("0") ? cleanPhone.substring(1) : cleanPhone;

          const { data: matchedApprovals } = await supabase
            .from("user_approvals")
            .select("*")
            .or(`phone.eq.${cleanPhone},phone.eq.${cleanPhoneNoZero}`);

          if (matchedApprovals && matchedApprovals.length > 0) {
            console.log(`Approving user account with ID: ${matchedApprovals[0].id}`);
            await supabase
              .from("user_approvals")
              .update({ status: "approved" })
              .eq("id", matchedApprovals[0].id);
          } else {
            console.log(`No user_approval record found for phone: ${cleanPhone}. Creating one as approved.`);
            await supabase
              .from("user_approvals")
              .insert([{ 
                email: sub.email || `approved_${cleanPhone}@example.com`,
                phone: cleanPhone,
                status: "approved"
              }]);
          }
        }

        // 3. Send Purchase event to Facebook CAPI
        try {
          const PIXEL_ID = "1879911229646791";
          const ACCESS_TOKEN = "EAAR2DkffaHkBSF0mFyZCDZBCxDGdq2pZAGqiZB9jsCsazozLCfGSGbYUafepzNMxoXolPoyoZBOeTjTAIWwCSYCMgBuXlp13AwqYcsewDA4TcoNf7gosC2ZAy5RBAZCmW3O4tZCMuVZCjtsv1NLBNVplGlN0rVX0BYWm8rZCZAwBIDyTY6pYhUICGSMiagXJaa8IwZDZD";
          
          const hashData = async (data) => {
            if (!data) return undefined;
            const encoder = new TextEncoder();
            const dataBuf = encoder.encode(data.toLowerCase().trim());
            const hashBuffer = await crypto.subtle.digest('SHA-256', dataBuf);
            const hashArray = Array.from(new Uint8Array(hashBuffer));
            return hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
          };

          let em, ph;
          if (sub.email) em = await hashData(sub.email);
          if (sub.phone) ph = await hashData(sub.phone);

          const fbPayload = {
            data: [
              {
                event_name: "Purchase",
                event_time: Math.floor(Date.now() / 1000),
                action_source: "website",
                user_data: {
                  em: em || "",
                  ph: ph || "",
                },
                custom_data: {
                  currency: "EGP",
                  value: 2950
                }
              }
            ]
          };

          const fbUrl = `https://graph.facebook.com/v19.0/${PIXEL_ID}/events?access_token=${ACCESS_TOKEN}`;
          const fbRes = await fetch(fbUrl, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(fbPayload)
          });
          
          if (!fbRes.ok) {
            const errBody = await fbRes.text();
            console.error("Failed to send Purchase to FB CAPI:", errBody);
          } else {
            console.log("Successfully sent Purchase event to FB CAPI");
          }
        } catch (fbErr) {
          console.error("Error sending to FB CAPI:", fbErr);
        }
      } else {
        console.warn(`No matching subscription found in database for invoice: ${invoiceId}`);
      }
    } else {
      console.log(`Webhook received non-paid status or validation failed for invoice: ${invoiceId}`);
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 200,
    });
  } catch (error) {
    console.error("fawaterak-webhook function error:", error.message);
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
      status: 500,
    });
  }
});
