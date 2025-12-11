# Inpainting Mode Setup Guide

## Overview

The TimeTravelAR pipeline now uses **inpainting mode** instead of image-to-image to ensure visible age progression. This mode:
- Only replaces the face region (not the entire image)
- Uses higher denoising strength (0.6-0.75) for visible aging
- Requires a face mask extracted using MediaPipe or face-landmarks-detection

## Key Changes

### 1. Denoising Strength
- **Old**: 0.2-0.4 (too low, resulted in identical images)
- **New**: 0.6-0.75 (higher, allows visible aging changes)
- **Config**: Set `SD_DENOISING_STRENGTH=0.65` in `.env.local`

### 2. Inpainting Mode
- **Old**: Image-to-image (transforms entire image)
- **New**: Inpainting (only replaces masked face region)
- **Benefit**: Background and non-face areas remain unchanged

### 3. Face Mask Extraction
- Uses MediaPipe Face Mesh for accurate face mask
- Falls back to OpenCV face detection if MediaPipe unavailable
- Mask is feathered for smooth blending

### 4. Updated Prompts
- **Aging Prompt**: "Hyperrealistic portrait of [FACE], aged +25 years, deeper wrinkles, visible aging signs, realistic skin texture, graying hair, cinematic lighting, ultra detailed."
- **Negative Prompt**: "cartoon, smooth skin, young face, lowres, blurry, watermark"
- Prevents smooth/young faces and ensures visible aging

## Installation

### Python Dependencies

```bash
# Install MediaPipe for face mask extraction
pip install mediapipe opencv-python numpy pillow

# Or use face-landmarks-detection as alternative
pip install face-landmarks-detection opencv-python numpy pillow
```

### Environment Variables

Add to `.env.local`:

```bash
# Denoising strength (0.6-0.75 recommended)
SD_DENOISING_STRENGTH=0.65

# Replicate model (use inpainting model)
REPLICATE_MODEL_VERSION=runwayml/stable-diffusion-inpainting

# Or for Hugging Face
HF_MODEL_ID=runwayml/stable-diffusion-inpainting
```

## How It Works

1. **Face Detection**: Detects face and extracts landmarks
2. **Mask Extraction**: Creates face mask using MediaPipe/landmarks
3. **Inpainting**: Uses Stable Diffusion inpainting to replace ONLY the masked face region
4. **Higher Denoising**: 0.6-0.75 strength allows visible aging changes
5. **Face Enhancement**: Applies GFPGAN to enhance the aged face
6. **Final Blending**: Blends enhanced face onto inpainted result

## API Models

### Replicate
- **Model**: `runwayml/stable-diffusion-inpainting`
- **Input**: Original image + mask image
- **Output**: Full image with face region replaced

### Hugging Face
- **Model**: `runwayml/stable-diffusion-inpainting`
- **Input**: Original image + mask image
- **Output**: Full image with face region replaced

## Troubleshooting

### Issue: Still getting identical images
- **Check**: Denoising strength should be 0.6-0.75
- **Check**: Verify mask is being created correctly
- **Check**: Ensure inpainting model is being used (not image-to-image)

### Issue: Face mask extraction fails
- **Solution**: Install MediaPipe: `pip install mediapipe`
- **Fallback**: Script will use OpenCV face detection

### Issue: Processing takes too long
- **Normal**: Inpainting can take 30-60 seconds
- **Optimization**: Reduce `SD_NUM_CANDIDATES` to 1

### Issue: Face looks distorted
- **Check**: Face mask should cover entire face including hair
- **Check**: Denoising strength might be too high (>0.75)
- **Solution**: Try denoising strength 0.6-0.7

## Testing

Test the inpainting pipeline:

```bash
# Check face mask extraction
python scripts/face_mask.py test_image.jpg output_mask.png

# Verify mask is created
# Should see white area covering face region
```

## Expected Results

With these changes, you should see:
- ✅ Visible wrinkles and aging signs
- ✅ Graying hair
- ✅ Realistic skin texture changes
- ✅ Background remains unchanged
- ✅ Clear age progression (not identical to original)

