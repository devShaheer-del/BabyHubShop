import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  Rx<Uint8List?> imageBytes = Rx<Uint8List?>(null);
  RxString imagePath = ''.obs;

  String? uploadedImageUrl; // To store Cloudinary image URL

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
        final Uint8List bytes = await pickedImage.readAsBytes();
        imageBytes.value = bytes;
      } else {
        imagePath.value = pickedImage.path;
      }
    }
  }

  Future<String?> _uploadImageToCloudinary() async {
    const String cloudinaryUrl =
        'https://api.cloudinary.com/v1_1/dog8hzzop/image/upload';
    const String uploadPreset = 'BabyHubShopProduct'; // Your upload preset

    try {
      var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUrl));
      request.fields['upload_preset'] = uploadPreset;

      // Check if the platform is Web or Mobile
      if (kIsWeb) {
        if (imageBytes.value != null) {
          // For Web: Upload the image as bytes
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            imageBytes.value!,
            filename: 'product_image.jpg',
          ));
        } else {
          throw Exception("No image selected for upload (Web).");
        }
      } else {
        if (imagePath.value.isNotEmpty) {
          // For Mobile: Upload the file using its path
          request.files.add(await http.MultipartFile.fromPath(
            'file',
            imagePath.value,
            filename: 'product_image.jpg',
          ));
        } else {
          throw Exception("No image selected for upload (Mobile).");
        }
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data['secure_url']; // Return the secure URL from Cloudinary
      } else {
        print("Failed to upload image. Status code: ${response.statusCode}");
        print("Response: ${await response.stream.bytesToString()}");
        return null;
      }
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      // Step 1: Upload the image to Cloudinary
      uploadedImageUrl = await _uploadImageToCloudinary();

      if (uploadedImageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image upload failed!')),
        );
        return;
      }

      // Step 2: Save product data with the uploaded image URL
      await FirebaseFirestore.instance.collection('products').add({
        'name': _productNameController.text,
        'category': _selectedCategory,
        'price': double.parse(_productPriceController.text),
        'imageUrl': uploadedImageUrl,
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
        uploadedImageUrl = null;
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
                      // Image Picker
                      Obx(() => Container(
                            width: 300,
                            height: 150,
                            margin: const EdgeInsets.only(top: 20, bottom: 20),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: kIsWeb
                                ? (imageBytes.value != null
                                    ? Image.memory(imageBytes.value!,
                                        fit: BoxFit.cover)
                                    : const Center(
                                        child: Text("No Image Selected")))
                                : (imagePath.value.isNotEmpty
                                    ? Image.file(File(imagePath.value),
                                        fit: BoxFit.cover)
                                    : Image.asset(
                                        '../../assets/images/babyproducts.png',
                                        fit: BoxFit.cover)),
                          )),

                      // Product Details
                      _buildTextField(_productNameController, "Product Name",
                          Icons.shopping_bag_outlined),
                      _buildDropdown(),
                      _buildTextField(_productPriceController, "Product Price",
                          Icons.currency_rupee_outlined,
                          isNumber: true),

                      // Buttons
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Add Product Image"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveProduct,
                        child: const Text("Add Product"),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          suffixIcon: Icon(icon),
          hintText: label,
          labelText: label,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Please enter $label";
          if (isNumber && double.tryParse(value) == null)
            return "Please enter a valid number";
          return null;
        },
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: "Product Category"),
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
        validator: (value) => value == null ? "Please select a category" : null,
      ),
    );
  }
}
