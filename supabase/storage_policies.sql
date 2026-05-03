-- Storage RLS Policies for OnCall Lab
-- RUN THIS AFTER creating the buckets manually via Supabase Dashboard

-- ============= PROFILE PHOTOS POLICIES =============

-- Anyone can view profile photos (public bucket)
CREATE POLICY "Public profile photos are viewable by everyone"
ON storage.objects FOR SELECT
USING (bucket_id = 'profile-photos');

-- Users can upload their own profile photo
CREATE POLICY "Users can upload their own profile photo"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'profile-photos'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can update their own profile photo
CREATE POLICY "Users can update their own profile photo"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'profile-photos'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Users can delete their own profile photo
CREATE POLICY "Users can delete their own profile photo"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'profile-photos'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- ============= DOCTOR CERTIFICATES POLICIES =============

-- Admins can view all doctor certificates
CREATE POLICY "Admins can view all doctor certificates"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'doctor-certificates'
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
);

-- Doctors can view their own certificates
CREATE POLICY "Doctors can view their own certificates"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'doctor-certificates'
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- Doctors can upload their certificates
CREATE POLICY "Doctors can upload their own certificates"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'doctor-certificates'
  AND (storage.foldername(name))[1] = auth.uid()::text
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'doctor'
  )
);

-- Doctors can update their certificates
CREATE POLICY "Doctors can update their own certificates"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'doctor-certificates'
  AND (storage.foldername(name))[1] = auth.uid()::text
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'doctor'
  )
);

-- Doctors can delete their certificates
CREATE POLICY "Doctors can delete their own certificates"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'doctor-certificates'
  AND (storage.foldername(name))[1] = auth.uid()::text
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'doctor'
  )
);

-- ============= LAB REPORTS POLICIES =============

-- Patients can view their own lab reports
CREATE POLICY "Patients can view their own lab reports"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM test_requests tr
    WHERE tr.patient_id = auth.uid()
    AND (storage.foldername(name))[1] = tr.id::text
  )
);

-- Doctors can view lab reports for their requests
CREATE POLICY "Doctors can view lab reports for their requests"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM test_requests tr
    WHERE tr.doctor_id = auth.uid()
    AND (storage.foldername(name))[1] = tr.id::text
  )
);

-- Admins can view all lab reports
CREATE POLICY "Admins can view all lab reports"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
);

-- Doctors can upload lab reports for their requests
CREATE POLICY "Doctors can upload lab reports"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM test_requests tr
    WHERE tr.doctor_id = auth.uid()
    AND (storage.foldername(name))[1] = tr.id::text
    AND tr.status IN ('sample_collected', 'delivered_to_lab', 'completed')
  )
);

-- Admins can upload lab reports
CREATE POLICY "Admins can upload lab reports"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
);

-- Doctors can delete lab reports for their requests
CREATE POLICY "Doctors can delete lab reports"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM test_requests tr
    WHERE tr.doctor_id = auth.uid()
    AND (storage.foldername(name))[1] = tr.id::text
  )
);

-- Admins can delete any lab reports
CREATE POLICY "Admins can delete any lab reports"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'lab-reports'
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role = 'admin'
  )
);
