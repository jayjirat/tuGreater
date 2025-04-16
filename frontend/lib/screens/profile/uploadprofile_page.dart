import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/profileimage_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:frontend/services/profile_service.dart';

class UploadProfilePage extends ConsumerStatefulWidget {
  const UploadProfilePage({super.key});

  @override
  ConsumerState<UploadProfilePage> createState() => _UploadProfilePageState();
}

class _UploadProfilePageState extends ConsumerState<UploadProfilePage> {
  final cloudinary =
      CloudinaryPublic("dosejlasn", 'profileUpload', cache: false);
  late String profileImageUrl;
  late final String studentId;
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    profileImageUrl = ref.read(userProvider)?.profileImageUrl ??
        "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
    studentId = ref.read(userProvider)?.studentId ?? "NOT FOUND";
  }

  Future<void> uploadImage(File? imageFile) async {
    if (imageFile == null) return;

    setState(() {
      isUploading = true;
    });

    try {
      // Upload to cloudinary
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          imageFile.path,
          resourceType: CloudinaryResourceType.Image,
          folder: 'profile_images',
        ),
      );

      // Update the profile image URL with the new Cloudinary URL
      setState(() {
        profileImageUrl = response.secureUrl;
        isUploading = false;
      });

      await updateProfileImage(studentId, response.secureUrl);
      final user = ref.read(userProvider);
      user!.profileImageUrl = response.secureUrl;
      ref.read(userProvider.notifier).loadUser(studentId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile image uploaded successfully')),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      print('Error uploading image: $e');
    }
  }

  Future<void> resetProfileImage() async {
    setState(() {
      isUploading = true;
    });

    try {
      // Reset to default image
      setState(() {
        profileImageUrl =
            "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
        isUploading = false;
      });
      await updateProfileImage(studentId,
          "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg");
      final user = ref.read(userProvider);
      user!.profileImageUrl =
          "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg";
      ref.read(userProvider.notifier).loadUser(studentId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile image reset to default')),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer(
        builder: (context, ref, child) {
          final user = ref.watch(userProvider);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(10),
                    width: 350,
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isUploading
                            ? CircularProgressIndicator()
                            : ProfileImagePicker(
                                existingImageUrl: profileImageUrl,
                                onImageSelected: (File image) {
                                  uploadImage(image);
                                },
                              ),
                        Text(
                          user!.displayName,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          user.studentId,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: isUploading ? null : resetProfileImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Button color
                    minimumSize: Size(350, 75),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: Text("Return to default picture",
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
