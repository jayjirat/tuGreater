import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              builder: (context) {
                return SafeArea(
                  child: Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text(
                            AppLocalizations.of(context)!.product_camera_popup),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text(
                            AppLocalizations.of(context)!.product_images_popup),
                        onTap: () {
                          Navigator.of(context).pop();
                          _pickImage(ImageSource.gallery);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: widget.existingImageUrl.isEmpty
              ? CircleAvatar(
                  radius: 125,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 120, color: Colors.grey[600]),
                )
              : CircleAvatar(
                  radius: 125,
                  backgroundImage: NetworkImage(widget.existingImageUrl),
                ),
        ),
        SizedBox(height: 15),
        Text(
          widget.existingImageUrl.isEmpty
              ? AppLocalizations.of(context)!.tap_to_add
              : AppLocalizations.of(context)!.tap_to_change,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
