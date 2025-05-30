import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/brand_controller.dart';
import '../controllers/category_controller.dart';
import '../models/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _stockPriceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;
  bool _isFeatured = false;
  bool isLoading = false;

  List<XFile> _imageFiles = [];
  final List<String> _imageUrls = [];

  final categoryController = Get.put(CategoryController());
  final brandController = Get.put(BrandController());

  //
  Future<void> _pickImage() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                final _picker = ImagePicker();
                final List<XFile>? pickedFiles = await _picker.pickMultiImage(
                  imageQuality: 100,
                  maxWidth: 512,
                  maxHeight: 512,
                );
                if (pickedFiles != null) {
                  setState(() {
                    _imageFiles = pickedFiles;
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Gallery'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                final _picker = ImagePicker();
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFiles = [pickedFile];
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Camera'),
              ),
            ),
          ],
        );
      },
    );
  }

  // Upload images to Firebase Storage
  Future<void> _uploadImages(String productId) async {
    _imageUrls.clear();
    for (int i = 0; i < _imageFiles.length; i++) {
      final storageRef =
          FirebaseStorage.instance.ref().child('products/$productId-$i.jpg');

      try {
        if (kIsWeb) {
          Uint8List bytes = await _imageFiles[i].readAsBytes();
          await storageRef.putData(bytes);
        } else {
          await storageRef.putFile(File(_imageFiles[i].path));
        }

        String downloadUrl = await storageRef.getDownloadURL();
        _imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories();

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // des
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Product Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 10),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a product description';
                    //   }
                    //   return null;
                    // },
                  ),

                  const SizedBox(height: 16),

                  // price
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //cost
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _costPriceController,
                          decoration: InputDecoration(
                            labelText: 'Cost Price',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the cost price';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),

                      // sale
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _salePriceController,
                          decoration: InputDecoration(
                            labelText: 'Sale Price',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the sale price';
                            }
                            double regularPrice =
                                double.parse(_regularPriceController.text);
                            double salePrice = double.parse(value);
                            if (regularPrice < salePrice) {
                              return 'Regular price less than sale price';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      //regular
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _regularPriceController,
                          decoration: InputDecoration(
                            labelText: 'Regular Price',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the regular price';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      // stock
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _stockPriceController,
                          decoration: InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 10,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the stock';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Parent Category Dropdown
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButton<String>(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                // Add horizontal padding
                                isDense: true,
                                isExpanded: true,
                                value: _selectedCategory,
                                hint: const Text('Parent Category'),
                                items: categoryController.allMainCategories
                                    .map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category.name,
                                    // Use the category ID for value
                                    child: Text(category.name),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  _selectedCategory = value;
                                  _selectedSubCategory =
                                      null; // Reset subcategory selection
                                  setState(() {});
                                },
                                underline: const SizedBox(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_selectedCategory != null)
                          IconButton(
                            // Add clear icon button
                            onPressed: () {
                              _selectedCategory = null; // Clear the selection
                              _selectedSubCategory =
                                  null; // Reset subcategory selection
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          ),
                      ],
                    ),
                  ),

                  // Subcategory Dropdown
                  if (_selectedCategory != null) ...[
                    const SizedBox(height: 16),
                    Obx(
                      () {
                        //
                        if (_selectedCategory != null) {
                          categoryController
                              .fetchSubCategories(_selectedCategory!);
                        }

                        //
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    // Add horizontal padding
                                    isDense: true,
                                    isExpanded: true,
                                    value: _selectedSubCategory,
                                    hint: const Text('Sub Category'),
                                    items: categoryController.subCategories
                                        .where((category) =>
                                            category.parentId ==
                                            _selectedCategory) // Compare with parent ID
                                        .map((category) {
                                      return DropdownMenuItem<String>(
                                        value: category.name,
                                        // Use the category ID for value
                                        child: Text(category.name),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      _selectedSubCategory = value;
                                      setState(() {});
                                    },
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_selectedSubCategory != null)
                              IconButton(
                                // Add clear icon button
                                onPressed: () {
                                  _selectedSubCategory =
                                      null; // Clear the selection
                                  _selectedBrand = null;
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              ),
                          ],
                        );
                      },
                    ),
                  ],

                  // brand
                  ...[
                    const SizedBox(height: 16),
                    Obx(
                      () {
                        //
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    // Add horizontal padding
                                    isDense: true,
                                    isExpanded: true,
                                    value: _selectedBrand,
                                    hint: const Text('Brand'),
                                    items:
                                        brandController.allBrands.map((brand) {
                                      return DropdownMenuItem<String>(
                                        value: brand.name,
                                        // Use the category ID for value
                                        child: Text(brand.name),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      _selectedBrand = value;
                                      setState(() {});
                                    },
                                    underline: const SizedBox(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (_selectedBrand != null)
                              IconButton(
                                // Add clear icon button
                                onPressed: () {
                                  _selectedBrand = null; // Clear the selection
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              ),
                          ],
                        );
                      },
                    ),
                  ],

                  //
                  const SizedBox(height: 16),

                  //
                  // Image Picker
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ..._imageFiles.map((imageFile) {
                          return Container(
                            height: 80,
                            width: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: kIsWeb
                                    ? NetworkImage(imageFile.path)
                                    : FileImage(File(imageFile.path))
                                        as ImageProvider,
                              ),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(Icons.add, size: 32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // featured
                  Row(
                    children: [
                      Checkbox(
                        value: _isFeatured,
                        onChanged: (bool? value) {
                          setState(() {
                            _isFeatured = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Featured Product',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // add btn
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  isLoading = true;
                                });
                                //
                                //   //
                                String id = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                //
                                //   //
                                String slug =
                                    _generateSlug(_nameController.text.trim());

                                //
                                await _uploadImages(id);
                                int sku = await getNextSku();

                                //
                                ProductModel product = ProductModel(
                                  id: id,
                                  sku: sku,
                                  name: _nameController.text.trim(),
                                  slug: slug,
                                  description:
                                      _descriptionController.text.trim() ?? '',
                                  regularPrice: double.parse(
                                      _regularPriceController.text),
                                  salePrice: double.parse(
                                      _salePriceController.text.trim()),
                                  costPrice: double.parse(
                                      _costPriceController.text.trim()),
                                  stock: int.parse(
                                      _stockPriceController.text.trim()),
                                  images: _imageUrls,
                                  category: _selectedCategory ?? "",
                                  subCategory: _selectedSubCategory ?? "",
                                  brand: _selectedBrand ?? "",
                                  isFeatured: _isFeatured,
                                  createdDate: Timestamp.now(),
                                );
                                //

                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .doc(id)
                                    .set(product.toJson())
                                    .then((value) {
                                  if (kDebugMode) {
                                    print('Add successfully');
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(context);
                                });
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 32,
                              width: 32,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text('Add Product'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // slug
  String _generateSlug(String name) {
    // Simple slug generation: lowercase, replace spaces with hyphens
    return name.toLowerCase().replaceAll(' ', '-');
  }

  // sku
  Future<int> getNextSku() async {
    final skuTrackerRef =
        FirebaseFirestore.instance.collection('settings').doc('skuTracker');
    final docSnapshot = await skuTrackerRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      final lastSku = data?['lastSku'] ?? 0;
      final nextSku = lastSku + 1;
      return nextSku;
    } else {
      // If skuTracker does not exist yet
      await skuTrackerRef.set({'lastSku': 0});
      return 1;
    }
  }
}
