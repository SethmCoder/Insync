# Insync - Share & Collaborate Platform

A multi-functional website for sharing documents, updates, and articles among close friends. Perfect for travel logs, document collaboration, Q&A-based improvement, and event flyers.

## Features

- 🔐 **Simple Authentication**: Password-based access control (no user signup)
- 📝 **Document Management**: Create, view, and organize documents with categories
- 💬 **Comments & Ratings**: Leave feedback with star ratings on documents
- 🖼️ **Photo Support**: Upload multiple images per document
- 🔍 **Search & Filter**: Find documents by search term or category
- 👨‍💼 **Admin Panel**: Manage users and passwords
- 📚 **Tutorial System**: Built-in onboarding for new users
- 📱 **Responsive Design**: Works on desktop and mobile devices

## Quick Start

### 1. Set Up Supabase

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Copy your project URL and anon key from Settings > API

### 2. Configure the Application

1. Open `index.html` in a text editor
2. Find these lines near the top of the file:
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace with your actual Supabase credentials:
   ```javascript
   const SUPABASE_URL = 'https://your-project.supabase.co';
   const SUPABASE_ANON_KEY = 'your-anon-key-here';
   ```

### 3. Set Up Database

Run the SQL script in your Supabase SQL Editor (see `supabase-setup.sql`):

```sql
-- Create tables
CREATE TABLE users (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  username TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  access_level TEXT NOT NULL DEFAULT 'user',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  last_login TIMESTAMPTZ
);

CREATE TABLE documents (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL,
  photo_urls TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE comments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
  author TEXT NOT NULL,
  text TEXT NOT NULL,
  stars INTEGER NOT NULL CHECK (stars >= 1 AND stars <= 5),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE app_settings (
  id INTEGER PRIMARY KEY DEFAULT 1,
  user_password TEXT NOT NULL DEFAULT 'insync2024',
  admin_password TEXT NOT NULL DEFAULT 'insync202245',
  version TEXT NOT NULL DEFAULT 'v2.00',
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create storage bucket for documents
INSERT INTO storage.buckets (id, name, public) VALUES ('documents', 'documents', true);

-- Create initial admin users
INSERT INTO users (username, password, access_level) VALUES 
  ('admin1', 'insync202245', 'admin'),
  ('admin2', 'insync202245', 'admin');

-- Create initial regular users
INSERT INTO users (username, password, access_level) VALUES 
  ('user1', 'insync2024', 'user'),
  ('user2', 'insync2024', 'user'),
  ('user3', 'insync2024', 'user');

-- Create app settings
INSERT INTO app_settings (user_password, admin_password, version) VALUES 
  ('insync2024', 'insync202245', 'v2.00');

-- Create sample documents
INSERT INTO documents (title, author, content, category) VALUES
  ('Welcome to Insync!', 'Admin', 'This is your personal space to share updates, travel stories, and collaborate on documents with friends. Start by creating your first document or browse what others have shared!', 'update'),
  ('Summer Travel Plans', 'Admin', 'Planning a trip to Europe this summer. Looking for recommendations on must-visit places in Paris and Rome. Any suggestions would be appreciated!', 'travel'),
  ('Project Collaboration Guidelines', 'Admin', 'Here are some guidelines for our collaborative documents: 1) Be respectful in comments, 2) Use constructive feedback, 3) Rate honestly, 4) Share your thoughts freely!', 'document'),
  ('Weekend Hiking Event', 'Admin', 'Join us this Saturday for a morning hike at the local nature reserve! We''ll meet at the parking lot at 8 AM. Bring water, snacks, and good hiking shoes. See you there!', 'event'),
  ('Book Review: "The Alchemist"', 'Admin', 'Just finished reading this amazing book. The journey of Santiago really resonated with me. The themes of following your dreams and listening to your heart are beautifully woven throughout the story. Highly recommend!', 'article'),
  ('Recipe: Homemade Pizza', 'Admin', 'Here''s my secret recipe for the perfect homemade pizza: Start with a good dough (let it rise overnight), use fresh mozzarella, and don''t skimp on the sauce. Bake at 450°F for 12-15 minutes. Delicious!', 'article'),
  ('Team Meeting Notes', 'Admin', 'Key points from today''s meeting: 1) New features planned for next month, 2) Everyone should review the design mockups, 3) Next meeting scheduled for Friday at 2 PM. Please confirm your attendance.', 'update');
```

### 4. Set Up Storage

1. Go to Storage in your Supabase dashboard
2. Create a new bucket called `documents`
3. Make it public (toggle the public option)

### 5. Deploy

#### Option A: Vercel (Recommended)
1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel` in the project directory
3. Follow the prompts to deploy

#### Option B: Netlify
1. Drag and drop the `index.html` file to [netlify.com/drop](https://app.netlify.com/drop)
2. Your site will be live instantly!

#### Option C: GitHub Pages
1. Create a new GitHub repository
2. Upload `index.html`
3. Enable GitHub Pages in Settings
4. Your site will be at `https://yourusername.github.io/repository-name`

## Default Credentials

### Admin Accounts
- **Username**: admin1, **Password**: insync2024
- **Username**: admin2, **Password**: insync2024

### Regular User Accounts
- **Username**: user1, **Password**: insync2024
- **Username**: user2, **Password**: insync2024
- **Username**: user3, **Password**: insync2024

## User Roles

### Regular Users
- Create and view documents
- Leave comments and ratings
- Search and filter documents
- Upload photos

### Admin Users
- All regular user features
- Access admin panel
- Create new users
- Manage passwords
- Delete users

## Environment Setup

For production deployment, you can use environment variables:

1. Create a `.env` file (not included in repo for security):
   ```
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   ```

2. Update `index.html` to read from environment variables if using a build tool

## Categories

Documents can be organized into these categories:
- **Travel**: Travel logs and experiences
- **Document**: Collaborative documents and drafts
- **Article**: Articles and blog posts
- **Event**: Event announcements and flyers
- **Update**: Personal updates and news

## Security Notes

⚠️ **Important**: 
- Passwords are stored in plain text in this version for simplicity
- For production use, implement password hashing (bcrypt, argon2, etc.)
- Consider using Supabase Auth for better security
- Enable Row Level Security (RLS) policies in Supabase

## Troubleshooting

### "Failed to load documents"
- Check that your Supabase URL and key are correct
- Verify tables were created successfully
- Check browser console for detailed errors

### "Storage upload failed"
- Ensure the `documents` bucket exists in Supabase Storage
- Make sure the bucket is set to public
- Check file size limits

### "Login not working"
- Verify users were created in the database
- Check that password matches exactly
- Look for errors in browser console

## Support

For issues or questions:
1. Check the browser console (F12) for errors
2. Verify Supabase configuration
3. Ensure all tables and storage buckets are set up correctly

## Version

Current version: **v2.00**

## License

This project is provided as-is for personal use.

