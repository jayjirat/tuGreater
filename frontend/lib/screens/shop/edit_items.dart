import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:frontend/screens/error_try.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditItems extends ConsumerStatefulWidget {
  final String productId;
  final String productOwnerId;
  const EditItems(
      {super.key, required this.productId, required this.productOwnerId});

  @override
  ConsumerState<EditItems> createState() => _EditItemsState();
}

class _EditItemsState extends ConsumerState<EditItems> {
  bool isCheckedOthers = false;
  String? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<String> tags = [];
  TextEditingController otherTagController = TextEditingController();
  FocusNode otherTagFocusNode = FocusNode();
  List<String> tagsOld = [];
  final List<String> excludedTags = [
    "มือหนึ่ง",
    "อร่อย",
    "สะอาด",
    "มือสอง",
    "สภาพดี"
  ];
  bool _hasInitialized = false;

  // Image related variables
  List<File> _selectedImages = [];

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

  Future _pickImagesFromGallery() async {
    final returnedImages = await ImagePicker().pickMultiImage();
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

  void showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.product_camera_popup),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.product_images_popup),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImagesFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

// Method to upload images to Cloudinary and get URLs
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

    setState(() {
      _selectedImages = [];
    });

    List<String> uploadedUrls = await Future.wait(uploadFutures);
    return uploadedUrls.where((url) => url.isNotEmpty).toList();
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
    final productId = widget.productId;
    final productOwnerId = widget.productOwnerId;
    final productDetailsAsyncValue =
        ref.watch(productProviderById(Tuple2(productId, context)));

    return Scaffold(
      appBar: Toolbar(title: AppLocalizations.of(context)!.edit_product_title),
      body: productDetailsAsyncValue.when(
        data: (product) {
          bool validateImages() {
            if (product.productImageUrls.isEmpty) {
              showToast(
                message: AppLocalizations.of(context)!.no_image,
                toastType: ToastType.info,
              );
              return false;
            }
            return true;
          }

          if (!_hasInitialized) {
            tagsOld = product.productTags;

            String? otherTag = tagsOld.firstWhere(
              (tag) => !excludedTags.contains(tag),
              orElse: () => "",
            );

            otherTagController.text = otherTag;
            isCheckedOthers = otherTag.isNotEmpty;
            _hasInitialized = true;
            nameController.text = product.productName;
            priceController.text =
                product.productPrice?.toInt().toString() ?? '';
            descriptionController.text = product.productDescription;
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      showImageSourceOptions();
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
                          Builder(
                            builder: (context) {
                              final allImages = [
                                ...product.productImageUrls
                                    .map((url) => {"type": "url", "data": url}),
                                ..._selectedImages.map(
                                    (file) => {"type": "file", "data": file}),
                              ];

                              if (allImages.isEmpty) {
                                return Center(
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
                                );
                              }

                              return GridView.builder(
                                padding: EdgeInsets.all(8),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4.0,
                                  mainAxisSpacing: 4.0,
                                ),
                                shrinkWrap: true,
                                itemCount: allImages.length,
                                itemBuilder: (context, index) {
                                  final item = allImages[index];
                                  if (item["type"] == "url") {
                                    final String url = item["data"] as String;
                                    return CachedNetworkImage(
                                      useOldImageOnUrlChange: true,
                                      fadeInDuration: Duration.zero,
                                      imageUrl: url,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => SizedBox(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    );
                                  } else {
                                    final File file = item["data"] as File;
                                    return Image.file(
                                      file,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          // Clear all button (URLs + files)
                          if (_selectedImages.isNotEmpty ||
                              product.productImageUrls.isNotEmpty)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImages.clear();
                                    product.productImageUrls.clear();
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
                        width: MediaQuery.of(context).size.width * 0.43,
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) * 0.5,
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: SizedBox(
                        width: (MediaQuery.of(context).size.width) * 0.2,
                        child: TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!
                                .product_price_placeholder,
                          ),
                        ),
                      ),
                    ),
                    Text("฿",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context)!.product_category,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: DropdownButtonFormField<String>(
                    dropdownColor: Theme.of(context).cardColor,
                    decoration: InputDecoration(),
                    value: product.productCategory.isEmpty
                        ? null
                        : product.productCategory,
                    hint: product.productCategory.isEmpty
                        ? Text(AppLocalizations.of(context)!
                            .product_select_category)
                        : null,
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
                // Tags Section (Checkboxes)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(AppLocalizations.of(context)!.product_tag,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 60) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: tagsOld.contains("มือหนึ่ง"),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    if (!tagsOld.contains("มือหนึ่ง")) {
                                      tagsOld.add("มือหนึ่ง");
                                    }
                                  } else {
                                    tagsOld.remove("มือหนึ่ง");
                                  }
                                });
                              },
                            ),
                            Flexible(
                                child: Text(AppLocalizations.of(context)!
                                    .tag_first_hand)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 60) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: tagsOld.contains("มือสอง"),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    if (!tagsOld.contains("มือสอง")) {
                                      tagsOld.add("มือสอง");
                                    }
                                  } else {
                                    tagsOld.remove("มือสอง");
                                  }
                                });
                              },
                            ),
                            Flexible(
                                child: Text(AppLocalizations.of(context)!
                                    .tag_second_hand)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 15) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: tagsOld.contains("สภาพดี"),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    if (!tagsOld.contains("สภาพดี")) {
                                      tagsOld.add("สภาพดี");
                                    }
                                  } else {
                                    tagsOld.remove("สภาพดี");
                                  }
                                });
                              },
                            ),
                            Flexible(
                                child: Text(AppLocalizations.of(context)!
                                    .tag_good_quality)),
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
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 60) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: tagsOld.contains("อร่อย"),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    if (!tagsOld.contains("อร่อย")) {
                                      tagsOld.add("อร่อย");
                                    }
                                  } else {
                                    tagsOld.remove("อร่อย");
                                  }
                                });
                              },
                            ),
                            Flexible(
                                child: Text(AppLocalizations.of(context)!
                                    .tag_delicious)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 60) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: tagsOld.contains("สะอาด"),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    if (!tagsOld.contains("สะอาด")) {
                                      tagsOld.add("สะอาด");
                                    }
                                  } else {
                                    tagsOld.remove("สะอาด");
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
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 15) / 3,
                        child: Row(
                          children: [
                            Checkbox(
                              value: isCheckedOthers,
                              onChanged: (value) {
                                setState(() {
                                  isCheckedOthers = value ?? false;
                                  final text = otherTagController.text.trim();

                                  if (isCheckedOthers) {
                                    if (text.isNotEmpty &&
                                        !excludedTags.contains(text) &&
                                        !tagsOld.contains(text)) {
                                      tagsOld.add(text);
                                    }
                                  } else {
                                    tagsOld.removeWhere(
                                      (tag) =>
                                          !excludedTags.contains(tag) &&
                                          tag == text,
                                    );
                                    otherTagController.clear();
                                  }

                                  tagsOld.removeWhere((tag) => tag.isEmpty);
                                });
                              },
                            ),
                            Flexible(
                              child: TextField(
                                controller: otherTagController,
                                enabled: isCheckedOthers,
                                decoration: InputDecoration(
                                  hintText: AppLocalizations.of(context)!
                                      .product_tag_other,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                ),
                                onChanged: (text) {
                                  if (isCheckedOthers) {
                                    setState(() {
                                      tagsOld.removeWhere((tag) => tag.isEmpty);
                                      tagsOld.removeWhere(
                                        (tag) =>
                                            !excludedTags.contains(tag) &&
                                            tag != text.trim() &&
                                            tag.isNotEmpty,
                                      );

                                      final trimmedText = text.trim();
                                      if (trimmedText.isNotEmpty &&
                                          !tagsOld.contains(trimmedText)) {
                                        tagsOld.add(trimmedText);
                                      }
                                    });
                                  }
                                },
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
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
                        decoration: InputDecoration(),
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
                SizedBox(height: 20),
                // Post Button
                FilledButton(
                  onPressed: () async {
                    if (!validateImages() ||
                        !_validateName() ||
                        !_validatePrice()) {
                      return;
                    }
                    if (isCheckedOthers && otherTagController.text.isNotEmpty) {
                      addTag();
                    }

                    // Show loading dialog
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
                                        .edit_product_waiting,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    List<String> uploadedUrls =
                        await _uploadImagesToCloudinary();

                    List<String> imageUrls = [
                      ...product.productImageUrls,
                      ...uploadedUrls,
                    ];

                    final updatedFields = {
                      "productName": nameController.text,
                      "productPrice": double.tryParse(priceController.text),
                      "productDescription": descriptionController.text,
                      "productTags": tagsOld,
                      "productImageUrls": imageUrls,
                      "productCategory": selectedCategory,
                      "productDateUpdate": DateTime.now().toIso8601String(),
                    };

                    try {} catch (e) {}
                    final updatedProduct = await ref.read(updateProduct(Tuple4(
                            productOwnerId, productId, updatedFields, context))
                        .future);

                    ref.invalidate(productProvider);
                    await Future.delayed(Duration(milliseconds: 100));
                    ref.refresh(productProviderByProductOwnerId(
                        Tuple2(productOwnerId, context)));
                    ref.refresh(
                        productProviderById(Tuple2(productId, context)));
                    if (context.mounted) {
                      showToast(
                        message:
                            AppLocalizations.of(context)!.productEditedSuccess,
                        toastType: ToastType.success,
                      );
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.edit_product_save,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorTry(
            errorMessage: error.toString(),
            ref: ref,
            provider: productProviderByProductOwnerId(
                Tuple2(productOwnerId, context))),
      ),
    );
  }
}
