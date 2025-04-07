import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  // final String cloudName = dotenv.env['CLOUDNAME']!;
  // final String apiKey = dotenv.env['APIKEY']!;
  // final String apiSecret = dotenv.env['APISECRET']!;
  final String cloudName = "dfmsqyhem";
  final String apiKey = "739492419627789";
  final String apiSecret = "iM5t7SaR6zhSM9xST3cHFmyK6ks";
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

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final result = jsonDecode(responseData);

        if (mounted) {
          setState(() {
            imageUrl = result['secure_url'];
            print(imageUrl);
          });
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF914D),
        elevation: 2,
        title: Text(
          widget.mode == "Add" ? 'Create a Post' : 'Edit a Post',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              labelText("Title"),
              const SizedBox(height: 8),
              TextFormField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: 'Title',
                  filled: true,
                  fillColor: Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              labelText("Description (Optional)"),
              const SizedBox(height: 8),
              TextFormField(
                controller: descriptionCtrl,
                maxLines: null,
                minLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Description',
                  filled: true,
                  fillColor: Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),
              labelText("Upload Image (Optional)"),
              const SizedBox(height: 8),
              if (widget.mode == "Add")
                image == null
                    ? ElevatedButton(
                        onPressed: pickImage,
                        child: Text('Select Image'),
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
                              child: Text("Delete image"))
                        ],
                      ),
              if (widget.mode == "Edit")
                imageUrl == "" && image == null
                    ? ElevatedButton(
                        onPressed: pickImage,
                        child: Text('Select Image'),
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
                              child: Text("Delete image"))
                        ],
                      ),
              const SizedBox(height: 16),
              labelText("Select Category"),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFFF4F4F4),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedValueDropdown,
                  hint: Text(
                    'Select Category',
                  ),
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    border: InputBorder.none,
                  ),
                  items: <String>['General', 'ReviewCourse', 'Lost&Found']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValueDropdown = newValue ?? "General";
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select category';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Disclaimer: Posts containing inappropriate, offensive, or harmful content will be removed without prior notice. Please adhere to the community guidelines.",
                style: TextStyle(fontSize: 12, color: Color(0xFFE63946)),
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
                      await ref.read(communityProvider.notifier).createPost(
                          title: titleCtrl.text,
                          description: descriptionCtrl.text,
                          category: selectedValueDropdown!,
                          imageUrl: imageUrl);
                    } else if (widget.mode == "Edit") {
                      if (isChangeInEditMode) {
                        await uploadImage();
                      }
                      await ref.read(communityProvider.notifier).editPost(
                          oriPost: editPost,
                          title: titleCtrl.text,
                          description: descriptionCtrl.text,
                          category: selectedValueDropdown!,
                          imageUrl: imageUrl);
                    }

                    setState(() {
                      isLoading = false;
                    });
                    titleCtrl.clear();
                    descriptionCtrl.clear();
                    if (context.mounted) {
                      widget.mode == "Add"
                          ? Navigator.pop(context)
                          : Navigator.pushNamed(context, '/community');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  backgroundColor: Color(0xFFFF914D),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.mode == "Add" ? "Post" : "Edit",
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
