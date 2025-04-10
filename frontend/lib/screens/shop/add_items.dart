import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:frontend/provider/product_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddItems extends ConsumerStatefulWidget {
  final String productOwnerId = "888"; //mockup
  const AddItems({super.key});

  @override
  ConsumerState<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends ConsumerState<AddItems> {
  // final _formKey = GlobalKey<FormState>();
  bool isCheckedFirstHanded = false;
  bool isCheckedSecondHanded = false;
  bool isCheckedThirdHanded = false;
  bool isCheckedFourthHanded = false;
  bool isCheckedFifthHanded = false;
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

  Future<void> createProduct(List<String> imageUrls) async {
    var url = "http://10.0.2.2:8080/shop";

    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'productImageUrls': imageUrls,
        'productName': nameController.text,
        'productPrice': double.parse(priceController.text),
        'productCategory': selectedCategory,
        'productTags': tags,
        'productDatePost': DateTime.now().toIso8601String(),
        'productDateUpdate': DateTime.now().toIso8601String(),
        'productDescription': descriptionController.text,
        'productOwner': "Wernatraa", //mockup
        'productOwnerId': "888" //mockup
      }),
    );

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
        _selectedImages.add(File(returnedImage.path));
      });
    }
  }

  Future<List<String>> _uploadImagesToCloudinary() async {
    String cloudName =
        dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? 'default_cloud_name';
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    List<Future<String>> uploadFutures =
        _selectedImages.map<Future<String>>((image) async {
      var request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'FlutterImage'
        ..files.add(await http.MultipartFile.fromPath('file', image.path));

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonMap = jsonDecode(responseData);
          return jsonMap['secure_url'];
        } else {
          print("Failed to upload image: ${response.statusCode}");
          print(await response.stream.bytesToString());
          return '';
        }
      } catch (e) {
        print("Error uploading image: $e");
        return '';
      }
    }).toList();

    List<String> uploadedUrls = await Future.wait(uploadFutures);
    return uploadedUrls.where((url) => url.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productOwnerId = widget.productOwnerId;
    return Scaffold(
        appBar: Toolbar(title: "Add Product"),
        body: Consumer(builder: (context, ref, child) {
          return SingleChildScrollView(
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
                      child: Stack(
                        children: [
                          _selectedImages.isNotEmpty
                              ? GridView.builder(
                                  padding: EdgeInsets.all(8),
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
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset("assets/svg/upload.svg"),
                                      SizedBox(height: 5),
                                      Text("Upload Images",
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                          if (_selectedImages.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.clear();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: EdgeInsets.all(4),
                                  child: Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Category",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    items: ["Food", "Drink", "Dormitory", "Clothes", "Others"]
                        .map((category) {
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            value: isCheckedThirdHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedThirdHanded = value!;
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
                            value: isCheckedFourthHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedFourthHanded = value!;
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
                            value: isCheckedFifthHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedFifthHanded = value!;
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        child: FilledButton(
                          onPressed: () async {
                            if (isCheckedOthers &&
                                otherTagController.text.isNotEmpty) {
                              addTag();
                            }

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(height: 15),
                                        Text(
                                          "กำลังสร้างสินค้า...",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            List<String> imageUrls =
                                await _uploadImagesToCloudinary();
                            await createProduct(imageUrls);

                            ref.invalidate(productProvider);
                            await Future.delayed(Duration(milliseconds: 100));
                            ref.refresh(productProviderByProductOwnerId(
                                productOwnerId));
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                          child: Text(
                            "โพสต์เลย",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }));
  }
}
