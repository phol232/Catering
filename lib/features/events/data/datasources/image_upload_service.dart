import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Service for uploading and managing event images in Supabase Storage
class ImageUploadService {
  final SupabaseClient supabaseClient;
  static const String bucketName = 'event-images';
  static const int maxFileSizeBytes = 2 * 1024 * 1024; // 2MB

  ImageUploadService(this.supabaseClient);

  /// Upload an event image to Supabase Storage
  /// Compresses the image if it exceeds 2MB
  /// Returns the public URL of the uploaded image
  Future<String> uploadEventImage(File imageFile) async {
    try {
      // Compress image if needed
      final compressedFile = await _compressImageIfNeeded(imageFile);

      // Generate unique filename with timestamp and UUID
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final uuid = const Uuid().v4();
      final fileName = '${timestamp}_$uuid.jpg';

      // Upload to Supabase Storage
      await supabaseClient.storage
          .from(bucketName)
          .upload(fileName, compressedFile);

      // Get public URL
      final imageUrl = supabaseClient.storage
          .from(bucketName)
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  /// Delete an event image from Supabase Storage
  Future<void> deleteEventImage(String imageUrl) async {
    try {
      // Extract filename from URL
      final uri = Uri.parse(imageUrl);
      final fileName = uri.pathSegments.last;

      // Delete from storage
      await supabaseClient.storage.from(bucketName).remove([fileName]);
    } catch (e) {
      throw Exception('Error al eliminar imagen: $e');
    }
  }

  /// Compress image if it exceeds the maximum file size
  Future<File> _compressImageIfNeeded(File file) async {
    try {
      // Check file size
      final fileSize = await file.length();

      // If file is smaller than max size, return original
      if (fileSize <= maxFileSizeBytes) {
        return file;
      }

      // Compress the image
      final filePath = file.absolute.path;
      final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
      final splitted = filePath.substring(0, lastIndex);
      final outPath = "${splitted}_compressed.jpg";

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
      );

      if (result == null) {
        throw Exception('Error al comprimir imagen');
      }

      return File(result.path);
    } catch (e) {
      throw Exception('Error al procesar imagen: $e');
    }
  }
}
