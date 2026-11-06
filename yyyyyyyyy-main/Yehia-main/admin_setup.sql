-- 1. إنشاء جدول الإداريين (Admins)
CREATE TABLE admins (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. إضافة إيميل كمدير (يمكنك تغييره لاحقاً من قاعدة البيانات أو لوحة تحكم Supabase)
-- استخدمت الإيميل الظاهر في حسابك كمثال
INSERT INTO admins (email) VALUES ('yahlaredwan76@gmail.com');

-- 3. إعداد مساحة التخزين (Storage Bucket) لرفع الفيديوهات
INSERT INTO storage.buckets (id, name, public) 
VALUES ('course-videos', 'course-videos', true)
ON CONFLICT (id) DO NOTHING;

-- 4. إعطاء الصلاحيات للجميع لقراءة الفيديوهات (مهم لكي يعمل الموقع)
CREATE POLICY "Public Access for Videos" 
ON storage.objects FOR SELECT 
USING (bucket_id = 'course-videos');

-- 5. إعطاء الصلاحية للإدارة لرفع وتعديل وحذف الفيديوهات
CREATE POLICY "Authenticated Users can upload videos" 
ON storage.objects FOR INSERT 
WITH CHECK (bucket_id = 'course-videos' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated Users can update videos" 
ON storage.objects FOR UPDATE 
USING (bucket_id = 'course-videos' AND auth.role() = 'authenticated');

CREATE POLICY "Authenticated Users can delete videos" 
ON storage.objects FOR DELETE 
USING (bucket_id = 'course-videos' AND auth.role() = 'authenticated');
