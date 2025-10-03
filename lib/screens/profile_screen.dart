// profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eclipse/services/storage_service.dart';
import 'package:eclipse/providers/auth_provider.dart';
import '../widgets/bottom_navigation_bar.dart'; // TODO: connect if you use a custom bottom nav

/// Holds the current profile image URL for the session.
final profileImageProvider = StateProvider<String?>((ref) => null);

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  File? _selectedImage;

  /// Choose camera or gallery.
  Future<void> _showImageSourceDialog() async {
    if (!mounted) return;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Pick, validate, and preview an image.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image == null) return;

      final file = File(image.path);

      // Validate via your storage service helper
      final storageService = ref.read(storageServiceProvider);
      final error = storageService.validateImage(file);
      if (error != null) {
        _showToast(error, isError: true);
        return;
      }

      setState(() => _selectedImage = file);
      await _showPreviewDialog(file);
    } catch (e) {
      _showToast('Failed to pick image: $e', isError: true);
    }
  }

  /// Preview dialog before upload.
  Future<void> _showPreviewDialog(File imageFile) async {
    if (!mounted) return;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preview Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                imageFile,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Upload this image as your profile picture?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _uploadImage(imageFile);
            },
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  /// Upload image using your storage service.
  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isUploading = true);
    try {
      final storageService = ref.read(storageServiceProvider);
      final imageUrl = await storageService.uploadProfileImage(imageFile);

      // Store in provider so the UI updates.
      ref.read(profileImageProvider.notifier).state = imageUrl;

      _showToast('Profile image updated successfully!');
    } catch (e) {
      _showToast('Upload failed: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authProvider).user;
    final profileImageUrl = ref.watch(profileImageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      // TODO: if you have a custom bottom nav widget, add it here:
      // bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Avatar + camera button + upload overlay
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl)
                        : null,
                    child: profileImageUrl == null
                        ? Icon(
                      Icons.person,
                      size: 60,
                      color: theme.colorScheme.primary,
                    )
                        : null,
                  ),
                  if (_isUploading)
                    Positioned.fill(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black54,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.colorScheme.secondary,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.camera_alt, size: 18),
                        onPressed: _isUploading ? null : _showImageSourceDialog,
                        tooltip: 'Change profile picture',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Account Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: GoogleFonts.raleway(
                        textStyle: theme.textTheme.titleLarge,
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      'Email',
                      user?.email ?? 'Not logged in',
                      Icons.email,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'User ID',
                      user?.uid ?? 'N/A',
                      Icons.fingerprint,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Theme toggle (keeps your original API)
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.color_lens),
                title: Text(
                  'Dark Mode',
                  style: GoogleFonts.raleway(),
                ),
                value: widget.isDarkMode,
                onChanged: (_) => widget.onToggleTheme(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
