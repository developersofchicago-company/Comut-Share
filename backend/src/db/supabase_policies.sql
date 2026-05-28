-- ════════════════════════════════════════════════════════════════════
-- ComutShare — Supabase RLS Policies & Storage Setup
-- Run this in: Supabase Dashboard → SQL Editor → New Query → Run
-- ════════════════════════════════════════════════════════════════════

-- ─── 1. LINK OUR USERS TABLE TO SUPABASE AUTH ───────────────────────
-- The AuthService inserts auth.uid() into users.id, so we need to
-- ensure the column type matches and add the FK reference.
-- (Skip the ALTER if you've already linked them.)

ALTER TABLE users
  DROP CONSTRAINT IF EXISTS users_id_fkey;

ALTER TABLE users
  ADD CONSTRAINT users_id_fkey
  FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;

-- ─── 2. ENABLE RLS ON ALL TABLES ────────────────────────────────────

ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE rides ENABLE ROW LEVEL SECURITY;
ALTER TABLE bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE saved_routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE referrals ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports ENABLE ROW LEVEL SECURITY;

-- Companies and ogra_rates stay public (read-only reference data)
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE ogra_rates ENABLE ROW LEVEL SECURITY;

-- ─── 3. USERS TABLE POLICIES ────────────────────────────────────────

-- Allow users to insert their own profile stub after OTP verification
DROP POLICY IF EXISTS "Users can insert own profile" ON users;
CREATE POLICY "Users can insert own profile" ON users
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = id);

-- Allow users to read their own profile
DROP POLICY IF EXISTS "Users can read own profile" ON users;
CREATE POLICY "Users can read own profile" ON users
  FOR SELECT TO authenticated
  USING (auth.uid() = id);

-- Allow users to update their own profile
DROP POLICY IF EXISTS "Users can update own profile" ON users;
CREATE POLICY "Users can update own profile" ON users
  FOR UPDATE TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Allow authenticated users to read other users' public info (name, photo, rating)
-- needed for showing driver/rider cards during matching
DROP POLICY IF EXISTS "Authenticated users can read public profiles" ON users;
CREATE POLICY "Authenticated users can read public profiles" ON users
  FOR SELECT TO authenticated
  USING (true);

-- ─── 4. COMPANIES (public read for whitelist matching) ──────────────

DROP POLICY IF EXISTS "Anyone can read companies" ON companies;
CREATE POLICY "Anyone can read companies" ON companies
  FOR SELECT TO anon, authenticated
  USING (is_active = true);

-- ─── 5. OGRA RATES (public read for pricing) ────────────────────────

DROP POLICY IF EXISTS "Anyone can read ogra rates" ON ogra_rates;
CREATE POLICY "Anyone can read ogra rates" ON ogra_rates
  FOR SELECT TO anon, authenticated
  USING (true);

-- ─── 6. USER PREFERENCES ────────────────────────────────────────────

DROP POLICY IF EXISTS "Users manage own preferences" ON user_preferences;
CREATE POLICY "Users manage own preferences" ON user_preferences
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ─── 7. VEHICLES ────────────────────────────────────────────────────

DROP POLICY IF EXISTS "Users manage own vehicles" ON vehicles;
CREATE POLICY "Users manage own vehicles" ON vehicles
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Authenticated users can read vehicles" ON vehicles;
CREATE POLICY "Authenticated users can read vehicles" ON vehicles
  FOR SELECT TO authenticated
  USING (true);

-- ─── 8. RIDES ───────────────────────────────────────────────────────

-- Anyone authenticated can read published rides (matching engine)
DROP POLICY IF EXISTS "Authenticated users read all rides" ON rides;
CREATE POLICY "Authenticated users read all rides" ON rides
  FOR SELECT TO authenticated
  USING (true);

-- Drivers can post their own rides
DROP POLICY IF EXISTS "Drivers post own rides" ON rides;
CREATE POLICY "Drivers post own rides" ON rides
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = driver_id);

-- Drivers can update their own rides
DROP POLICY IF EXISTS "Drivers update own rides" ON rides;
CREATE POLICY "Drivers update own rides" ON rides
  FOR UPDATE TO authenticated
  USING (auth.uid() = driver_id);

-- Drivers can delete their own rides
DROP POLICY IF EXISTS "Drivers delete own rides" ON rides;
CREATE POLICY "Drivers delete own rides" ON rides
  FOR DELETE TO authenticated
  USING (auth.uid() = driver_id);

-- ─── 9. BOOKINGS ────────────────────────────────────────────────────

-- Riders see their own bookings; drivers see bookings on their rides
DROP POLICY IF EXISTS "Bookings visible to participants" ON bookings;
CREATE POLICY "Bookings visible to participants" ON bookings
  FOR SELECT TO authenticated
  USING (
    auth.uid() = rider_id
    OR auth.uid() IN (SELECT driver_id FROM rides WHERE rides.id = bookings.ride_id)
  );

