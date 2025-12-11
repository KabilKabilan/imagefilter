# Uploads Directory Setup

## Overview

The `/uploads` directory is used to store user-uploaded image files during development. Files are saved with UUID filenames to prevent naming conflicts.

## Setup Instructions

### Option 1: Automatic Creation (Recommended)

The uploads directory will be created automatically when the first file is uploaded. No manual setup is required.

### Option 2: Manual Creation

If you prefer to create the directory manually:

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Path "uploads"
```

**Windows (Command Prompt):**
```cmd
mkdir uploads
```

**macOS/Linux:**
```bash
mkdir uploads
```

## Directory Structure

```
project/
├── uploads/          # User-uploaded files (auto-created)
│   ├── {uuid}.jpg    # Example: a1b2c3d4-e5f6-7890-abcd-ef1234567890.jpg
│   └── {uuid}.png    # Example: f9e8d7c6-b5a4-3210-9876-543210fedcba.png
└── ...
```

## File Naming

- Files are saved with UUID filenames (e.g., `a1b2c3d4-e5f6-7890-abcd-ef1234567890.jpg`)
- Original filenames are not preserved for security and uniqueness
- File extensions are preserved based on the uploaded file type

## Accessing Uploaded Files

Uploaded files are accessible via:
- URL: `http://localhost:3000/uploads/{uuid}.{ext}`
- Path: `uploads/{uuid}.{ext}` (relative to project root)

## Important Notes

1. **Development Only**: This setup is for development. In production, use:
   - Cloud storage (AWS S3, Google Cloud Storage, Azure Blob Storage)
   - CDN services (Cloudinary, Imgix)
   - Object storage solutions

2. **Git Ignore**: The `/uploads` directory is excluded from git (see `.gitignore`)

3. **Security**: 
   - Files are validated (type and size) before saving
   - UUID filenames prevent directory traversal attacks
   - Consider adding authentication/authorization in production

4. **Cleanup**: Old files should be periodically cleaned up in production

## Production Recommendations

For production deployment, modify `lib/utils/fileUtils.ts` to:
- Upload to cloud storage instead of local filesystem
- Return cloud storage URLs instead of local paths
- Implement file cleanup policies
- Add access control and authentication

Example cloud storage integration:
```typescript
// Example: AWS S3 integration
import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3'

export async function saveFile(file: File): Promise<SaveFileResult> {
  const s3Client = new S3Client({ region: 'us-east-1' })
  const id = randomUUID()
  const extension = getFileExtension(file)
  
  const buffer = Buffer.from(await file.arrayBuffer())
  
  await s3Client.send(new PutObjectCommand({
    Bucket: process.env.S3_BUCKET_NAME,
    Key: `${id}.${extension}`,
    Body: buffer,
    ContentType: file.type,
  }))
  
  return {
    id,
    extension,
    url: `https://${process.env.S3_BUCKET_NAME}.s3.amazonaws.com/${id}.${extension}`,
  }
}
```

