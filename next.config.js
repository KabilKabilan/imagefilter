/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable React strict mode for better development experience
  reactStrictMode: true,
  // TypeScript configuration
  typescript: {
    // Set to true to ignore TypeScript errors during build (not recommended for production)
    ignoreBuildErrors: false,
  },
  // ESLint configuration
  eslint: {
    // Set to true to ignore ESLint errors during build (not recommended for production)
    ignoreDuringBuilds: false,
  },
  // Serve static files from uploads directory
  // Note: In production, use a proper file storage solution (S3, Cloudinary, etc.)
  // Enable standalone output for Docker
  output: process.env.DOCKER_BUILD === 'true' ? 'standalone' : undefined,
}

module.exports = nextConfig

