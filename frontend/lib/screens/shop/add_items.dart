import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tuple/tuple.dart';

class AddItems extends ConsumerStatefulWidget {
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
  final List<File> _selectedImages = [];

  Future<void> createProduct(
      List<String> imageUrls, String userId, String displayname) async {
    try {
      var url = "http://10.0.2.2:8080/shop";

      var response = await http
          .post(
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
              'productOwner': displayname,
              'productOwnerId': userId
            }),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
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
                title: Text(AppLocalizations.of(context)!.product_images_popup),
                onTap: () {
                  _pickImagesFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(AppLocalizations.of(context)!.product_camera_popup),
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
          showToast(
              message:
                  "${AppLocalizations.of(context)!.uploadProductImagesFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
          return '';
        }
      } catch (e) {
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ErrorPage(
                    errorMessage:
                        "${AppLocalizations.of(context)!.unableUploadProductImages} ${AppLocalizations.of(context)!.checkYourConnection}"),
              ));
        }
        return '';
      }
    }).toList();

    List<String> uploadedUrls = await Future.wait(uploadFutures);
    return uploadedUrls.where((url) => url.isNotEmpty).toList();
  }

  bool _validateImages() {
    if (_selectedImages.isEmpty) {
      showToast(
        message: AppLocalizations.of(context)!.no_image,
        toastType: ToastType.info,
      );
      return false;
    }
    return true;
  }

  bool _validateName() {
    if (nameController.text.isEmpty) {
      showToast(
        message: AppLocalizations.of(context)!.no_name,
        toastType: ToastType.info,
      );
      return false;
    }
    return true;
  }

  bool _validatePrice() {
    if (priceController.text.isEmpty) {
      showToast(
        message: AppLocalizations.of(context)!.no_price,
        toastType: ToastType.info,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: Toolbar(title: AppLocalizations.of(context)!.add_product_title),
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
                      border: Border.all(
                          color: Theme.of(context).canvasColor, width: 2),
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
                                    SvgPicture.asset(
                                      "assets/svg/upload.svg",
                                      color: _selectedImages.length == 0
                                          ? Theme.of(context).canvasColor
                                          : Theme.of(context).cardColor,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                        AppLocalizations.of(context)!
                                            .product_images,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.42,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.product_name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.10,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.product_price,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        width: (MediaQuery.of(context).size.width) * 0.5,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .product_name_placeholder,
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
                        width: (MediaQuery.of(context).size.width) * 0.2,
                        child: TextField(
                          controller: priceController,
                          keyboardType:
                              TextInputType.number, // Set keyboard to number
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Allow only numbers
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .product_price_placeholder,
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
                    AppLocalizations.of(context)!.product_category,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: DropdownButtonFormField<String>(
                  dropdownColor: Theme.of(context).cardColor,
                  decoration: InputDecoration(
                      // Background color
                      ),
                  value: selectedCategory,
                  hint: Text(
                      AppLocalizations.of(context)!.product_select_category),
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
                    AppLocalizations.of(context)!.product_tag,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // First checkbox
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedFirstHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedFirstHanded = value!;
                                if (value) {
                                  tags.add("มือหนึ่ง");
                                } else {
                                  tags.remove("มือหนึ่ง");
                                }
                              });
                            },
                          ),
                          Flexible(
                            child: Text(
                                AppLocalizations.of(context)!.tag_first_hand),
                          ),
                        ],
                      ),
                    ),

                    // Second checkbox
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedSecondHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedSecondHanded = value!;
                                if (value) {
                                  tags.add("มือสอง");
                                } else {
                                  tags.remove("มือสอง");
                                }
                              });
                            },
                          ),
                          Flexible(
                            child: Text(
                                AppLocalizations.of(context)!.tag_second_hand),
                          ),
                        ],
                      ),
                    ),

                    // Third checkbox
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 15) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedThirdHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedThirdHanded = value!;
                                if (value) {
                                  tags.add("สภาพดี");
                                } else {
                                  tags.remove("สภาพดี");
                                }
                              });
                            },
                          ),
                          Flexible(
                            child: Text(
                                AppLocalizations.of(context)!.tag_good_quality),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Fourth checkbox
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedFourthHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedFourthHanded = value!;
                                if (value) {
                                  tags.add("อร่อย");
                                } else {
                                  tags.remove("อร่อย");
                                }
                              });
                            },
                          ),
                          Flexible(
                              child: Text(
                                  AppLocalizations.of(context)!.tag_delicious)),
                        ],
                      ),
                    ),

                    // Fifth checkbox
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 60) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedFifthHanded,
                            onChanged: (value) {
                              setState(() {
                                isCheckedFifthHanded = value!;
                                if (value) {
                                  tags.add("สะอาด");
                                } else {
                                  tags.remove("สะอาด");
                                }
                              });
                            },
                          ),
                          Flexible(
                              child: Text(
                                  AppLocalizations.of(context)!.tag_clean)),
                        ],
                      ),
                    ),

                    // Others checkbox with input
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 15) / 3,
                      child: Row(
                        children: [
                          Checkbox(
                            value: isCheckedOthers,
                            onChanged: (value) {
                              setState(() {
                                isCheckedOthers = value!;
                                if (!value) {
                                  tags.removeWhere(
                                    (tag) => tag == otherTagController.text,
                                  );
                                  otherTagController.clear();
                                }
                              });
                            },
                          ),
                          Flexible(
                            child: TextField(
                              controller: otherTagController,
                              focusNode: otherTagFocusNode,
                              enabled: isCheckedOthers,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .product_tag_other,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.product_description,
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
                        hintText: AppLocalizations.of(context)!
                            .product_description_placeholder,
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
                    AppLocalizations.of(context)!.product_caution,
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
                          if (!_validateImages() ||
                              !_validateName() ||
                              !_validatePrice()) {
                            return;
                          }

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
                                        AppLocalizations.of(context)!
                                            .create_product_waiting,
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

                          try {
                            await createProduct(
                                imageUrls, user!.id, user.displayName);

                            ref.invalidate(productProvider);
                            await Future.delayed(Duration(milliseconds: 100));
                            ref.refresh(productProviderByProductOwnerId(
                                Tuple2(user.id, context)));
                            if (context.mounted) {
                              showToast(
                                message: AppLocalizations.of(context)!
                                    .productCreatedSuccess,
                                toastType: ToastType.success,
                              );
                              Navigator.pop(context);
                              Navigator.pop(context, true);
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
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.create_product,
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
        ));
  }
}
