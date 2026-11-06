-- 1. Create site_content table
CREATE TABLE IF NOT EXISTS site_content (
    id TEXT PRIMARY KEY,
    content TEXT,
    type TEXT
);

-- Insert initial site_content data safely
INSERT INTO site_content (id, content, type) VALUES
('hero_title', 'دورة الحماية من الابتزاز الإلكتروني وكيفية التعامل معه', 'text'),
('hero_subtitle', 'احمِ نفسك وأسرتك، وافهم كيف تتعامل مع الابتزاز الإلكتروني قانونياً وتقنياً ونفسياً قبل وبعد التهديد.', 'text'),
('hero_video_url', 'promo.mp4', 'text'),
('hero_poster_url', 'poster.jpg', 'text'),
('hero_cta_text', 'اشترك الآن بسعر الإطلاق (700 ج.م)', 'text'),
('hero_cta_hint', 'دورة تعليمية وتوعوية، بادر بحجز مكانك.', 'text'),
('features_header_title', 'لماذا هذه الدورة مختلفة؟', 'text'),
('features_header_subtitle', 'لأن الابتزاز الإلكتروني ليس قانوناً فقط... وليس أمناً سيبرانياً فقط... وليس دعماً نفسياً فقط. الضحية تحتاج 3 أشياء في نفس الوقت:', 'text'),
('trainers_header_title', 'خبراء الدورة', 'text'),
('curriculum_header_title', 'محاور الدورة: ماذا ستتعلم؟', 'text'),
('faq_header_title', 'أسئلة شائعة', 'text'),
('cta_section_title', 'العرض النهائي (باقة الحماية من الابتزاز الإلكتروني وكيفية التعامل معه)', 'text'),
('cta_section_desc', 'تحصل على: 5 دورات كاملة، ملف أحكام محكمة، خصم 50% على الاستشارات القانونية، خصم يصل إلى 30% على متابعة القضايا، ضمان استرجاع كامل المبلغ خلال 30 يومًا.', 'text'),
('cta_old_price', '4500', 'text'),
('cta_new_price', '700', 'text'),
('cta_subtitle', '(خصم يصل إلى 84%) لأول 100 مشترك فقط!', 'text'),
('cta_button_text', 'احجز مكانك الآن', 'text'),
('cta_note', 'ملاحظة: بعد الدفع، احتفظ بصورة إيصال التحويل، ثم أرسلها لفريق التأكيد لتفعيل اشتراكك وإرسال بيانات الوصول للباقة.', 'text'),
('founder_link_articles', 'https://qanonmasri.com/', 'text'),
('founder_link_community', 'https://www.facebook.com/share/g/1GN9jxSsJt/', 'text'),
('founder_link_facebook', 'https://www.facebook.com/share/1DpsU2YCJ1/', 'text'),
('chatbot_api_key', '', 'text'),
('chatbot_system_prompt', 'أنت مساعد ذكي داخل موقع المحامي يحيى رضوان. مهمتك الإجابة على أسئلة الزوار بناءً على "ملف المعرفة" المرفق أدناه فقط. لا تجب من خارج هذا الملف، واستخدم نبرة مهنية ومحترمة ومصرية مفهومة.', 'text'),
('chatbot_knowledge', '', 'text'),
('chatbot_model', 'openai/gpt-4o-mini', 'text'),
('chatbot_limit_guest', '3', 'text'),
('chatbot_limit_user', '6', 'text'),
('wa_floating_link', 'https://wa.me/201021469038', 'text'),
('wa_consultation_link', 'https://wa.me/201021469038', 'text'),
('wa_activation_link', 'https://wa.me/201021469038', 'text'),
('pixel_fb_id', '1879911229646791', 'text'),
('pixel_fb_enabled', 'true', 'text'),
('pixel_tiktok_id', '', 'text'),
('pixel_tiktok_enabled', 'false', 'text'),
('pixel_snapchat_id', '', 'text'),
('pixel_snapchat_enabled', 'false', 'text'),
('pixel_ga_id', '', 'text'),
('pixel_ga_enabled', 'false', 'text'),
('pixel_gads_id', '', 'text'),
('pixel_gads_enabled', 'false', 'text'),
('pixel_custom_code', '', 'text'),
('pixel_custom_enabled', 'false', 'text'),
('site_logo', 'logo/aaaa.jpg.jpeg', 'text'),
('fawaterak_client_id', '', 'text'),
('fawaterak_client_secret', '', 'text'),
('fawaterak_env', 'staging', 'text'),
('why_needed_title', 'لماذا تحتاج هذه الباقة؟', 'text'),
('why_needed_desc', '<p style="margin-bottom: 15px;">لأن الابتزاز الإلكتروني لا يبدأ دائمًا بجريمة واضحة. أحيانًا يبدأ برسالة. أو رابط. أو حساب وهمي. أو علاقة مزيفة. أو اختراق بسيط. أو صورة تم استغلالها. أو محادثة تحولت إلى تهديد.</p><p style="margin-bottom: 15px;">وفي اللحظة التي يشعر فيها الشخص بالخوف، يبدأ الخطر الحقيقي. لذلك هذه الباقة صُممت لتجعلك تفهم الصورة كاملة: قانونيًا. تقنيًا. نفسيًا.</p><p style="margin-bottom: 15px;">ومن خلال قصص واقعية وأحكام محكمة... أنت لا تشتري دورة واحدة، أنت تدخل برنامجًا كاملًا يجمع 5 دورات ومواد إضافية... بل تحتاج إلى: فهم قانوني، وعي تقني، حماية رقمية، استقرار نفسي، فهم لطريقة تفكير المبتز، معرفة عملية بما يحدث في المحاضر والنيابة والمحكمة.</p>', 'text'),
('bonuses_title', 'ماذا ستحصل عليه بالضبط؟ (مكافآت أول 100 مشترك والضمان)', 'text'),
('bonuses_desc', '<ul class="list-light-gray" style="margin-bottom: 25px;"><li><strong>ملف أحكام محكمة:</strong> ملف كامل يحتوي على أحكام محكمة سابقة في قضايا تهديد وابتزاز إلكتروني حقيقية.</li><li><strong>خصم 50% على الاستشارات القانونية:</strong> في حال احتجت إلى استشارة قانونية خاصة بحالتك مع المحامي يحيى رضوان.</li><li><strong>خصم يصل إلى 30% على متابعة القضايا:</strong> في حال قررت توكيل المكتب لمتابعة قضيتك قانونياً.</li></ul><p style="margin-bottom: 15px; padding: 20px; border-right: 4px solid #B89C65; background-color: rgba(184, 156, 101, 0.1);"><strong>ضمان استرجاع كامل المبلغ خلال 30 يومًا:</strong> نحن واثقون من قيمة هذه الباقة. إذا شعرت أنها لم تقدم لك الفائدة المرجوة، يمكنك طلب استرجاع المبلغ بالكامل خلال 30 يوماً من الاشتراك. (تنبيه: لا ينطبق الضمان في حال تحميل المواد أو الاستفادة من الخصومات الإضافية).</p>', 'text'),
('audience_title', 'هل هذه الباقة مناسبة لك؟ ولماذا لا تؤجل؟', 'text'),
('audience_desc', '<h3 style="color: #E5E7EB; margin-bottom: 10px; font-weight: bold;">هذه الباقة مناسبة لك إذا:</h3><ul class="list-light-gray" style="margin-bottom: 20px;"><li>كنت أباً أو أماً ترغب في حماية أبنائك.</li><li>كنت شخصاً يتعرض لابتزاز حالي وتريد فهم أبعاد المشكلة.</li><li>كنت ترغب في حماية نفسك وعائلتك تقنياً وقانونياً ونفسياً للمستقبل.</li></ul><h3 style="color: #E5E7EB; margin-bottom: 10px; font-weight: bold;">هذه الباقة غير مناسبة لك إذا:</h3><ul class="list-light-gray" style="margin-bottom: 20px;"><li>كنت تبحث عن طرق لاختراق الحسابات أو تتبع شخص أو الانتقام، نحن نقدم حماية قانونية وتقنية فقط.</li></ul><p style="margin-bottom: 15px; font-weight: bold; color: #D1D5DB;">لماذا لا تؤجل؟ لأن الجهل بالقانون والتقنية قد يكلفك الكثير، والابتزاز يتغذى على الخوف والوقت. احمِ نفسك الآن قبل وقوع الأزمة.</p>', 'text'),
('founder_name', 'المحامي يحيى رضوان', 'text'),
('founder_bio', 'مؤسس مبادرة "معاً ضد جرائم الإنترنت". للمزيد من النصائح القانونية، يسعدني تواصلكم عبر منصاتي:', 'text'),
('course_1_title', 'الدورة الأولى | المحور القانوني: كيف تأخذ حقك بالقانون؟', 'text'),
('course_1_desc', '<p style="margin-bottom: 15px;"><strong>يقدمه: المحامي يحيى رضوان</strong> (محامٍ متخصص في جرائم الإنترنت والابتزاز الإلكتروني، مؤسس مبادرة “معًا ضد جرائم الإنترنت”).</p><p style="margin-bottom: 15px;">في هذا المحور ستفهم الطريق القانوني في قضايا الابتزاز الإلكتروني من البداية للنهاية:</p><ul class="list-light-gray"><li>كيف تجمع الأدلة وتحافظ عليها من الضياع.</li><li>كيف تقوم بتحرير محضر سليم في مباحث الإنترنت.</li><li>ما هو دور النيابة العامة في قضايا الابتزاز.</li><li>متى يتم تحويل القضية للمحكمة وكيف يتم تحديد الجلسات.</li><li>تنفيذ الحكم بعد صدوره.</li></ul><p style="margin-bottom: 15px; color: #D1D5DB;"><strong>الهدف من المحور القانوني:</strong> أن تعرف الطريق بدل ما تتحرك بعشوائية...<br><em>تنبيه مهم: الدورة لا تضمن نتيجة قانونية، لأن كل حالة تختلف حسب الوقائع والأدلة والإجراءات.</em></p>', 'text'),
('course_2_title', 'الدورة الثانية | دورة القصص الواقعية: افهم كيف يفكر المبتزون', 'text'),
('course_2_desc', '<p style="margin-bottom: 15px;">داخل هذه الدورة ستتعرف على قصص واقعية أو شبيهة بالواقع، بدون ذكر أي أسماء... الهدف من هذه القصص ليس الإثارة.</p><ul class="list-light-gray"><li>كيف تبدأ عملية الابتزاز في الخفاء.</li><li>ما هي ألاعيب المبتز وكيف يوقع بالضحية.</li><li>الأخطاء الكارثية التي تقع فيها الضحية بسبب الخوف.</li><li>كيفية النجاة والتصرف السليم في كل قصة.</li></ul><p style="margin-bottom: 15px; color: #D1D5DB;"><strong>لماذا هذا مهم؟</strong> لأنك عندما ترى السيناريو قبل أن يحدث لك، تستطيع أن تتجنبه. والأب أو الأم عندما يفهمون القصص، يستطيعون حماية الأبناء قبل وقوع الأزمة.</p>', 'text'),
('course_3_4_title', 'دورات الحماية وفهم طرق الاختراق الحديثة', 'text'),
('course_3_title', 'الدورة الثالثة: حماية نفسك وأسرتك وأجهزتك من الاختراق', 'text'),
('course_4_title', 'الدورة الرابعة: فهم طرق الاختراق الحديثة للحماية منها', 'text'),
('course_3_4_desc', '<h3 style="color: #E5E7EB; margin-bottom: 10px; font-weight: bold;">الدورة الثالثة: حماية نفسك وأسرتك وأجهزتك من الاختراق</h3><p style="margin-bottom: 15px;"><strong>يقدم هذا المحور: م/ عبدالرازق علي...</strong> ستتعلم كيف تحمي هاتفك، جهاز الكمبيوتر، البريد الإلكتروني، وحسابات فيسبوك وإنستجرام وواتساب...</p><ul class="list-light-gray" style="margin-bottom: 30px;"><li>إعدادات الخصوصية والأمان في جميع التطبيقات.</li><li>كيفية استخدام المصادقة الثنائية (Two-Factor Authentication).</li><li>ماذا تفعل إذا شعرت أن جهازك مخترق.</li></ul><h3 style="color: #E5E7EB; margin-bottom: 10px; font-weight: bold;">الدورة الرابعة: فهم طرق الاختراق الحديثة للحماية منها</h3><p style="margin-bottom: 15px;">هذه الدورة يقدمها مهندس متخصص / هاكر أخلاقي بهدف التوعية والحماية...</p><ul class="list-light-gray"><li>كيف يتم سرقة الحسابات عبر الروابط الوهمية.</li><li>أساليب الهندسة الاجتماعية (Social Engineering) وكيفية تجنبها.</li><li>طرق اكتشاف التطبيقات الخبيثة والملفات الملغمة.</li><li><strong>تنبيه مهم:</strong> هذه الدورة للحماية والتوعية فقط ولا تقدم أي أدوات أو طرق للاختراق بأي شكل من الأشكال.</li></ul>', 'text'),
('course_5_title', 'الدورة الخامسة | دورة الصحة النفسية والتعامل مع المبتز', 'text'),
('course_5_desc', '<p style="margin-bottom: 15px;"><strong>تقدمها: د/ هالة فؤاد (دكتورة صحة نفسية).</strong> الابتزاز الإلكتروني ليس ضغطًا قانونيًا أو تقنيًا فقط. هو ضغط نفسي شديد...</p><ul class="list-light-gray"><li>كيف تدير مشاعر الخوف والقلق أثناء الأزمة.</li><li>كيفية الرد على المبتز ببرود وثبات يضعفه.</li><li>كيف يتعامل الأهل مع الأبناء في حالة وقوعهم ضحية للابتزاز.</li><li>كيفية التعافي النفسي بعد انتهاء المشكلة واستعادة الثقة.</li></ul><p style="margin-bottom: 15px; color: #D1D5DB;"><strong>الهدف من هذا المحور:</strong> أن تعرف أن الضحية لا تحتاج إلى لوم. الضحية تحتاج إلى احتواء، وهدوء، وتوجيه صحيح.</p>', 'text')
ON CONFLICT (id) DO NOTHING;

