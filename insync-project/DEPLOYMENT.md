# Deployment Guide for Insync

This guide covers deploying your Insync application to various platforms.

## Prerequisites

1. ✅ Supabase project created and configured
2. ✅ Database tables created (run `supabase-setup.sql`)
3. ✅ Storage bucket `documents` created and set to public
4. ✅ Supabase URL and anon key ready

## Deployment Options

### Option 1: Vercel (Recommended) ⭐

Vercel is the easiest and most reliable option for hosting static sites.

#### Steps:

1. **Install Vercel CLI**
   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**
   ```bash
   vercel login
   ```

3. **Deploy**
   ```bash
   cd /Users/seth/Documents/Insync
   vercel
   ```

4. **Follow the prompts:**
   - Set up and deploy? **Yes**
   - Which scope? **Your account**
   - Link to existing project? **No**
   - Project name? **isync** (or your choice)
   - Directory? **./**
   - Override settings? **No**

5. **Your site is live!** 🎉
   - You'll get a URL like: `https://isync.vercel.app`

6. **Optional: Add custom domain**
   - Go to your project settings in Vercel dashboard
   - Add your custom domain

#### Benefits:
- ✅ Free tier available
- ✅ Automatic HTTPS
- ✅ Global CDN
- ✅ Easy to update (just run `vercel` again)

---

### Option 2: Netlify

Netlify is another excellent option with a simple drag-and-drop interface.

#### Steps:

1. **Go to Netlify Drop**
   - Visit: https://app.netlify.com/drop

2. **Drag and drop**
   - Drag your `index.html` file directly to the page

3. **That's it!** 🎉
   - Your site is live instantly
   - You'll get a random URL like: `https://random-name-123.netlify.app`

#### For more control:

1. **Install Netlify CLI**
   ```bash
   npm install -g netlify-cli
   ```

2. **Login**
   ```bash
   netlify login
   ```

3. **Deploy**
   ```bash
   netlify deploy
   ```

4. **For production**
   ```bash
   netlify deploy --prod
   ```

#### Benefits:
- ✅ Free tier available
- ✅ Automatic HTTPS
- ✅ Continuous deployment from Git
- ✅ Form handling

---

### Option 3: GitHub Pages

Perfect if you want to use GitHub for version control.

#### Steps:

1. **Create GitHub repository**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/yourusername/isync.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**
   - Go to your repository on GitHub
   - Click **Settings** tab
   - Scroll to **Pages** section
   - Source: **Deploy from a branch**
   - Branch: **main** / **(root)**
   - Click **Save**

3. **Your site is live!** 🎉
   - URL: `https://yourusername.github.io/isync`

#### Benefits:
- ✅ Free
- ✅ Integrated with Git
- ✅ Easy to update (just push changes)

---

### Option 4: Cloudflare Pages

Fast and reliable hosting with great free tier.

#### Steps:

1. **Install Wrangler CLI**
   ```bash
   npm install -g wrangler
   ```

2. **Login**
   ```bash
   wrangler login
   ```

3. **Deploy**
   ```bash
   wrangler pages deploy . --project-name=isync
   ```

#### Benefits:
- ✅ Free tier available
- ✅ Extremely fast CDN
- ✅ Automatic HTTPS
- ✅ Easy to use

---

### Option 5: Firebase Hosting

Google's hosting platform with great integration options.

#### Steps:

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **Login**
   ```bash
   firebase login
   ```

3. **Initialize**
   ```bash
   firebase init hosting
   ```
   - Select existing project or create new
   - Public directory: **.**
   - Single-page app: **No**
   - Overwrite index.html: **No**

4. **Deploy**
   ```bash
   firebase deploy
   ```

#### Benefits:
- ✅ Free tier available
- ✅ Fast global CDN
- ✅ Easy integration with other Firebase services

---

## Post-Deployment Checklist

After deploying, make sure to:

- [ ] Test login with all user accounts
- [ ] Create a test document
- [ ] Upload a photo
- [ ] Leave a comment with rating
- [ ] Test search and filter functionality
- [ ] Test admin panel (if logged in as admin)
- [ ] Check mobile responsiveness
- [ ] Verify HTTPS is working
- [ ] Test tutorial overlay

## Environment Variables (Advanced)

For better security, you can use environment variables:

### Vercel:
1. Go to project settings
2. Click **Environment Variables**
3. Add:
   - `SUPABASE_URL`: Your Supabase URL
   - `SUPABASE_ANON_KEY`: Your Supabase anon key

### Netlify:
1. Go to site settings
2. Click **Environment variables**
3. Add the same variables

Then modify `index.html` to read from these variables (requires a build step).

## Troubleshooting

### "Failed to fetch" errors
- Check Supabase URL and key are correct
- Ensure CORS is enabled in Supabase
- Check browser console for specific errors

### Photos not uploading
- Verify storage bucket exists
- Ensure bucket is set to public
- Check file size limits (Supabase default: 50MB)

### Deployment fails
- Check that `index.html` is in the root directory
- Ensure you're logged in to the platform
- Check platform status page

## Updating Your Site

### Vercel:
```bash
vercel --prod
```

### Netlify:
```bash
netlify deploy --prod
```

### GitHub Pages:
```bash
git add .
git commit -m "Update site"
git push
```

## Performance Tips

1. **Enable Supabase CDN** for storage
2. **Use image optimization** (add image compression)
3. **Enable browser caching** in platform settings
4. **Use a CDN** (all platforms above include this)

## Security Recommendations

1. ✅ Use HTTPS (automatic on all platforms above)
2. ⚠️ Implement password hashing for production
3. ⚠️ Enable Row Level Security (RLS) in Supabase
4. ⚠️ Add rate limiting
5. ⚠️ Implement CSRF protection
6. ⚠️ Use environment variables for sensitive data

## Support

If you encounter issues:
1. Check the platform's status page
2. Review browser console errors
3. Verify Supabase configuration
4. Check platform documentation

## Recommended Platform

**For most users**: Vercel
- Easiest to set up
- Great free tier
- Excellent performance
- Simple updates

**For Git users**: GitHub Pages
- Integrated with version control
- Easy collaboration
- Simple workflow

**For beginners**: Netlify Drop
- Literally drag and drop
- Instant deployment
- No command line needed

