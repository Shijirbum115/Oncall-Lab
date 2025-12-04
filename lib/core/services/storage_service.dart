import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oncall_lab/core/services/supabase_service.dart';

class StorageService {
  static final ImagePicker _picker = ImagePicker();

  /// Pick an image from gallery or camera
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile == null) return null;
    return File(pickedFile.path);
  }

  /// Upload profile photo to `profile-photos/{userId}/avatar.jpg`
  static Future<String?> uploadProfilePhoto({
    required String userId,
    required File file,
  }) async {
    final path = '$userId/avatar.jpg';

    await SupabaseService.client.storage.from('profile-photos').upload(
          path,
          file,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    // `profile-photos` is configured as a public bucket in Supabase
    return SupabaseService.client.storage
        .from('profile-photos')
        .getPublicUrl(path);
  }

  /// Upload doctor certificate to `doctor-certificates/{doctorId}/{fileName}`
  static Future<String?> uploadDoctorCertificate({
    required String doctorId,
    required File file,
    required String fileName,
  }) async {
    final path = '$doctorId/$fileName';

    await SupabaseService.client.storage.from('doctor-certificates').upload(
          path,
          file,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    final signedUrl = await SupabaseService.client.storage
        .from('doctor-certificates')
        .createSignedUrl(path, 3600);
    return signedUrl;
  }

  /// Upload lab report to `lab-reports/{requestId}/{fileName}`
  static Future<String?> uploadLabReport({
    required String requestId,
    required File file,
    required String fileName,
  }) async {
    final path = '$requestId/$fileName';

    await SupabaseService.client.storage.from('lab-reports').upload(
          path,
          file,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );

    final signedUrl = await SupabaseService.client.storage
        .from('lab-reports')
        .createSignedUrl(path, 3600);
    return signedUrl;
  }
}