-- 2. Create features table
CREATE TABLE IF NOT EXISTS features (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT,
    description TEXT,
    icon TEXT,
    order_index INT
);

-- 3. Create trainers table
CREATE TABLE IF NOT EXISTS trainers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    description TEXT,
    image_path TEXT,
    order_index INT
);

-- 4. Create curriculum table
CREATE TABLE IF NOT EXISTS curriculum (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT,
    content TEXT,
    order_index INT
);

-- 5. Create faqs table
CREATE TABLE IF NOT EXISTS faqs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question TEXT,
    answer TEXT,
    order_index INT
);

-- 6. Create chat_logs table
CREATE TABLE IF NOT EXISTS chat_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id),
    is_guest BOOLEAN DEFAULT false,
    role TEXT,
    content TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- 7. Create payment_methods table
CREATE TABLE IF NOT EXISTS payment_methods (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT,
    number TEXT,
    order_index INT
);

-- 8. Create sections (الشعب) table
CREATE TABLE IF NOT EXISTS sections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    trainer_name TEXT,
    capacity INT DEFAULT 30,
    start_date TEXT,
    schedule TEXT,
    whatsapp_link TEXT,
    notes TEXT,
    status TEXT DEFAULT 'active',
    order_index INT DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Insert sample section safely
INSERT INTO sections (name, trainer_name, capacity, start_date, schedule, whatsapp_link, notes, status, order_index)
SELECT 'الشعبة الأولى - الدفعة المباشرة', 'المحامي يحيى رضوان', 30, '2026-08-01', 'السبت والأربعاء ( الساعة 8 مساءً )', 'https://chat.whatsapp.com/demo', 'شعبة مكثفة تغطي كافة المحاور', 'active', 1
WHERE NOT EXISTS (SELECT 1 FROM sections WHERE name = 'الشعبة الأولى - الدفعة المباشرة');

