# Supabase Storage Setup Guide

## Overview

OnCall Lab requires 3 storage buckets for handling file uploads:

1. **profile-photos** - User profile pictures (public)
2. **doctor-certificates** - Medical licenses and diplomas (private)
3. **lab-reports** - Test results and reports (private)

---

## Step 1: Create Storage Buckets via Supabase Dashboard

Go to your Supabase project dashboard: https://supabase.com/dashboard

### 1. Profile Photos Bucket

1. Navigate to **Storage** in the left sidebar
2. Click **New Bucket**
3. Configure:
   - **Name**: `profile-photos`
   - **Public bucket**: ✅ **Enabled** (so photos can be accessed via URL)
   - **File size limit**: `5 MB`
   - **Allowed MIME types**: `image/jpeg, image/jpg, image/png, image/webp`
4. Click **Create bucket**

### 2. Doctor Certificates Bucket

1. Click **New Bucket**
2. Configure:
   - **Name**: `doctor-certificates`
   - **Public bucket**: ❌ **Disabled** (private - only admins and doctor can view)
   - **File size limit**: `10 MB`
   - **Allowed MIME types**: `image/jpeg, image/jpg, image/png, image/webp, application/pdf`
3. Click **Create bucket**

### 3. Lab Reports Bucket

1. Click **New Bucket**
2. Configure:
   - **Name**: `lab-reports`
   - **Public bucket**: ❌ **Disabled** (private - only patient and doctor can view)
   - **File size limit**: `20 MB`
   - **Allowed MIME types**: `application/pdf, image/jpeg, image/jpg, image/png`
3. Click **Create bucket**

---

## Step 2: Apply Storage Policies via SQL

After creating the buckets manually, run the SQL migration to set up Row Level Security policies.

The migration will be created automatically.

---

## File Storage Structure

### Profile Photos
```
profile-photos/
├── {user_id}/
│   └── avatar.jpg
```

**Example:**
- `profile-photos/123e4567-e89b-12d3-a456-426614174000/avatar.jpg`

### Doctor Certificates
```
doctor-certificates/
├── {doctor_id}/
│   ├── medical_license.pdf
│   ├── diploma.jpg
│   └── certificate_1.pdf
```

**Example:**
- `doctor-certificates/789e4567-e89b-12d3-a456-426614174000/medical_license.pdf`

### Lab Reports
```
lab-reports/
├── {request_id}/
│   ├── test_results.pdf
│   └── lab_report.pdf
```

**Example:**
- `lab-reports/req_123e4567-e89b-12d3-a456-426614174000/results.pdf`

---

## Security Policies Summary

### Profile Photos (Public Bucket)
- ✅ **SELECT**: Everyone can view
- ✅ **INSERT**: Users can upload their own photos (folder = user_id)
- ✅ **UPDATE**: Users can update their own photos
- ✅ **DELETE**: Users can delete their own photos

### Doctor Certificates (Private Bucket)
- ✅ **SELECT**: Admins can view all, doctors can view own
- ✅ **INSERT**: Doctors can upload own certificates (folder = doctor_id)
- ✅ **UPDATE**: Doctors can update own certificates
- ✅ **DELETE**: Doctors can delete own certificates

### Lab Reports (Private Bucket)
- ✅ **SELECT**:
  - Patients can view their own reports
  - Doctors can view reports for their requests
  - Admins can view all reports
- ✅ **INSERT**:
  - Doctors can upload reports for their requests
  - Admins can upload any reports
- ✅ **DELETE**:
  - Doctors can delete reports for their requests
  - Admins can delete any reports

---

## Usage in Flutter App

### Upload Profile Photo

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String> uploadProfilePhoto(File imageFile, String userId) async {
  final fileName = 'avatar.jpg';
  final path = '$userId/$fileName';

  await Supabase.instance.client.storage
      .from('profile-photos')
      .upload(
        path,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true, // Replace if exists
          contentType: 'image/jpeg',
        ),
      );

  // Get public URL
  final url = Supabase.instance.client.storage
      .from('profile-photos')
      .getPublicUrl(path);

  return url;
}
```

### Upload Doctor Certificate

```dart
Future<String> uploadCertificate(File file, String doctorId, String fileName) async {
  final path = '$doctorId/$fileName';

  await Supabase.instance.client.storage
      .from('doctor-certificates')
      .upload(
        path,
        file,
        fileOptions: FileOptions(
          contentType: file.path.endsWith('.pdf')
              ? 'application/pdf'
              : 'image/jpeg',
        ),
      );

  // For private buckets, create a signed URL (expires in 1 hour)
  final url = await Supabase.instance.client.storage
      .from('doctor-certificates')
      .createSignedUrl(path, 3600);

  return url;
}
```

### Upload Lab Report

```dart
Future<String> uploadLabReport(File file, String requestId, String fileName) async {
  final path = '$requestId/$fileName';

  await Supabase.instance.client.storage
      .from('lab-reports')
      .upload(
        path,
        file,
        fileOptions: const FileOptions(
          contentType: 'application/pdf',
        ),
      );

  // Create signed URL for private bucket
  final url = await Supabase.instance.client.storage
      .from('lab-reports')
      .createSignedUrl(path, 3600); // 1 hour expiry

  return url;
}
```

### List User's Files

```dart
Future<List<FileObject>> listProfilePhotos(String userId) async {
  final files = await Supabase.instance.client.storage
      .from('profile-photos')
      .list(path: userId);

  return files;
}

Future<List<FileObject>> listDoctorCertificates(String doctorId) async {
  final files = await Supabase.instance.client.storage
      .from('doctor-certificates')
      .list(path: doctorId);

  return files;
}
```

### Delete File

```dart
Future<void> deleteFile(String bucket, String path) async {
  await Supabase.instance.client.storage
      .from(bucket)
      .remove([path]);
}
```

---

## Next Steps

1. ✅ Create the 3 buckets manually via Supabase Dashboard
2. ⏳ Run the SQL migration to apply RLS policies (will be created next)
3. ⏳ Implement file upload in Flutter app
4. ⏳ Add profile photo upload UI
5. ⏳ Add doctor certificate upload UI
6. ⏳ Add lab report upload/view UI

---

## Testing

### Test Profile Photo Upload
1. Login as any user
2. Go to profile settings
3. Upload a photo (should succeed)
4. Try to upload as another user to someone else's folder (should fail)

### Test Doctor Certificates
1. Login as doctor
2. Upload certificate (should succeed)
3. View certificate (should succeed)
4. Login as admin
5. View doctor's certificate (should succeed)
6. Login as patient
7. Try to view doctor's certificate (should fail)

### Test Lab Reports
1. Doctor completes a request
2. Upload lab report for that request (should succeed)
3. Patient views their report (should succeed)
4. Patient tries to view another patient's report (should fail)

---

## Troubleshooting

### Error: "new row violates row-level security policy"
- Check that the folder structure matches: `{user_id}/filename.ext`
- Verify user has correct role in profiles table
- Check that policies are applied correctly

### Error: "Bucket not found"
- Verify bucket was created in Supabase Dashboard
- Check bucket name matches exactly (case-sensitive)

### Error: "File size exceeds limit"
- Profile photos: Max 5MB
- Doctor certificates: Max 10MB
- Lab reports: Max 20MB

---

**Status**: Storage buckets need to be created manually first, then RLS policies will be applied via migration.
