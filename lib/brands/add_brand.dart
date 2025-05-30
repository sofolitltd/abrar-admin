import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/category_controller.dart';
import '../models/brand_model.dart';

class AddBrand extends StatefulWidget {
  const AddBrand({super.key});

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  final categoryController = Get.put(CategoryController());

  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isFeatured = false;

  bool _isLoading = false;

  XFile? _imageFile; // To store the selected image
  String? _imageUrl;

  //
  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

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
                final pickedFile = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = pickedFile; // Single image selected
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
                    _imageFile = pickedFile; // Single image selected
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

  //
  Future<void> _uploadImage(String brandId) async {
    if (_imageFile == null) return; // No image selected

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('brands/$brandId.jpg'); // Unique name for the image

    try {
      if (kIsWeb) {
        // Web handling: upload as Uint8List
        Uint8List bytes = await _imageFile!.readAsBytes();
        await storageRef.putData(bytes);
      } else {
        // Mobile handling: upload as File
        await storageRef.putFile(File(_imageFile!.path));
      }

      // Get the download URL
      _imageUrl = await storageRef.getDownloadURL();
      print('Image uploaded: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

//
  void _addBrand() async {
    _isLoading = true;
    setState(() {});

    final brandId = DateTime.now().microsecondsSinceEpoch.toString();
    final slug = _generateSlug(_nameController.text.trim());

    try {
      //
      await _uploadImage(brandId);

      //
      final category = BrandModel(
        id: brandId,
        name: _nameController.text.trim(),
        slug: slug,
        imageUrl: _imageUrl ?? '',
        isFeatured: _isFeatured,
        createdDate: Timestamp.now(),
      );

      //
      await _firestore
          .collection('brands')
          .doc(category.id)
          .set(category.toJson())
          .then((val) {
        // Get.snackbar('Success', 'Category added successfully');
        _isLoading = false;
        setState(() {});
        Navigator.pop(context);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories();

    //
    return Scaffold(
      appBar: AppBar(title: const Text('Add Brand')),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              //
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Brand Name',
                  border: OutlineInputBorder(),
                ),
              ),

              //
              const SizedBox(height: 16),

              // Image Display and Picker
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Single Image Picker and Display
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      borderRadius: BorderRadius.circular(8),
                      image: _imageFile != null
                          ? DecorationImage(
                              image: kIsWeb
                                  ? NetworkImage(
                                      _imageFile!.path) // Web: NetworkImage
                                  : FileImage(File(_imageFile!.path))
                                      as ImageProvider, // Mobile: FileImage
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _imageFile != null
                        ? null
                        : const Icon(
                            Icons.image_outlined,
                            color: Colors.black38,
                            size: 32,
                          ),
                  ),
                  const SizedBox(width: 16),

                  // Single Image Picker Button
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Choose Image'),
                  ),
                ],
              ),

              //
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
                    'Featured Brand',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              //
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addBrand,
                  child: _isLoading == true
                      ? const SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Add Brand'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