-- 9. Create subscriptions table
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT,
    phone TEXT,
    payment_method TEXT,
    transfer_number TEXT,
    receipt_url TEXT,
    status TEXT DEFAULT 'pending',
    section_id UUID REFERENCES sections(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Ensure section_id column exists if table was already created
ALTER TABLE subscriptions ADD COLUMN IF NOT EXISTS section_id UUID REFERENCES sections(id);

-- 10. Create admins table
CREATE TABLE IF NOT EXISTS admins (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Insert default initial admin safely
INSERT INTO admins (email)
SELECT 'yahiaredwan@outlook.com'
WHERE NOT EXISTS (SELECT 1 FROM admins WHERE email = 'yahiaredwan@outlook.com');

-- Enable RLS for all tables
ALTER TABLE site_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE features ENABLE ROW LEVEL SECURITY;
ALTER TABLE trainers ENABLE ROW LEVEL SECURITY;
ALTER TABLE curriculum ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE admins ENABLE ROW LEVEL SECURITY;

-- Clean up any existing RLS policies on admins table (prevents infinite recursion error)
DO $$ 
DECLARE 
    pol RECORD;
BEGIN 
    FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'admins') LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON admins', pol.policyname);
    END LOOP;
END $$;

CREATE POLICY "Allow public select on admins" ON admins FOR SELECT USING (true);
CREATE POLICY "Allow public update on admins" ON admins FOR UPDATE USING (true);
CREATE POLICY "Allow public insert on admins" ON admins FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete on admins" ON admins FOR DELETE USING (true);

-- Helper to safely drop and recreate RLS policies for all tables
DROP POLICY IF EXISTS "Allow public read access on site_content" ON site_content;
DROP POLICY IF EXISTS "Allow public update access on site_content" ON site_content;
DROP POLICY IF EXISTS "Allow public insert access on site_content" ON site_content;
DROP POLICY IF EXISTS "Allow public delete access on site_content" ON site_content;

CREATE POLICY "Allow public read access on site_content" ON site_content FOR SELECT USING (id NOT IN ('fawaterak_client_secret', 'fawaterak_client_id', 'fawaterak_env'));
CREATE POLICY "Allow public update access on site_content" ON site_content FOR UPDATE USING (true);
CREATE POLICY "Allow public insert access on site_content" ON site_content FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access on site_content" ON site_content FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public read access on features" ON features;
DROP POLICY IF EXISTS "Allow public update access on features" ON features;
DROP POLICY IF EXISTS "Allow public insert access on features" ON features;
DROP POLICY IF EXISTS "Allow public delete access on features" ON features;

CREATE POLICY "Allow public read access on features" ON features FOR SELECT USING (true);
CREATE POLICY "Allow public update access on features" ON features FOR UPDATE USING (true);
CREATE POLICY "Allow public insert access on features" ON features FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access on features" ON features FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public read access on trainers" ON trainers;
DROP POLICY IF EXISTS "Allow public update access on trainers" ON trainers;
DROP POLICY IF EXISTS "Allow public insert access on trainers" ON trainers;
DROP POLICY IF EXISTS "Allow public delete access on trainers" ON trainers;

CREATE POLICY "Allow public read access on trainers" ON trainers FOR SELECT USING (true);
CREATE POLICY "Allow public update access on trainers" ON trainers FOR UPDATE USING (true);
CREATE POLICY "Allow public insert access on trainers" ON trainers FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access on trainers" ON trainers FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public read access on curriculum" ON curriculum;
DROP POLICY IF EXISTS "Allow public update access on curriculum" ON curriculum;
DROP POLICY IF EXISTS "Allow public insert access on curriculum" ON curriculum;
DROP POLICY IF EXISTS "Allow public delete access on curriculum" ON curriculum;

CREATE POLICY "Allow public read access on curriculum" ON curriculum FOR SELECT USING (true);
CREATE POLICY "Allow public update access on curriculum" ON curriculum FOR UPDATE USING (true);
CREATE POLICY "Allow public insert access on curriculum" ON curriculum FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access on curriculum" ON curriculum FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public read access on faqs" ON faqs;
DROP POLICY IF EXISTS "Allow public update access on faqs" ON faqs;
DROP POLICY IF EXISTS "Allow public insert access on faqs" ON faqs;
DROP POLICY IF EXISTS "Allow public delete access on faqs" ON faqs;

CREATE POLICY "Allow public read access on faqs" ON faqs FOR SELECT USING (true);
CREATE POLICY "Allow public update access on faqs" ON faqs FOR UPDATE USING (true);
CREATE POLICY "Allow public insert access on faqs" ON faqs FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete access on faqs" ON faqs FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public select on payment_methods" ON payment_methods;
DROP POLICY IF EXISTS "Allow public update on payment_methods" ON payment_methods;
DROP POLICY IF EXISTS "Allow public insert on payment_methods" ON payment_methods;
DROP POLICY IF EXISTS "Allow public delete on payment_methods" ON payment_methods;

CREATE POLICY "Allow public select on payment_methods" ON payment_methods FOR SELECT USING (true);
CREATE POLICY "Allow public update on payment_methods" ON payment_methods FOR UPDATE USING (true);
CREATE POLICY "Allow public insert on payment_methods" ON payment_methods FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete on payment_methods" ON payment_methods FOR DELETE USING (true);

DROP POLICY IF EXISTS "Allow public select on subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Allow public update on subscriptions" ON subscriptions;
DROP POLICY IF EXISTS "Allow public insert on subscriptions" ON subscriptions;

CREATE POLICY "Allow public select on subscriptions" ON subscriptions FOR SELECT USING (true);
CREATE POLICY "Allow public update on subscriptions" ON subscriptions FOR UPDATE USING (true);
CREATE POLICY "Allow public insert on subscriptions" ON subscriptions FOR INSERT WITH CHECK (true);

DROP POLICY IF EXISTS "Allow public select on sections" ON sections;
DROP POLICY IF EXISTS "Allow public update on sections" ON sections;
DROP POLICY IF EXISTS "Allow public insert on sections" ON sections;
DROP POLICY IF EXISTS "Allow public delete on sections" ON sections;

CREATE POLICY "Allow public select on sections" ON sections FOR SELECT USING (true);
CREATE POLICY "Allow public update on sections" ON sections FOR UPDATE USING (true);
CREATE POLICY "Allow public insert on sections" ON sections FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public delete on sections" ON sections FOR DELETE USING (true);

-- 11. Create user_approvals table
CREATE TABLE IF NOT EXISTS user_approvals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    status TEXT DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);
ALTER TABLE user_approvals ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Allow public select on user_approvals" ON user_approvals;
DROP POLICY IF EXISTS "Allow public insert on user_approvals" ON user_approvals;
DROP POLICY IF EXISTS "Allow public update on user_approvals" ON user_approvals;
DROP POLICY IF EXISTS "Allow public delete on user_approvals" ON user_approvals;

CREATE POLICY "Allow public select on user_approvals" ON user_approvals FOR SELECT USING (true);
CREATE POLICY "Allow public insert on user_approvals" ON user_approvals FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public update on user_approvals" ON user_approvals FOR UPDATE USING (true);
CREATE POLICY "Allow public delete on user_approvals" ON user_approvals FOR DELETE USING (true);

-- 12. Performance Indexes (For Webhooks and High Traffic)
CREATE INDEX IF NOT EXISTS idx_subscriptions_transfer_number ON subscriptions(transfer_number);
CREATE INDEX IF NOT EXISTS idx_user_approvals_phone ON user_approvals(phone);
