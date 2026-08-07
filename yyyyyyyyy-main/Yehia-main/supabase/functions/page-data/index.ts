import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/**
 * page-data Edge Function
 * ─────────────────────────────────────────────
 * بدلاً من 7 طلبات منفصلة من المتصفح، هذه الـ Function
 * تجمعها في طلب واحد وترجعها مضغوطة مع Cache headers.
 *
 * الفائدة:
 *   - تقليل الطلبات من 7 → 1 لكل زيارة (-85%)
 *   - CDN يكّش الاستجابة 5 دقائق (Cloudflare/Vercel/Fastly)
 *   - Connection Pooling أفضل (طلب واحد يفتح اتصالاً واحداً)
 */

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // ─────────────────────────────────────────
    // جلب كل البيانات بالتوازي في نفس الوقت
    // ─────────────────────────────────────────
    const [
      { data: content },
      { data: trainers },
      { data: curriculum },
      { data: faqs },
      { data: paymentMethods },
      { data: sections },
      { data: features },
    ] = await Promise.all([
      supabase.from("site_content").select("id,content,type"),
      supabase.from("trainers").select("*").order("order_index", { ascending: true }),
      supabase.from("curriculum").select("*").order("order_index", { ascending: true }),
      supabase.from("faqs").select("*").order("order_index", { ascending: true }),
      supabase.from("payment_methods").select("*").order("order_index", { ascending: true }),
      supabase
        .from("sections")
        .select("*")
        .eq("status", "active")
        .order("order_index", { ascending: true }),
      supabase.from("features").select("*").order("order_index", { ascending: true }),
    ]);

    const responseData = {
      content,
      trainers,
      curriculum,
      faqs,
      paymentMethods,
      sections,
      features,
      generatedAt: new Date().toISOString(),
    };

    return new Response(JSON.stringify(responseData), {
      headers: {
        ...corsHeaders,
        "Content-Type": "application/json",
        // ─────────────────────────────────────
        // Cache headers: CDN يكّش 5 دقائق
        // المتصفح يكّش دقيقة واحدة (stale-while-revalidate)
        // ─────────────────────────────────────
        "Cache-Control": "public, s-maxage=300, stale-while-revalidate=60",
        "Surrogate-Control": "max-age=300",
      },
      status: 200,
    });
  } catch (error) {
    console.error("page-data function error:", error);
    return new Response(
      JSON.stringify({ error: "Failed to load page data", message: error.message }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 500,
      }
    );
  }
});
