import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/community_provider.dart';

class CommunityManagePost extends ConsumerStatefulWidget {
  final String mode;
  final String? id;
  const CommunityManagePost({super.key, required this.mode, this.id});

  @override
  CommunityManagePostState createState() => CommunityManagePostState();
}

class CommunityManagePostState extends ConsumerState<CommunityManagePost> {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String? selectedValueDropdown;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF914D),
        elevation: 2,
        title: Text(
          widget.mode == "Add" ? 'Create a Post' : 'Edit Post',
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
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Image URL',
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
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // ถ้าผ่านการตรวจสอบแล้ว
                    ref.read(communityProvider.notifier).createPost(
                        title: titleCtrl.text,
                        description: descriptionCtrl.text,
                        category: selectedValueDropdown);

                    titleCtrl.clear();
                    descriptionCtrl.clear();
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  elevation: 2,
                  backgroundColor: Color(0xFFFF914D),
                ),
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
