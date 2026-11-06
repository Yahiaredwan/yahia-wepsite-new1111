import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

const PIXEL_ID = "1879911229646791";
// We can use an environment variable for the access token in production, but we will hardcode it for now as requested.
const ACCESS_TOKEN = "EAAR2DkffaHkBSF0mFyZCDZBCxDGdq2pZAGqiZB9jsCsazozLCfGSGbYUafepzNMxoXolPoyoZBOeTjTAIWwCSYCMgBuXlp13AwqYcsewDA4TcoNf7gosC2ZAy5RBAZCmW3O4tZCMuVZCjtsv1NLBNVplGlN0rVX0BYWm8rZCZAwBIDyTY6pYhUICGSMiagXJaa8IwZDZD";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { event_name, event_time, user_data, custom_data, event_source_url, action_source } = await req.json();

    if (!user_data || (!user_data.em && !user_data.ph)) {
      throw new Error("User data (em or ph) is required.");
    }

    const payload = {
      data: [
        {
          event_name: event_name || "CompleteRegistration",
          event_time: event_time || Math.floor(Date.now() / 1000),
          action_source: action_source || "website",
          event_source_url: event_source_url,
          user_data: {
            em: user_data.em, // Must be SHA-256 hashed on client side
            ph: user_data.ph, // Must be SHA-256 hashed on client side
            client_ip_address: req.headers.get("x-forwarded-for") || req.headers.get("cf-connecting-ip") || "0.0.0.0",
            client_user_agent: req.headers.get("user-agent") || "",
          },
          custom_data: custom_data || {}
        }
      ]
    };

    const fbUrl = `https://graph.facebook.com/v19.0/${PIXEL_ID}/events?access_token=${ACCESS_TOKEN}`;

    const response = await fetch(fbUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload)
    });

    const fbResponse = await response.json();

    if (!response.ok) {
      console.error("Facebook API Error:", fbResponse);
      throw new Error(fbResponse.error?.message || "Failed to send event to Facebook");
    }

    return new Response(JSON.stringify({ success: true, message: "Event sent successfully", fbResponse }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ success: false, error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    });
  }
});
