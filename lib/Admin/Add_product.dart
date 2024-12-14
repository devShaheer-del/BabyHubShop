import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  List<String> _categories = []; // Holds categories fetched from Firestore
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();

  // Fetch categories from Firestore
// Fetch categories from Firestore
  Future<void> _fetchCategories() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('categories') // Name of your Firestore collection
          .get();

      // Map each document in Firestore to its 'CategoryTitle' field
      var categoryList = querySnapshot.docs
          .map((doc) {
            // Check if the 'CategoryTitle' field exists in the document
            if (doc.data().containsKey('CategoryTitle')) {
              return doc['CategoryTitle']
                  as String; // Get the CategoryTitle field
            } else {
              print('CategoryTitle field is missing in document: ${doc.id}');
              return null; // Return null if the field is missing
            }
          })
          .where((category) => category != null)
          .toList(); // Filter out null values

      setState(() {
        _categories =
            categoryList.cast<String>(); // Safely cast to List<String>
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }



  @override
  void initState() {
    super.initState();
    _fetchCategories(); // Fetch categories when the screen loads
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
        child: _categories
                .isEmpty // Show a loading spinner if categories are empty
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    children: [
                      // Product Image Section
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Image.asset(
                          '../../assets/images/babyproducts.png', // Fixed asset path
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Product Name Input
                      Container(
                        width: 300,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: TextFormField(
                          controller: _productNameController,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.shopping_bag_outlined),
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
                          decoration: InputDecoration(
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
                          decoration: InputDecoration(
                            suffixIcon:
                                const Icon(Icons.currency_rupee_outlined),
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

                      Container(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: (){

                          },
                          child: Text("Add Product Image"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 98, 150),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),

                      // Save Button
                      Container(
                        width: 300,
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product added successfully!'),
                                ),
                              );
                              // Add product save logic here
                            }
                          },
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
