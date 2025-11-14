-- Complete Restoration Script for Insync
-- Run this in your Supabase SQL Editor to restore all tables, policies, and sample data
-- This script safely recreates everything without dropping existing data

-- ============================================
-- STEP 1: Create Tables (if they don't exist)
-- ============================================

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  access_level TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

-- Create documents table
CREATE TABLE IF NOT EXISTS documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL,
  location_name TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  photo_urls TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE documents ADD COLUMN IF NOT EXISTS location_name TEXT;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS latitude DOUBLE PRECISION;
ALTER TABLE documents ADD COLUMN IF NOT EXISTS longitude DOUBLE PRECISION;

-- Create comments table
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  author TEXT NOT NULL,
  text TEXT NOT NULL,
  stars INTEGER NOT NULL CHECK (stars >= 1 AND stars <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create app_settings table
CREATE TABLE IF NOT EXISTS app_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  user_password TEXT NOT NULL DEFAULT 'insync2024',
  admin_password TEXT NOT NULL DEFAULT 'insync2024',
  version TEXT NOT NULL DEFAULT 'v2.00',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================
-- STEP 2: Create Storage Bucket and Policies
-- ============================================

-- Create storage bucket for documents (if it doesn't exist)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('documents', 'documents', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Public Access for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Upload for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Update for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Delete for documents bucket" ON storage.objects;

-- Allow anyone to read/download files
CREATE POLICY "Public Access for documents bucket" ON storage.objects
FOR SELECT
USING (bucket_id = 'documents');

-- Allow anyone to upload files
CREATE POLICY "Public Upload for documents bucket" ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'documents');

-- Allow anyone to update files
CREATE POLICY "Public Update for documents bucket" ON storage.objects
FOR UPDATE
USING (bucket_id = 'documents')
WITH CHECK (bucket_id = 'documents');

-- Allow anyone to delete files
CREATE POLICY "Public Delete for documents bucket" ON storage.objects
FOR DELETE
USING (bucket_id = 'documents');

-- ============================================
-- STEP 3: Create Indexes
-- ============================================

CREATE INDEX IF NOT EXISTS idx_documents_category ON documents(category);
CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_document_id ON comments(document_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- ============================================
-- STEP 4: Insert Initial Users
-- ============================================

-- Insert admin users (only if they don't exist)
INSERT INTO users (username, password, access_level) VALUES 
  ('admin1', 'insync2024', 'admin'),
  ('admin2', 'insync2024', 'admin')
ON CONFLICT (username) DO NOTHING;

-- Insert regular users (only if they don't exist)
INSERT INTO users (username, password, access_level) VALUES 
  ('user1', 'insync2024', 'user'),
  ('user2', 'insync2024', 'user'),
  ('user3', 'insync2024', 'user')
ON CONFLICT (username) DO NOTHING;

-- ============================================
-- STEP 5: Insert App Settings
-- ============================================

INSERT INTO app_settings (id, user_password, admin_password, version) VALUES 
  (1, 'insync2024', 'insync2024', 'v2.00')
ON CONFLICT (id) DO UPDATE SET
  user_password = EXCLUDED.user_password,
  admin_password = EXCLUDED.admin_password,
  version = EXCLUDED.version,
  updated_at = NOW();

-- ============================================
-- STEP 6: Insert Sample Documents
-- ============================================
-- Note: We check if documents with these titles already exist to avoid duplicates

INSERT INTO documents (title, author, content, category, location_name, latitude, longitude, created_at) 
SELECT * FROM (VALUES 
  ('Welcome to Insync!', 'Admin', 'This is your personal space to share updates, travel stories, and collaborate on documents with friends. Start by creating your first document or browse what others have shared!', 'update', NULL, NULL, NULL, NOW()),
  ('Summer Travel Plans', 'Admin', 'Planning a trip to Europe this summer. Looking for recommendations on must-visit places in Paris and Rome. Any suggestions would be appreciated!', 'travel', NULL, NULL, NULL, NOW()),
  ('Project Collaboration Guidelines', 'Admin', 'Here are some guidelines for our collaborative documents: 1) Be respectful in comments, 2) Use constructive feedback, 3) Rate honestly, 4) Share your thoughts freely!', 'document', NULL, NULL, NULL, NOW()),
  ('Weekend Hiking Event', 'Admin', 'Join us this Saturday for a morning hike at the local nature reserve! We''ll meet at the parking lot at 8 AM. Bring water, snacks, and good hiking shoes. See you there!', 'event', NULL, NULL, NULL, NOW()),
  ('Book Review: \"The Alchemist\"', 'Admin', 'Just finished reading this amazing book. The journey of Santiago really resonated with me. The themes of following your dreams and listening to your heart are beautifully woven throughout the story. Highly recommend!', 'article', NULL, NULL, NULL, NOW()),
  ('Recipe: Homemade Pizza', 'Admin', 'Here''s my secret recipe for the perfect homemade pizza: Start with a good dough (let it rise overnight), use fresh mozzarella, and don''t skimp on the sauce. Bake at 450°F for 12-15 minutes. Delicious!', 'article', NULL, NULL, NULL, NOW()),
  ('Team Meeting Notes', 'Admin', 'Key points from today''s meeting: 1) New features planned for next month, 2) Everyone should review the design mockups, 3) Next meeting scheduled for Friday at 2 PM. Please confirm your attendance.', 'update', NULL, NULL, NULL, NOW())
) AS v(title, author, content, category, location_name, latitude, longitude, created_at)
WHERE NOT EXISTS (
  SELECT 1 FROM documents d WHERE d.title = v.title AND d.author = v.author
);

-- ============================================
-- STEP 7: Add Table Comments
-- ============================================

COMMENT ON TABLE users IS 'Stores user accounts with access levels';
COMMENT ON TABLE documents IS 'Main documents shared by users';
COMMENT ON TABLE comments IS 'Comments and ratings on documents';
COMMENT ON TABLE app_settings IS 'Application-wide settings and passwords';

-- ============================================
-- Success Message
-- ============================================

DO $$
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Complete Restoration Successful!';
  RAISE NOTICE '========================================';
  RAISE NOTICE '✓ All tables created';
  RAISE NOTICE '✓ Storage bucket and policies configured';
  RAISE NOTICE '✓ Indexes created';
  RAISE NOTICE '✓ Initial users added';
  RAISE NOTICE '✓ App settings configured';
  RAISE NOTICE '✓ Sample documents added';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'You can now use Insync with photo uploads!';
  RAISE NOTICE '========================================';
END $$;

