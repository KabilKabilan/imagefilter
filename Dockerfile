# Multi-stage build for Next.js application
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat python3 make g++
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json package-lock.json* ./
RUN \
  if [ -f package-lock.json ]; then npm ci; \
  else echo "Lockfile not found." && exit 1; \
  fi

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Set build-time environment variables
ARG MODEL_API_KEY
ARG S3_BUCKET
ENV NEXT_PUBLIC_MODEL_API_KEY=$MODEL_API_KEY
ENV NEXT_PUBLIC_S3_BUCKET=$S3_BUCKET

# Disable telemetry during build
ENV NEXT_TELEMETRY_DISABLED 1

# Build the application
RUN npm run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1

# Create a non-root user
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Create necessary directories with correct permissions
RUN mkdir -p /app/uploads /app/cache /app/.next /app/public
RUN chown -R nextjs:nodejs /app/uploads /app/cache /app/.next /app/public

# Copy package.json for npm start fallback
COPY --from=builder --chown=nextjs:nodejs /app/package.json ./package.json

# Copy necessary files
COPY --from=builder --chown=nextjs:nodejs /app/public ./public

# Copy build output
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Copy node_modules for fallback
COPY --from=deps --chown=nextjs:nodejs /app/node_modules ./node_modules

# Copy Python scripts
COPY --from=builder --chown=nextjs:nodejs /app/scripts ./scripts

# Copy entrypoint script
COPY --chown=nextjs:nodejs docker-entrypoint.sh ./docker-entrypoint.sh
RUN chmod +x ./docker-entrypoint.sh

# Set correct permissions
RUN chown -R nextjs:nodejs /app

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# Start the application
ENTRYPOINT ["./docker-entrypoint.sh"]

