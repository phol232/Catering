# Supabase Storage Setup for Event Images

This document provides instructions for setting up the Supabase Storage bucket for event images.

## Prerequisites

- Access to your Supabase project dashboard
- Admin privileges to create storage buckets and policies

## Setup Instructions

### Option 1: Using Supabase Dashboard (Recommended for first-time setup)

1. **Navigate to Storage**
   - Log in to your Supabase project at https://app.supabase.com
   - Click on "Storage" in the left sidebar

2. **Create New Bucket**
   - Click "New bucket"
   - Bucket name: `event-images`
   - Set as Public: ✓ (checked)
   - Click "Create bucket"

3. **Configure Policies**
   - Click on the `event-images` bucket
   - Go to "Policies" tab
   - Click "New policy"
   - Create the following policies:

   **Policy 1: Allow authenticated users to upload**
   - Policy name: `Authenticated users can upload event images`
   - Allowed operation: INSERT
   - Target roles: authenticated
   - USING expression: `bucket_id = 'event-images'`

   **Policy 2: Allow public read access**
   - Policy name: `Public can view event images`
   - Allowed operation: SELECT
   - Target roles: public
   - USING expression: `bucket_id = 'event-images'`

   **Policy 3: Allow authenticated users to delete**
   - Policy name: `Authenticated users can delete event images`
   - Allowed operation: DELETE
   - Target roles: authenticated
   - USING expression: `bucket_id = 'event-images'`

   **Policy 4: Allow authenticated users to update**
   - Policy name: `Authenticated users can update event images`
   - Allowed operation: UPDATE
   - Target roles: authenticated
   - USING expression: `bucket_id = 'event-images'`

### Option 2: Using SQL Editor

1. Navigate to "SQL Editor" in your Supabase dashboard
2. Copy and paste the contents of `storage_setup.sql`
3. Click "Run" to execute the script

## Verification

After setup, verify the bucket is working:

1. Go to Storage → event-images
2. Try uploading a test image manually
3. Check that the image is publicly accessible via its URL

## Bucket Configuration

- **Bucket Name**: `event-images`
- **Public Access**: Enabled
- **File Size Limit**: Default (50MB)
- **Allowed MIME Types**: All image types (jpg, png, webp, etc.)

## Security Notes

- Only authenticated users can upload, update, or delete images
- All users (including anonymous) can view images (public bucket)
- Images are automatically compressed by the app before upload (max 2MB)
- Unique filenames are generated using timestamp + UUID to prevent conflicts

## Troubleshooting

### Images not uploading
- Check that the user is authenticated
- Verify the bucket name is exactly `event-images`
- Check Supabase project URL and anon key in `.env` file

### Images not displaying
- Verify the bucket is set to public
- Check the image URL format: `https://[project-ref].supabase.co/storage/v1/object/public/event-images/[filename]`
- Ensure the SELECT policy is active

### Permission errors
- Verify all four policies are created and enabled
- Check that the authenticated user has a valid session token