DROP POLICY IF EXISTS "Riders create bookings" ON bookings;
CREATE POLICY "Riders create bookings" ON bookings
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = rider_id);

DROP POLICY IF EXISTS "Participants update bookings" ON bookings;
CREATE POLICY "Participants update bookings" ON bookings
  FOR UPDATE TO authenticated
  USING (
    auth.uid() = rider_id
    OR auth.uid() IN (SELECT driver_id FROM rides WHERE rides.id = bookings.ride_id)
  );

-- ─── 10. TRANSACTIONS (wallet ledger — read-only from app) ──────────

DROP POLICY IF EXISTS "Users read own transactions" ON transactions;
CREATE POLICY "Users read own transactions" ON transactions
  FOR SELECT TO authenticated
  USING (auth.uid() = user_id);

-- Inserts only via server-side function or service role key

-- ─── 11. RATINGS ────────────────────────────────────────────────────

DROP POLICY IF EXISTS "Authenticated users read ratings" ON ratings;
CREATE POLICY "Authenticated users read ratings" ON ratings
  FOR SELECT TO authenticated
  USING (true);

DROP POLICY IF EXISTS "Users create own ratings" ON ratings;
CREATE POLICY "Users create own ratings" ON ratings
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = from_user_id);

-- ─── 12. CHAT MESSAGES ──────────────────────────────────────────────

DROP POLICY IF EXISTS "Participants read chat" ON chat_messages;
CREATE POLICY "Participants read chat" ON chat_messages
  FOR SELECT TO authenticated
  USING (
    auth.uid() = sender_id
    OR auth.uid() IN (SELECT driver_id FROM rides WHERE rides.id = chat_messages.ride_id)
    OR auth.uid() IN (SELECT rider_id FROM bookings WHERE bookings.ride_id = chat_messages.ride_id)
  );

DROP POLICY IF EXISTS "Users send own chat" ON chat_messages;
CREATE POLICY "Users send own chat" ON chat_messages
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = sender_id);

-- ─── 13. SAVED ROUTES ───────────────────────────────────────────────

DROP POLICY IF EXISTS "Users manage own saved routes" ON saved_routes;
CREATE POLICY "Users manage own saved routes" ON saved_routes
  FOR ALL TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ─── 14. REFERRALS ──────────────────────────────────────────────────

DROP POLICY IF EXISTS "Users read own referrals" ON referrals;
CREATE POLICY "Users read own referrals" ON referrals
  FOR SELECT TO authenticated
  USING (auth.uid() = referrer_id);

DROP POLICY IF EXISTS "Users create own referrals" ON referrals;
CREATE POLICY "Users create own referrals" ON referrals
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = referrer_id);

-- ─── 15. REPORTS (abuse / safety) ───────────────────────────────────

DROP POLICY IF EXISTS "Users create reports" ON reports;
CREATE POLICY "Users create reports" ON reports
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = reporter_id);

DROP POLICY IF EXISTS "Users read own reports" ON reports;
CREATE POLICY "Users read own reports" ON reports
  FOR SELECT TO authenticated
  USING (auth.uid() = reporter_id);

-- ════════════════════════════════════════════════════════════════════
-- 16. STORAGE BUCKET: identity-docs (CNIC photos)
-- ════════════════════════════════════════════════════════════════════
-- Create the bucket via Dashboard or run:
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'identity-docs',
  'identity-docs',
  false, -- private bucket; URLs signed
  5242880, -- 5 MB
  ARRAY['image/jpeg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Policy: users can upload to their own folder cnics/{auth.uid()}/*
DROP POLICY IF EXISTS "Users upload own CNIC" ON storage.objects;
CREATE POLICY "Users upload own CNIC" ON storage.objects
  FOR INSERT TO authenticated
  WITH CHECK (
    bucket_id = 'identity-docs'
    AND (storage.foldername(name))[1] = 'cnics'
    AND (storage.foldername(name))[2] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users read own CNIC" ON storage.objects;
CREATE POLICY "Users read own CNIC" ON storage.objects
  FOR SELECT TO authenticated
  USING (
    bucket_id = 'identity-docs'
    AND (storage.foldername(name))[1] = 'cnics'
    AND (storage.foldername(name))[2] = auth.uid()::text
  );

DROP POLICY IF EXISTS "Users update own CNIC" ON storage.objects;
CREATE POLICY "Users update own CNIC" ON storage.objects
  FOR UPDATE TO authenticated
  USING (
    bucket_id = 'identity-docs'
    AND (storage.foldername(name))[2] = auth.uid()::text
  );

-- ════════════════════════════════════════════════════════════════════
-- DONE.
-- After running, test in the SQL editor:
--   SELECT * FROM pg_policies WHERE schemaname = 'public';
-- You should see ~25 policies listed.
-- ════════════════════════════════════════════════════════════════════
