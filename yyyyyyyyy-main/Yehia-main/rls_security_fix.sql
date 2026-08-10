-- =============================================================
-- إصلاح سياسات RLS الأمنية - yahiaredwan.com
-- =============================================================
-- هذا السكربت يعيد كتابة جميع سياسات RLS بحيث:
-- ✅ القراءة العامة (SELECT) متاحة للجميع على الجداول العامة
-- ✅ الكتابة (INSERT/UPDATE/DELETE) متاحة فقط للمسؤولين المسجلين
-- ✅ جدول subscriptions: INSERT متاح للجميع (للتسجيل)، باقي العمليات للمسؤولين
-- ✅ جدول chat_logs: INSERT متاح للمستخدمين المسجلين
-- =============================================================

-- أولاً: إنشاء دالة مساعدة للتحقق من صلاحيات المسؤول
-- (تتحقق من أن المستخدم الحالي موجود في جدول admins)
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.admins
    WHERE email = auth.jwt() ->> 'email'
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER STABLE;

-- =============================================================
-- 1. site_content: قراءة عامة (مع إخفاء الأسرار) + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'site_content') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON site_content', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read site_content"
  ON site_content FOR SELECT
  USING (
    public.is_admin() OR 
    id NOT IN ('fawaterak_client_secret', 'fawaterak_client_id', 'fawaterak_env', 'chatbot_api_key', 'chatbot_model', 'chatbot_limit_guest', 'chatbot_limit_user', 'chatbot_system_prompt', 'chatbot_knowledge')
  );

CREATE POLICY "Admin update site_content"
  ON site_content FOR UPDATE
  USING (public.is_admin());

CREATE POLICY "Admin insert site_content"
  ON site_content FOR INSERT
  WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete site_content"
  ON site_content FOR DELETE
  USING (public.is_admin());

-- =============================================================
-- 2. features: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'features') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON features', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read features"
  ON features FOR SELECT USING (true);

CREATE POLICY "Admin update features"
  ON features FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert features"
  ON features FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete features"
  ON features FOR DELETE USING (public.is_admin());

-- =============================================================
-- 3. trainers: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'trainers') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON trainers', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read trainers"
  ON trainers FOR SELECT USING (true);

CREATE POLICY "Admin update trainers"
  ON trainers FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert trainers"
  ON trainers FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete trainers"
  ON trainers FOR DELETE USING (public.is_admin());

-- =============================================================
-- 4. curriculum: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'curriculum') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON curriculum', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read curriculum"
  ON curriculum FOR SELECT USING (true);

CREATE POLICY "Admin update curriculum"
  ON curriculum FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert curriculum"
  ON curriculum FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete curriculum"
  ON curriculum FOR DELETE USING (public.is_admin());

-- =============================================================
-- 5. faqs: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'faqs') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON faqs', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read faqs"
  ON faqs FOR SELECT USING (true);

CREATE POLICY "Admin update faqs"
  ON faqs FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert faqs"
  ON faqs FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete faqs"
  ON faqs FOR DELETE USING (public.is_admin());

-- =============================================================
-- 6. payment_methods: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'payment_methods') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON payment_methods', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read payment_methods"
  ON payment_methods FOR SELECT USING (true);

CREATE POLICY "Admin update payment_methods"
  ON payment_methods FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert payment_methods"
  ON payment_methods FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete payment_methods"
  ON payment_methods FOR DELETE USING (public.is_admin());

-- =============================================================
-- 7. sections: قراءة عامة + كتابة للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'sections') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON sections', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public read sections"
  ON sections FOR SELECT USING (true);

CREATE POLICY "Admin update sections"
  ON sections FOR UPDATE USING (public.is_admin());

CREATE POLICY "Admin insert sections"
  ON sections FOR INSERT WITH CHECK (public.is_admin());

CREATE POLICY "Admin delete sections"
  ON sections FOR DELETE USING (public.is_admin());

-- =============================================================
-- 8. subscriptions: INSERT للجميع + قراءة/تعديل/حذف للمسؤولين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'subscriptions') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON subscriptions', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Public insert subscriptions"
  ON subscriptions FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Admin select subscriptions"
  ON subscriptions FOR SELECT
  USING (public.is_admin());

CREATE POLICY "Admin update subscriptions"
  ON subscriptions FOR UPDATE
  USING (public.is_admin());

CREATE POLICY "Admin delete subscriptions"
  ON subscriptions FOR DELETE
  USING (public.is_admin());

-- =============================================================
-- 9. admins: قراءة للمسجلين + كتابة للمسؤولين فقط
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'admins') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON admins', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Authenticated read admins"
  ON admins FOR SELECT
  USING (auth.role() = 'authenticated');

CREATE POLICY "Admin insert admins"
  ON admins FOR INSERT
  WITH CHECK (public.is_admin());

CREATE POLICY "Admin update admins"
  ON admins FOR UPDATE
  USING (public.is_admin());

CREATE POLICY "Admin delete admins"
  ON admins FOR DELETE
  USING (public.is_admin());

-- =============================================================
-- 10. user_approvals: قراءة/كتابة للمسؤولين + INSERT للمسجلين
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'user_approvals') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON user_approvals', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "Admin or self read user_approvals"
  ON user_approvals FOR SELECT
  USING (
    public.is_admin()
    OR email = auth.jwt() ->> 'email'
  );

CREATE POLICY "Authenticated insert user_approvals"
  ON user_approvals FOR INSERT
  WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Admin update user_approvals"
  ON user_approvals FOR UPDATE
  USING (public.is_admin());

CREATE POLICY "Admin delete user_approvals"
  ON user_approvals FOR DELETE
  USING (public.is_admin());

-- =============================================================
-- 11. chat_logs: INSERT للجميع + قراءة المستخدم لسجلاته + المسؤول
-- =============================================================
DO $$ DECLARE pol RECORD; BEGIN
  FOR pol IN (SELECT policyname FROM pg_policies WHERE tablename = 'chat_logs') LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON chat_logs', pol.policyname);
  END LOOP;
END $$;

CREATE POLICY "User or admin read chat_logs"
  ON chat_logs FOR SELECT
  USING (
    user_id = auth.uid()
    OR public.is_admin()
  );

CREATE POLICY "Public insert chat_logs"
  ON chat_logs FOR INSERT
  WITH CHECK (true);

-- =============================================================
-- ✅ تم الانتهاء من إصلاح سياسات RLS
-- =============================================================
