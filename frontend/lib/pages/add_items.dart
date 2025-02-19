import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:frontend/pages/shop.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  // final _formKey = GlobalKey<FormState>();
  bool isCheckedFirstHanded = false;
  bool isCheckedSecondHanded = false;
  bool isCheckedOthers = false;
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> tags = [];
  TextEditingController otherTagController = TextEditingController();
  FocusNode otherTagFocusNode = FocusNode();

  // Image related variables
  List<File> _selectedImages = [];

  Future<void> createProduct() async {
    // Upload images first
    List<String> imageUrls = await _uploadImagesToCloudinary();

    var url = "http://10.0.2.2:8080/shop/add";

    var response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode({
          'productImageUrls': imageUrls, // Use uploaded image URLs
          'productName': nameController.text,
          'productPrice': double.parse(priceController.text),
          'productCategory': selectedCategory,
          'productTags': tags,
          'productDatePost': DateTime.now().toIso8601String(),
          'productDescription': descriptionController.text,
        }));

    if (response.statusCode == 200) {
      print('Product created successfully');
    } else {
      print('Failed to create product. Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    otherTagController.dispose();
    otherTagFocusNode.dispose();
    super.dispose();
  }

  void addTag() {
    if (isCheckedOthers && otherTagController.text.isNotEmpty) {
      String newTag = otherTagController.text.trim();
      if (!tags.contains(newTag)) {
        setState(() {
          tags.add(newTag); // Add the final text to tags
        });
        otherTagController.clear(); // Clear the text field after adding
      }
    }
  }

  //image function
  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _pickImagesFromGallery() async {
    final returnedImages =
        await ImagePicker().pickMultiImage(); // pickMultipleImages for gallery
    if (returnedImages.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(returnedImages.map((e) => File(e.path)));
      });
    }
  }

  Future _pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage != null) {
      setState(() {
        _selectedImages
            .add(File(returnedImage.path)); // Add selected image to list
      });
    }
  }

  Future<List<String>> _uploadImagesToCloudinary() async {
    List<String> uploadedUrls = [];
    String cloudName =
        dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'default_cloud_name';
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    for (var image in _selectedImages) {
      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'FlutterImage' // Change to your preset
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonMap = jsonDecode(responseData);
          uploadedUrls.add(jsonMap['secure_url']); // Store Cloudinary URL
        } else {
          print("Failed to upload image: ${response.statusCode}");
          print(await response.stream.bytesToString());
        }
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return uploadedUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Toolbar(title: "Add Product"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    _showImageSourceOptions(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(16),
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54, width: 2),
                    ),
                    child: _selectedImages.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                            ),
                            shrinkWrap: true,
                            itemCount: _selectedImages.length,
                            itemBuilder: (context, index) {
                              return Image.file(
                                _selectedImages[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/svg/upload.svg"),
                              SizedBox(height: 5),
                              Text("Upload Images",
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 148,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Price",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Enter Name...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 100,
                        child: TextField(
                          controller: priceController,
                          keyboardType:
                              TextInputType.number, // Set keyboard to number
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Allow only numbers
                          decoration: InputDecoration(
                            hintText: "Baht",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "฿",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Category",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Background color
                  ),
                  value: selectedCategory,
                  hint: Text("Select Category"),
                  items:
                      ["Food", "Drink", "Dormitory", "Clothes"].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Tag",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // First checkbox with fixed text
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedFirstHanded,
                          onChanged: (value) {
                            setState(() {
                              isCheckedFirstHanded = value!;
                              if (value!) {
                                tags.add("มือหนึ่ง");
                              } else {
                                tags.remove("มือหนึ่ง");
                              }
                            });
                          },
                        ),
                        Text("มือหนึ่ง"),
                      ],
                    ),
                    SizedBox(width: 10), // Spacing

                    // Second checkbox with fixed text
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedSecondHanded,
                          onChanged: (value) {
                            setState(() {
                              isCheckedSecondHanded = value!;
                              if (value!) {
                                tags.add("มือสอง");
                              } else {
                                tags.remove("มือสอง");
                              }
                            });
                          },
                        ),
                        Text("มือสอง"),
                      ],
                    ),
                    SizedBox(width: 10), // Spacing

                    // Third checkbox with a text field
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedSecondHanded,
                          onChanged: (value) {
                            setState(() {
                              isCheckedSecondHanded = value!;
                              if (value!) {
                                tags.add("สภาพดี");
                              } else {
                                tags.remove("สภาพดี");
                              }
                            });
                          },
                        ),
                        Text("สภาพดี"),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // First checkbox with fixed text
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedFirstHanded,
                          onChanged: (value) {
                            setState(() {
                              isCheckedFirstHanded = value!;
                              if (value!) {
                                tags.add("อร่อย");
                              } else {
                                tags.remove("อร่อย");
                              }
                            });
                          },
                        ),
                        Text("อร่อย"),
                      ],
                    ),
                    SizedBox(width: 19), // Spacing

                    // Second checkbox with fixed text
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedSecondHanded,
                          onChanged: (value) {
                            setState(() {
                              isCheckedSecondHanded = value!;
                              if (value!) {
                                tags.add("สะอาด");
                              } else {
                                tags.remove("สะอาด");
                              }
                            });
                          },
                        ),
                        Text("สะอาด"),
                      ],
                    ),
                    SizedBox(width: 11), // Spacing

                    // Third checkbox with a text field
                    Row(
                      children: [
                        Checkbox(
                          value: isCheckedOthers,
                          onChanged: (value) {
                            setState(() {
                              isCheckedOthers = value!;
                              if (!value!) {
                                otherTagController.clear();
                                tags.removeWhere(
                                    (tag) => tag == otherTagController.text);
                              }
                            });
                          },
                        ),
                        SizedBox(
                          width: 100, // Adjust width as needed
                          child: TextField(
                            controller: otherTagController,
                            focusNode: otherTagFocusNode,
                            enabled:
                                isCheckedOthers, // Enable only if checkbox is checked
                            decoration: InputDecoration(
                              hintText: "อื่นๆ",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Description",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: 150,
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: "Enter Description...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "*โปรดตรวจสอบว่าได้ใส่ช่องทางการติดต่อลงไปในรายละเอียด",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Push button to the bottom
                children: [
                  Padding(
                    padding: EdgeInsets.all(20), // Add spacing at the bottom
                    child: SizedBox(
                      child: FilledButton(
                        onPressed: () {
                          // First, check if the "Others" checkbox is checked and the text field is not empty
                          if (isCheckedOthers &&
                              otherTagController.text.isNotEmpty) {
                            addTag(); // Add the tag if valid
                          }
                          _uploadImagesToCloudinary();
                          createProduct();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Shop()),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange), // Set orange background
                        ),
                        child: Text(
                          "โพสต์เลย",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18, // Black text for contrast
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
