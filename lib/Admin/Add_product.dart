import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<String> _categories = [];
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();

  Rx<Uint8List?> imageBytes =
      Rx<Uint8List?>(null); // For displaying selected image on web
  RxString imagePath = ''.obs; // For storing selected image path on mobile

  Future<void> _fetchCategories() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      var categoryList = querySnapshot.docs
          .map((doc) {
            if (doc.data().containsKey('CategoryTitle')) {
              return doc['CategoryTitle'] as String;
            } else {
              print('CategoryTitle field is missing in document: ${doc.id}');
              return null;
            }
          })
          .where((category) => category != null)
          .toList();

      setState(() {
        _categories = categoryList.cast<String>();
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      if (kIsWeb) {
        // For Web, read image bytes
        final Uint8List bytes = await pickedImage.readAsBytes();
        imageBytes.value = bytes;
      } else {
        // For Mobile, get image path
        imagePath.value = pickedImage.path;
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await FirebaseFirestore.instance.collection('products').add({
        'name': _productNameController.text,
        'category': _selectedCategory,
        'price': double.parse(_productPriceController.text),
        'imagePath': kIsWeb ? 'Uploaded via Web' : imagePath.value,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added successfully!')),
      );

      // Reset form
      _formKey.currentState!.reset();
      imageBytes.value = null;
      imagePath.value = '';
      setState(() {
        _selectedCategory = null;
      });
    } catch (e) {
      print("Error saving product: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding product!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Add Product"),
      ),
      drawer: const Sidedrawer(),
      body: Center(
        child: _categories.isEmpty
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      // Product Image Section
                      Obx(
                        () => Container(
                          width: 300,
                          height: 150,
                          margin: const EdgeInsets.only(top: 20, bottom: 20),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: kIsWeb
                              ? (imageBytes.value != null
                                  ? Image.memory(
                                      imageBytes.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Text("No Image Selected")))
                              : (imagePath.value.isNotEmpty
                                  ? Image.file(
                                      File(imagePath.value),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      '../../assets/images/babyproducts.png',
                                      fit: BoxFit.cover,
                                    )),
                        ),
                      ),

                      // Product Name Input
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _productNameController,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.shopping_bag_outlined),
                            hintText: "Product Name",
                            labelText: "Product Name",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the product name";
                            }
                            return null;
                          },
                        ),
                      ),

                      // Product Category Dropdown
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Product Category",
                          ),
                          value: _selectedCategory,
                          items: _categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                        ),
                      ),

                      // Product Price Input
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _productPriceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.currency_rupee_outlined),
                            hintText: "Product Price",
                            labelText: "Product Price",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter the product price";
                            }
                            if (double.tryParse(value) == null) {
                              return "Please enter a valid number";
                            }
                            return null;
                          },
                        ),
                      ),

                      // Add Product Image Button
                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 98, 150),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text("Add Product Image"),
                        ),
                      ),

                      // Save Button
                      Container(
                        width: 300,
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: _saveProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 98, 150),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            "Add Product",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
