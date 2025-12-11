# TimeTravelAR

A Next.js web application built with TypeScript and Tailwind CSS.

## Prerequisites

- Node.js 18.x or higher
- npm, yarn, or pnpm package manager

## Setup

1. Install dependencies:
   ```bash
   npm install
   # or
   yarn install
   # or
   pnpm install
   ```

## Development

Run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser to see the application.

## Build

Create a production build:

```bash
npm run build
# or
yarn build
# or
pnpm build
```

## Start Production Server

Start the production server (after building):

```bash
npm run start
# or
yarn start
# or
pnpm start
```

## Lint

Run ESLint to check for code issues:

```bash
npm run lint
# or
yarn lint
# or
pnpm lint
```

## Project Structure

```
TimeTravelAR/
├── app/
│   ├── layout.tsx      # Root layout component
│   ├── page.tsx        # Homepage
│   ├── upload/
│   │   └── page.tsx    # Upload page
│   └── globals.css     # Global styles with Tailwind
├── next.config.js      # Next.js configuration
├── tailwind.config.js  # Tailwind CSS configuration
├── tsconfig.json       # TypeScript configuration
└── package.json        # Project dependencies and scripts
```

## Technologies

- **Next.js 14** - React framework with App Router
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework

---

## 🚀 Final Setup Checklist

Follow these 12 steps to get TimeTravelAR up and running:

### ✅ Step 1: Prerequisites Check
- [ ] Node.js 18.x or higher installed (`node --version`)
- [ ] npm, yarn, or pnpm package manager installed
- [ ] Python 3.8+ installed (for image processing scripts) (`python --version`)
- [ ] Git installed (for cloning repository)

### ✅ Step 2: Clone and Install
```bash
# Clone repository
git clone <your-repo-url>
cd timetravelar

# Install Node.js dependencies
npm install

# Install Python dependencies (optional, for full pipeline)
pip install -r scripts/requirements.txt
```

### ✅ Step 3: Environment Variables Setup
Create a `.env.local` file in the project root:
```bash
# Required for image processing (choose one)
REPLICATE_API_TOKEN=your_replicate_token_here
# OR
HUGGINGFACE_API_TOKEN=your_huggingface_token_here

# Optional
MODEL_API_KEY=your_model_api_key
S3_BUCKET=your_s3_bucket_name
REDIS_URL=redis://localhost:6379

# Optional: Processing configuration
SD_DENOISING_STRENGTH=0.3
SD_NUM_CANDIDATES=2
GFPGAN_MODEL_PATH=/path/to/gfpgan/model.pth
```

**Where to get API tokens:**
- Replicate: https://replicate.com/account/api-tokens
- Hugging Face: https://huggingface.co/settings/tokens

### ✅ Step 4: Create Required Directories
```bash
# These will be created automatically, but you can create manually:
mkdir -p uploads cache
```

### ✅ Step 5: Verify TypeScript Configuration
```bash
# Check TypeScript compilation
npx tsc --noEmit
```

### ✅ Step 6: Run Development Server
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

### ✅ Step 7: Test the Application
1. Navigate to `/upload` page
2. Upload a test image (JPEG or PNG, max 8MB)
3. Select aging style and background style
4. Click "Process Image"
5. Verify processed image appears

### ✅ Step 8: Run Tests
```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run specific test file
npm test -- route.test.ts
```

### ✅ Step 9: Lint and Build
```bash
# Check code quality
npm run lint

# Build for production
npm run build

# Start production server
npm run start
```

### ✅ Step 10: Health Check
```bash
# Check API health
curl http://localhost:3000/api/health

# Expected response:
# {
#   "status": "healthy" | "degraded" | "unhealthy",
#   "services": { ... }
# }
```

### ✅ Step 11: Debug Tips

**Common Issues:**

1. **"Python not found" error:**
   ```bash
   # Verify Python is in PATH
   which python
   # Or use python3
   which python3
   ```

2. **"Module not found" errors:**
   ```bash
   # Reinstall dependencies
   rm -rf node_modules package-lock.json
   npm install
   ```

3. **"API token invalid" error:**
   - Check `.env.local` file exists
   - Verify token is correct (no extra spaces)
   - Restart dev server after changing env vars

4. **"File upload fails":**
   - Check file size (must be ≤ 8MB)
   - Verify file type (JPEG or PNG only)
   - Check `/uploads` directory permissions

5. **"Processing fails":**
   - Check health endpoint: `/api/health`
   - Verify Python scripts are executable: `chmod +x scripts/*.py`
   - Check logs in terminal for detailed errors

6. **"Cache not working":**
   - Verify `/cache` directory exists and is writable
   - Check disk space availability

**Debug Commands:**
```bash
# Check Node.js version
node --version

# Check npm version
npm --version

# View environment variables (don't commit this!)
cat .env.local

# Check if ports are in use
lsof -i :3000

# View Next.js build output
npm run build 2>&1 | tee build.log
```

### ✅ Step 12: Deployment

**Option A: Deploy to Vercel (Serverless)**
1. Push code to GitHub
2. Connect repository to Vercel
3. Add environment variables in Vercel dashboard
4. Deploy automatically on push to main

**Option B: Deploy to VPS with Docker**
```bash
# Build Docker image
docker-compose build

# Start services
docker-compose up -d

# Check logs
docker-compose logs -f app

# Verify health
curl http://localhost:3000/api/health
```

See `DEPLOYMENT.md` for detailed deployment instructions.

---

## 🎯 Quick Start (TL;DR)

```bash
# 1. Install
npm install

# 2. Create .env.local with API tokens
echo "REPLICATE_API_TOKEN=your_token" > .env.local

# 3. Run
npm run dev

# 4. Test
npm test

# 5. Build
npm run build
```

---

## 📚 Additional Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Deployment Guide](./DEPLOYMENT.md)
- [Social Media Content](./SOCIAL_MEDIA_CONTENT.md)

"# imagefilter" 
"# imagefilter" 
"# imagefilter" 
"# imagefilter" 
"# imagefilter" 
