import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityManagePost extends ConsumerStatefulWidget {
  final String mode;
  final CommuPost? post;
  const CommunityManagePost({super.key, required this.mode, this.post});

  @override
  CommunityManagePostState createState() => CommunityManagePostState();
}

class CommunityManagePostState extends ConsumerState<CommunityManagePost> {
  late final dynamic editPost;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleCtrl;
  late final TextEditingController descriptionCtrl;
  String? selectedValueDropdown;
  bool isLoading = false;
  File? image;
  final ImagePicker picker = ImagePicker();
  final String cloudName = dotenv.env['JAY_CLOUDINARY_CLOUD_NAME'] ?? '';
  final String apiKey = dotenv.env['JAY_CLOUDINARY_API_KEY'] ?? '';
  String imageUrl = "";

  bool isChangeInEditMode = false;
  @override
  void initState() {
    super.initState();
    editPost = widget.post;
    titleCtrl = TextEditingController(text: editPost?.title);
    descriptionCtrl = TextEditingController(text: editPost?.description);
    if (widget.mode == "Edit") {
      selectedValueDropdown = editPost?.category;
      if (editPost.imageUrl != "") {
        setState(() {
          imageUrl = editPost.imageUrl;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }

    if (widget.mode == "Edit") {
      setState(() {
        isChangeInEditMode = true;
      });
    }
  }

  Future<void> uploadImage() async {
    if (image == null) return;
    try {
      final uri =
          Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest('POST', uri);

      var file = await http.MultipartFile.fromPath('file', image!.path);
      request.files.add(file);

      var params = {
        'upload_preset': 'tu_greater_postIMG',
        'api_key': apiKey,
      };
      request.fields.addAll(params);

      var response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);

        if (mounted) {
          setState(() {
            imageUrl = result['secure_url'];
          });
        }
      } else {
        if (mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.uploadPostImageFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                  errorMessage:
                      "${AppLocalizations.of(context)!.unableUploadPostImage} ${AppLocalizations.of(context)!.pleaseTryAgain}"),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> categoryOptions = {
      'General': AppLocalizations.of(context)!.general,
      'ReviewCourse': AppLocalizations.of(context)!.courseReview,
      'Lost&Found': AppLocalizations.of(context)!.lostNfound,
    };
    final user = ref.read(userProvider);
    final communityPostController = ref.read(communityProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == "Add"
              ? AppLocalizations.of(context)!.createPost
              : AppLocalizations.of(context)!.editPost,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              labelText(AppLocalizations.of(context)!.title),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.title,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .commuTitleValidateMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              labelText(
                  "${AppLocalizations.of(context)!.description} (${AppLocalizations.of(context)!.optional})"),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionCtrl,
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.description,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              labelText(
                  "${AppLocalizations.of(context)!.uploadImage} (${AppLocalizations.of(context)!.optional})"),
              const SizedBox(height: 8),
              if (widget.mode == "Add")
                image == null
                    ? ElevatedButton(
                        onPressed: pickImage,
                        child: Text(AppLocalizations.of(context)!.uploadImage),
                      )
                    : Column(
                        children: [
                          Image.file(
                            image!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    image = null;
                                  }),
                              child: Text(
                                  AppLocalizations.of(context)!.deleteImage))
                        ],
                      ),
              if (widget.mode == "Edit")
                imageUrl == "" && image == null
                    ? ElevatedButton(
                        onPressed: pickImage,
                        child: Text(AppLocalizations.of(context)!.uploadImage),
                      )
                    : Column(
                        children: [
                          isChangeInEditMode
                              ? Image.file(
                                  image!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  editPost.imageUrl,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () => setState(() {
                                    imageUrl = "";
                                    image = null;
                                  }),
                              child: Text(
                                  AppLocalizations.of(context)!.deleteImage))
                        ],
                      ),
              const SizedBox(height: 16),
              labelText(AppLocalizations.of(context)!.selectCategory),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                borderRadius: BorderRadius.circular(25),
                dropdownColor: Theme.of(context).cardColor,
                value: selectedValueDropdown,
                hint: Text(
                  AppLocalizations.of(context)!.category,
                ),
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: InputBorder.none,
                ),
                items: categoryOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValueDropdown =
                        newValue ?? AppLocalizations.of(context)!.general;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .commuCategoryValidateMessage;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.commuDisclaimer,
                style: TextStyle(
                    fontSize: 12, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (_formKey.currentState?.validate() ?? false) {
                    // ถ้าผ่านการตรวจสอบแล้ว
                    if (widget.mode == "Add") {
                      if (image != null) {
                        await uploadImage();
                      }
                      try {
                        if (context.mounted) {
                          await communityPostController.createPost(
                              userId: user!.id,
                              username: user.displayName,
                              title: titleCtrl.text,
                              description: descriptionCtrl.text,
                              category: selectedValueDropdown!,
                              imageUrl: imageUrl,
                              postedByImageUrl: user.profileImageUrl,
                              context: context,
                              isReposted: false);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ErrorPage(errorMessage: e.toString()),
                              ));
                        }
                      }
                    } else if (widget.mode == "Edit") {
                      if (isChangeInEditMode) {
                        await uploadImage();
                      }
                      try {
                        if (context.mounted) {
                          await communityPostController.editPost(
                              oriPost: editPost,
                              title: titleCtrl.text,
                              description: descriptionCtrl.text,
                              category: selectedValueDropdown!,
                              imageUrl: imageUrl,
                              context: context);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ErrorPage(errorMessage: e.toString()),
                              ));
                        }
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                    titleCtrl.clear();
                    descriptionCtrl.clear();
                    if (context.mounted) {
                      String notifyMsg =
                          AppLocalizations.of(context)!.postCreatedSuccess;
                      widget.mode == "Add"
                          ? Navigator.pop(context)
                          : {
                              Navigator.pushNamed(context, '/community'),
                              notifyMsg = AppLocalizations.of(context)!
                                  .postEditedSuccess
                            };

                      showToast(
                        message: notifyMsg,
                        toastType: ToastType.success,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.mode == "Add"
                          ? AppLocalizations.of(context)!.createPost
                          : AppLocalizations.of(context)!.editPost,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    if (isLoading)
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget labelText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
