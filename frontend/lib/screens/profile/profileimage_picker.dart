import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImagePicker extends StatefulWidget {
  final String existingImageUrl;
  final Function(File) onImageSelected;

  const ProfileImagePicker({
    Key? key,
    required this.existingImageUrl,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        // Convert XFile to File
        File imageFile = File(pickedFile.path);

        // Call the callback function with the selected image
        widget.onImageSelected(imageFile);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Take a photo'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          },
          child: CircleAvatar(
            radius: 125,
            backgroundImage: NetworkImage(widget.existingImageUrl),
            backgroundColor: Colors.grey[300],
          ),
        ),
        SizedBox(height: 10),
        Text('Tap to change profile image'),
      ],
    );
  }
}
