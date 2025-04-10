import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? existingImageUrl;

  const ProfileImagePicker({
    Key? key,
    this.existingImageUrl,
  }) : super(key: key);

  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Track if we're using a local file or remote URL
  bool get _isUsingLocalImage => _selectedImage != null;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the theme colors
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Profile image preview
        GestureDetector(
          onTap: () => _showImageSourceActionSheet(context),
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              // Use background color from theme with slight opacity
              color: isDarkMode
                  ? colorScheme.surface.withOpacity(0.8)
                  : colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            child: _buildProfileImage(),
          ),
        ),
        const SizedBox(height: 16),
        // Text prompt
        Text(
          _isUsingLocalImage || widget.existingImageUrl != null
              ? "Tap to change profile picture"
              : "Tap to select a profile picture",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        // Upload button (only show if image is selected or URL exists)
        if (_isUsingLocalImage || widget.existingImageUrl != null)
          ElevatedButton(
            onPressed: () {
              // TODO: Implement your upload logic here
              if (_isUsingLocalImage) {
                print("Upload new image: ${_selectedImage!.path}");
              } else {
                print("Keep using existing image: ${widget.existingImageUrl}");
              }
            },
            child: const Text("Save Profile Picture"),
          ),
      ],
    );
  }

  // Helper method to build the appropriate profile image widget
  Widget _buildProfileImage() {
    final theme = Theme.of(context);
    final iconColor = theme.brightness == Brightness.dark
        ? Colors.white
        : theme.colorScheme.onSurface;

    // If user selected a new image, show that
    if (_isUsingLocalImage) {
      return ClipOval(
        child: Image.file(
          _selectedImage!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
        ),
      );
    }

    // If there's an existing URL, show that
    if (widget.existingImageUrl != null &&
        widget.existingImageUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: widget.existingImageUrl!,
          width: 150,
          height: 150,
          fit: BoxFit.cover,
          placeholder: (context, url) => CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            size: 50,
            color: theme.colorScheme.error,
          ),
        ),
      );
    }

    // Default placeholder
    return Icon(
      Icons.person,
      size: 80,
      color: iconColor,
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: theme.colorScheme.primary),
              title: Text("Take a photo", style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.photo_library, color: theme.colorScheme.primary),
              title:
                  Text("Choose from gallery", style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_isUsingLocalImage || widget.existingImageUrl != null)
              ListTile(
                leading: Icon(Icons.delete, color: theme.colorScheme.error),
                title: Text(
                  "Remove photo",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedImage = null;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
