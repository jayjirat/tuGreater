import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:frontend/screens/profile/profileimage_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/exception/timeout_exception.dart';

class UploadProfilePage extends ConsumerStatefulWidget {
  const UploadProfilePage({super.key});

  @override
  ConsumerState<UploadProfilePage> createState() => _UploadProfilePageState();
}

class _UploadProfilePageState extends ConsumerState<UploadProfilePage> {
  final cloudinary =
      CloudinaryPublic("dosejlasn", 'profileUpload', cache: false);
  late String profileImageUrl;
  late dynamic user;
  bool isUploading = false;
  @override
  void initState() {
    super.initState();
    profileImageUrl = ref.read(userProvider)?.profileImageUrl ?? "";
    user = ref.read(userProvider);
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
      try {
        await updateProfileImage(user.id, response.secureUrl);
        user!.profileImageUrl = response.secureUrl;
        ref.read(userProvider.notifier).loadUser(user.id);
        showToast(
          message: 'Profile image uploaded successfully',
          toastType: ToastType.success,
        );
      } on TimeoutException catch (e) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(errorMessage: e.toString()),
            ));
      } catch (e) {
        showToast(
          message: 'Error occurs during upload, please try again',
          toastType: ToastType.error,
        );
      }
    } catch (e) {
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> resetProfileImage() async {
    setState(() {
      isUploading = true;
    });

    try {
      // Reset to default image
      setState(() {
        profileImageUrl = "";
        isUploading = false;
      });
      await updateProfileImage(user.id, "");
      user.profileImageUrl = "";
      ref.read(userProvider.notifier).loadUser(user.id);

      showToast(
        message: 'Profile image reset to default',
        toastType: ToastType.info,
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Profile image reset to default')),
      // );
    } catch (e) {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
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
                      color: Theme.of(context).hoverColor,
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
                      backgroundColor: Colors.redAccent, // Button color
                      minimumSize: Size(350, 75),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      elevation: 5),
                  child: Text(AppLocalizations.of(context)!.return_to_default,
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
