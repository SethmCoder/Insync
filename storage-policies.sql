-- Storage Policies for Insync Documents Bucket
-- Run this in your Supabase SQL Editor to fix the "row-level security policy" error
-- This script sets up the necessary RLS policies for the storage bucket

-- First, ensure the bucket exists (if it doesn't, it will be created)
INSERT INTO storage.buckets (id, name, public) 
VALUES ('documents', 'documents', true)
ON CONFLICT (id) DO NOTHING;

-- Drop existing policies if they exist (to avoid conflicts)
DROP POLICY IF EXISTS "Public Access for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Upload for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Update for documents bucket" ON storage.objects;
DROP POLICY IF EXISTS "Public Delete for documents bucket" ON storage.objects;

-- Allow anyone to read/download files from the documents bucket
CREATE POLICY "Public Access for documents bucket" ON storage.objects
FOR SELECT
USING (bucket_id = 'documents');

-- Allow anyone to upload files to the documents bucket
CREATE POLICY "Public Upload for documents bucket" ON storage.objects
FOR INSERT
WITH CHECK (bucket_id = 'documents');

-- Allow anyone to update files in the documents bucket
CREATE POLICY "Public Update for documents bucket" ON storage.objects
FOR UPDATE
USING (bucket_id = 'documents')
WITH CHECK (bucket_id = 'documents');

-- Allow anyone to delete files from the documents bucket
CREATE POLICY "Public Delete for documents bucket" ON storage.objects
FOR DELETE
USING (bucket_id = 'documents');

-- Success message
DO $$
BEGIN
  RAISE NOTICE 'Storage policies created successfully!';
  RAISE NOTICE 'The documents bucket now allows public read, upload, update, and delete operations.';
END $$;

