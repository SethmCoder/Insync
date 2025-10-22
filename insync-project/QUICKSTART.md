# Insync Quick Start Guide

Get your Insync application running in 5 minutes! ⚡

## Step 1: Create Supabase Project (2 minutes)

1. Go to https://supabase.com
2. Click **"Start your project"** or **"New project"**
3. Fill in:
   - Project name: `isync`
   - Database password: (choose a strong password)
   - Region: (choose closest to you)
4. Click **"Create new project"**
5. Wait for project to be ready (takes ~2 minutes)

## Step 2: Get Your Credentials (1 minute)

1. In your Supabase project, click **Settings** (gear icon)
2. Click **API** in the sidebar
3. Copy these two values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public** key (long string starting with `eyJ...`)

## Step 3: Set Up Database (1 minute)

1. In Supabase, click **SQL Editor** in the sidebar
2. Click **"New query"**
3. Copy the entire contents of `supabase-setup.sql`
4. Paste into the SQL editor
5. Click **"Run"** (or press Cmd/Ctrl + Enter)
6. You should see: "Database setup complete!"

## Step 4: Set Up Storage (1 minute)

1. Click **Storage** in the sidebar
2. Click **"Create a new bucket"**
3. Name it: `documents`
4. Make it **Public** (toggle the switch)
5. Click **"Create bucket"**

## Step 5: Configure Your App (30 seconds)

1. Open `index.html` in any text editor
2. Find these lines (around line 35):
   ```javascript
   const SUPABASE_URL = 'YOUR_SUPABASE_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY';
   ```
3. Replace with your actual values:
   ```javascript
   const SUPABASE_URL = 'https://xxxxx.supabase.co';
   const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```
4. Save the file

## Step 6: Test Locally (30 seconds)

1. Open `index.html` in your web browser
   - On Mac: Right-click → Open with → Browser
   - On Windows: Double-click the file
   - Or drag the file into your browser

2. Try logging in with:
   - Username: `admin1`
   - Password: `insync2024`

3. You should see the dashboard! 🎉

## Step 7: Deploy (Optional - 2 minutes)

### Easiest Option: Vercel

1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```

2. Deploy:
   ```bash
   cd /Users/seth/Documents/Insync
   vercel
   ```

3. Follow the prompts and you're done!

### Alternative: Netlify Drop

1. Go to https://app.netlify.com/drop
2. Drag `index.html` to the page
3. Done! You'll get a URL instantly

## Default Login Credentials

### Admin Accounts (can manage users and passwords)
- **Username**: `admin1` | **Password**: `insync2024`
- **Username**: `admin2` | **Password**: `insync2024`

### Regular Users (can create and comment on documents)
- **Username**: `user1` | **Password**: `insync2024`
- **Username**: `user2` | **Password**: `insync2024`
- **Username**: `user3` | **Password**: `insync2024`

## What You Can Do Now

✅ **Create Documents**: Write posts, travel logs, articles, event flyers  
✅ **Upload Photos**: Add multiple images to your documents  
✅ **Comment & Rate**: Leave feedback with 5-star ratings  
✅ **Search & Filter**: Find documents by keyword or category  
✅ **Manage Users**: (Admin only) Create new users and change passwords  
✅ **Tutorial**: Click "Tutorial" button for a guided walkthrough  

## Troubleshooting

### "Failed to load documents"
- Double-check your Supabase URL and key in `index.html`
- Make sure you ran the SQL setup script
- Open browser console (F12) to see detailed errors

### "Storage upload failed"
- Go to Supabase → Storage
- Make sure the `documents` bucket exists
- Make sure it's set to public

### "Login not working"
- Try the exact credentials listed above
- Check that users were created (go to Supabase → Table Editor → users)

### Photos not showing
- Make sure the storage bucket is public
- Check file size (max 50MB per file)
- Look for errors in browser console

## Next Steps

1. **Create your first document** - Click "Create New Document"
2. **Add sample photos** - Upload some images
3. **Leave a comment** - Click on a document and add feedback
4. **Create new users** - (Admin) Use the Admin panel
5. **Customize** - Edit `index.html` to change colors, fonts, etc.

## Need Help?

1. Check the full README.md for detailed information
2. See DEPLOYMENT.md for deployment options
3. Open browser console (F12) for error messages
4. Check Supabase logs in your project dashboard

## Security Note

⚠️ This version uses simple password authentication for ease of use. For production:
- Implement password hashing (bcrypt, argon2)
- Enable Row Level Security in Supabase
- Use Supabase Auth for better security
- Add rate limiting

---

**You're all set!** 🚀

Enjoy sharing and collaborating with Insync!

