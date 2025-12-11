# Deployment Guide

This guide covers deploying TimeTravelAR to different platforms.

## Prerequisites

- Node.js 20+ installed locally
- Docker and Docker Compose (for VPS deployment)
- GitHub account (for CI/CD)
- Vercel account (for serverless deployment)

## Environment Variables

Set these environment variables before deployment:

```bash
# Required for image processing
REPLICATE_API_TOKEN=your_replicate_token
# OR
HUGGINGFACE_API_TOKEN=your_huggingface_token

# Optional
MODEL_API_KEY=your_model_api_key
S3_BUCKET=your_s3_bucket_name
REDIS_URL=redis://localhost:6379
```

## Option 1: Deploy to Vercel (Serverless)

Vercel is recommended for serverless deployment with automatic scaling.

### Steps:

1. **Install Vercel CLI** (optional, for local deployment):
   ```bash
   npm i -g vercel
   ```

2. **Connect GitHub Repository**:
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Vercel will auto-detect Next.js

3. **Configure Environment Variables**:
   - In Vercel dashboard, go to Project Settings → Environment Variables
   - Add all required environment variables:
     - `REPLICATE_API_TOKEN` or `HUGGINGFACE_API_TOKEN`
     - `MODEL_API_KEY` (optional)
     - `S3_BUCKET` (optional)
     - `REDIS_URL` (optional, for job queue)

4. **Deploy**:
   - Push to `main` branch (auto-deploys)
   - Or use Vercel CLI: `vercel --prod`

5. **Configure File Storage**:
   - Vercel has limited file system access
   - Use S3 or similar for `/uploads` and `/cache`
   - Update `lib/utils/fileUtils.ts` to use S3 instead of local filesystem

### Vercel Configuration File

Create `vercel.json` in project root:

```json
{
  "buildCommand": "npm run build",
  "devCommand": "npm run dev",
  "installCommand": "npm ci",
  "framework": "nextjs",
  "regions": ["iad1"],
  "functions": {
    "app/api/**/*.ts": {
      "maxDuration": 60
    }
  }
}
```

### Limitations:

- **File System**: Vercel is serverless, so `/uploads` and `/cache` won't persist
- **Solution**: Use S3 or similar cloud storage
- **Python Scripts**: Not supported on Vercel serverless functions
- **Solution**: Use external API services or move Python processing to separate service

### Recommended Architecture for Vercel:

```
Vercel (Next.js API Routes)
  ↓
External Processing Service (Python scripts)
  ↓
S3 (File Storage)
  ↓
Redis (Job Queue - optional)
```

## Option 2: Deploy to VPS with Docker

For full control and Python script support, deploy to a VPS.

### Prerequisites:

- VPS with Docker and Docker Compose installed
- Domain name (optional, for SSL)
- SSH access to VPS

### Steps:

1. **Clone Repository on VPS**:
   ```bash
   git clone https://github.com/yourusername/timetravelar.git
   cd timetravelar
   ```

2. **Create Environment File**:
   ```bash
   cp .env.example .env
   nano .env
   ```
   
   Add your environment variables:
   ```bash
   REPLICATE_API_TOKEN=your_token
   HUGGINGFACE_API_TOKEN=your_token
   MODEL_API_KEY=your_key
   S3_BUCKET=your_bucket
   REDIS_URL=redis://redis:6379
   ```

3. **Build and Start Containers**:
   ```bash
   docker-compose up -d --build
   ```

4. **Check Logs**:
   ```bash
   docker-compose logs -f app
   ```

5. **Verify Health**:
   ```bash
   curl http://localhost:3000/api/health
   ```

### Nginx Reverse Proxy (Recommended)

Create `/etc/nginx/sites-available/timetravelar`:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Increase timeouts for image processing
        proxy_connect_timeout 300s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }
}
```

Enable and restart:
```bash
sudo ln -s /etc/nginx/sites-available/timetravelar /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### SSL with Let's Encrypt:

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

### Persistent Storage:

The `docker-compose.yml` mounts volumes for persistence:
- `./uploads` → `/app/uploads`
- `./cache` → `/app/cache`
- `redis-data` → Redis persistence

### Updating the Application:

```bash
git pull origin main
docker-compose up -d --build
```

### Monitoring:

- Health check: `curl http://localhost:3000/api/health`
- Container logs: `docker-compose logs -f`
- Container stats: `docker stats`

## Option 3: Hybrid Deployment

Deploy Next.js frontend to Vercel, processing API to VPS:

1. **Frontend (Vercel)**:
   - Next.js app with UI
   - API routes proxy to VPS

2. **Processing Service (VPS)**:
   - Docker container with Python scripts
   - Handles image processing
   - Uses Redis for job queue

## CI/CD with GitHub Actions

The `.github/workflows/ci.yml` workflow automatically:
- Lints code on push
- Runs tests
- Builds application
- Builds Docker image (on main branch)

### Setup GitHub Secrets:

1. Go to Repository → Settings → Secrets and variables → Actions
2. Add secrets:
   - `MODEL_API_KEY`
   - `S3_BUCKET`
   - `REPLICATE_API_TOKEN`
   - `HUGGINGFACE_API_TOKEN`

## Troubleshooting

### Docker Build Fails:

```bash
# Check Docker logs
docker-compose logs app

# Rebuild without cache
docker-compose build --no-cache
```

### Python Scripts Not Working:

```bash
# Check Python is installed in container
docker-compose exec app python --version

# Install Python dependencies
docker-compose exec app pip install -r scripts/requirements.txt
```

### Port Already in Use:

```bash
# Change port in docker-compose.yml
ports:
  - "3001:3000"  # Use port 3001 instead
```

### Out of Memory:

```bash
# Increase Docker memory limit
# Or optimize image processing (reduce candidates)
```

## Production Checklist

- [ ] Set all environment variables
- [ ] Configure file storage (S3 or local)
- [ ] Set up SSL certificate
- [ ] Configure reverse proxy (Nginx)
- [ ] Set up monitoring/alerting
- [ ] Configure backups for uploads/cache
- [ ] Set up log aggregation
- [ ] Configure rate limiting
- [ ] Test health check endpoint
- [ ] Test image processing pipeline
- [ ] Configure auto-scaling (if needed)

## Performance Optimization

1. **Enable Caching**: Already implemented in code
2. **Use CDN**: For static assets
3. **Optimize Images**: Use Next.js Image component
4. **Database**: Use Redis for job queue
5. **File Storage**: Use S3 for production
6. **Load Balancing**: Use multiple instances behind load balancer

## Security Considerations

- Never commit `.env` files
- Use secrets management (Vercel, AWS Secrets Manager)
- Enable HTTPS
- Set up rate limiting
- Validate all file uploads
- Sanitize user inputs
- Regular security updates

