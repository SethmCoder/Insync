-- Restore Tables Script for Insync
-- Run this in your Supabase SQL Editor to recreate tables without dropping existing data
-- This script safely creates tables only if they don't exist

-- Create users table (only if it doesn't exist)
CREATE TABLE IF NOT EXISTS users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  access_level TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

-- Create documents table (only if it doesn't exist)
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

-- Create comments table (only if it doesn't exist)
CREATE TABLE IF NOT EXISTS comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  author TEXT NOT NULL,
  text TEXT NOT NULL,
  stars INTEGER NOT NULL CHECK (stars >= 1 AND stars <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create app_settings table (only if it doesn't exist)
CREATE TABLE IF NOT EXISTS app_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  user_password TEXT NOT NULL DEFAULT 'insync2024',
  admin_password TEXT NOT NULL DEFAULT 'insync2024',
  version TEXT NOT NULL DEFAULT 'v2.00',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create storage bucket for documents (if it doesn't exist)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('documents', 'documents', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Public Access for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Upload for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Update for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Delete for documents bucket" ON storage.objects;

-- Storage policies for the documents bucket
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

-- Create indexes (only if they don't exist)
CREATE INDEX IF NOT EXISTS idx_documents_category ON documents(category);
CREATE INDEX IF NOT EXISTS idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_comments_document_id ON comments(document_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Insert initial admin users (only if they don't exist)
INSERT INTO users (username, password, access_level) VALUES 
  ('admin1', 'insync2024', 'admin'),
  ('admin2', 'insync2024', 'admin')
ON CONFLICT (username) DO NOTHING;

-- Insert initial regular users (only if they don't exist)
INSERT INTO users (username, password, access_level) VALUES 
  ('user1', 'insync2024', 'user'),
  ('user2', 'insync2024', 'user'),
  ('user3', 'insync2024', 'user')
ON CONFLICT (username) DO NOTHING;

-- Insert app settings (only if they don't exist)
INSERT INTO app_settings (id, user_password, admin_password, version) VALUES 
  (1, 'insync2024', 'insync2024', 'v2.00')
ON CONFLICT (id) DO NOTHING;

-- Success message
DO $$
BEGIN
  RAISE NOTICE 'Tables restored successfully!';
  RAISE NOTICE 'Storage policies created!';
  RAISE NOTICE 'Initial users and settings have been added (if they did not exist).';
END $$;

