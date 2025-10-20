-- Isync Database Setup Script
-- Run this in your Supabase SQL Editor

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS comments CASCADE;
DROP TABLE IF EXISTS documents CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS app_settings CASCADE;

-- Create users table
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  access_level TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

-- Create documents table
CREATE TABLE documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL,
  photo_urls TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create comments table
CREATE TABLE comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  author TEXT NOT NULL,
  text TEXT NOT NULL,
  stars INTEGER NOT NULL CHECK (stars >= 1 AND stars <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create app_settings table
CREATE TABLE app_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  user_password TEXT NOT NULL DEFAULT 'insync2024',
  admin_password TEXT NOT NULL DEFAULT 'insync2024',
  version TEXT NOT NULL DEFAULT 'v2.00',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create storage bucket for documents
INSERT INTO storage.buckets (id, name, public) 
VALUES ('documents', 'documents', true)
ON CONFLICT (id) DO NOTHING;

-- Create initial admin users
INSERT INTO users (username, password, access_level) VALUES 
  ('admin1', 'insync2024', 'admin'),
  ('admin2', 'insync2024', 'admin');

-- Create initial regular users
INSERT INTO users (username, password, access_level) VALUES 
  ('user1', 'insync2024', 'user'),
  ('user2', 'insync2024', 'user'),
  ('user3', 'insync2024', 'user');

-- Create app settings
INSERT INTO app_settings (user_password, admin_password, version) VALUES 
  ('insync2024', 'insync2024', 'v2.00');

-- Create sample documents
INSERT INTO documents (title, author, content, category) VALUES
  ('Welcome to Isync!', 'Admin', 'This is your personal space to share updates, travel stories, and collaborate on documents with friends. Start by creating your first document or browse what others have shared!', 'update'),
  ('Summer Travel Plans', 'Admin', 'Planning a trip to Europe this summer. Looking for recommendations on must-visit places in Paris and Rome. Any suggestions would be appreciated!', 'travel'),
  ('Project Collaboration Guidelines', 'Admin', 'Here are some guidelines for our collaborative documents: 1) Be respectful in comments, 2) Use constructive feedback, 3) Rate honestly, 4) Share your thoughts freely!', 'document'),
  ('Weekend Hiking Event', 'Admin', 'Join us this Saturday for a morning hike at the local nature reserve! We''ll meet at the parking lot at 8 AM. Bring water, snacks, and good hiking shoes. See you there!', 'event'),
  ('Book Review: "The Alchemist"', 'Admin', 'Just finished reading this amazing book. The journey of Santiago really resonated with me. The themes of following your dreams and listening to your heart are beautifully woven throughout the story. Highly recommend!', 'article'),
  ('Recipe: Homemade Pizza', 'Admin', 'Here''s my secret recipe for the perfect homemade pizza: Start with a good dough (let it rise overnight), use fresh mozzarella, and don''t skimp on the sauce. Bake at 450°F for 12-15 minutes. Delicious!', 'article'),
  ('Team Meeting Notes', 'Admin', 'Key points from today''s meeting: 1) New features planned for next month, 2) Everyone should review the design mockups, 3) Next meeting scheduled for Friday at 2 PM. Please confirm your attendance.', 'update');

-- Create indexes for better performance
CREATE INDEX idx_documents_category ON documents(category);
CREATE INDEX idx_documents_created_at ON documents(created_at DESC);
CREATE INDEX idx_comments_document_id ON comments(document_id);
CREATE INDEX idx_users_username ON users(username);

-- Add helpful comments
COMMENT ON TABLE users IS 'Stores user accounts with access levels';
COMMENT ON TABLE documents IS 'Main documents shared by users';
COMMENT ON TABLE comments IS 'Comments and ratings on documents';
COMMENT ON TABLE app_settings IS 'Application-wide settings and passwords';

-- Success message
DO $$
BEGIN
  RAISE NOTICE 'Database setup complete!';
  RAISE NOTICE 'Created 2 admin users and 3 regular users';
  RAISE NOTICE 'Created 7 sample documents';
  RAISE NOTICE 'Storage bucket "documents" is ready';
END $$;

