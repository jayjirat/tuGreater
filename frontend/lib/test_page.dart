import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? existingImageUrl; // Add this parameter

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
    return Column(
      children: [
        // Profile image preview
        GestureDetector(
          onTap: () => _showImageSourceActionSheet(context),
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
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
          style: TextStyle(color: Colors.grey[700]),
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
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(
            Icons.error,
            size: 50,
            color: Colors.red,
          ),
        ),
      );
    }

    // Default placeholder
    return Icon(
      Icons.person,
      size: 80,
      color: Colors.grey[800],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take a photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_isUsingLocalImage || widget.existingImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Remove photo",
                    style: TextStyle(color: Colors.red)),
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
