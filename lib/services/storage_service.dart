import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Service for handling file uploads (profile images, etc.)
class StorageService {
  /// Uploads a profile image and returns the URL
  /// This is a stub that simulates network delay
  Future<String> uploadProfileImage(File imageFile) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // In production, this would upload to Firebase Storage, S3, etc.
    // For now, return a fake URL based on the file path
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'https://fake-storage.com/profiles/$timestamp.jpg';
  }

  /// Validates image file before upload
  /// Returns error message if invalid, null if valid
  String? validateImage(File imageFile) {
    // Check file size (5MB limit)
    final bytes = imageFile.lengthSync();
    final mb = bytes / (1024 * 1024);

    if (mb > 5) {
      return 'Image size must be under 5MB (current: ${mb.toStringAsFixed(1)}MB)';
    }

    // Check file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];

    if (!validExtensions.contains(extension)) {
      return 'Invalid image format. Use: ${validExtensions.join(", ")}';
    }

    return null; // Valid
  }
}