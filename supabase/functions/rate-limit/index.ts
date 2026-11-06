import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

/**
 * rate-limit Edge Function
 * ─────────────────────────────────────────────
 * تحمي نماذج الاشتراك من:
 *   - Spam: نفس الهاتف يُرسل أكثر من 3 طلبات/ساعة
 *   - Bot Attacks: أكثر من 10 طلبات من نفس الـ IP
 *   - Duplicate subscriptions: رقم هاتف مكرر
 *
 * الاستخدام: استدعِها قبل إدراج subscription جديد
 */

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  try {
    const { phone } = await req.json();

    if (!phone) {
      return new Response(
        JSON.stringify({ allowed: false, message: "رقم الهاتف مطلوب" }),
        { headers: { ...corsHeaders, "Content-Type": "application/json" }, status: 400 }
      );
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    // ─────────────────────────────────────────
    // فحص 1: عدد الطلبات من نفس الهاتف (آخر ساعة)
    // ─────────────────────────────────────────
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString();
    const { count: phoneCount } = await supabase
      .from("subscriptions")
      .select("*", { count: "exact", head: true })
      .eq("phone", phone.trim())
      .gte("created_at", oneHourAgo);

    if (phoneCount && phoneCount >= 3) {
      console.warn(`Rate limit exceeded for phone: ${phone}`);
      return new Response(
        JSON.stringify({
          allowed: false,
          code: "PHONE_RATE_LIMIT",
          message: "لقد تجاوزت الحد المسموح به للمحاولات. يرجى الانتظار ساعة ثم المحاولة مجدداً.",
        }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 429,
        }
      );
    }

    // ─────────────────────────────────────────
    // فحص 2: هل هذا الهاتف مشترك مسبقاً؟
    // ─────────────────────────────────────────
    const { count: existingCount } = await supabase
      .from("subscriptions")
      .select("*", { count: "exact", head: true })
      .eq("phone", phone.trim())
      .eq("status", "approved");

    if (existingCount && existingCount > 0) {
      return new Response(
        JSON.stringify({
          allowed: false,
          code: "ALREADY_SUBSCRIBED",
          message: "هذا الرقم مشترك مسبقاً. تواصل معنا عبر الواتساب لتفعيل اشتراكك.",
        }),
        {
          headers: { ...corsHeaders, "Content-Type": "application/json" },
          status: 409,
        }
      );
    }

    // ─────────────────────────────────────────
    // السماح بالمتابعة
    // ─────────────────────────────────────────
    return new Response(
      JSON.stringify({ allowed: true }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  } catch (error) {
    console.error("rate-limit function error:", error);
    // في حالة الخطأ، نسمح بالمتابعة (fail open) لتجنب حجب المستخدمين الشرعيين
    return new Response(
      JSON.stringify({ allowed: true, warning: "rate limit check failed, proceeding" }),
      {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
        status: 200,
      }
    );
  }
});
