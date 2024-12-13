import 'package:babyshop_hub/CustomeWidget/SideDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddCategories extends StatefulWidget {
  const AddCategories({super.key});

  @override
  State<AddCategories> createState() => _AddCategoriesState();
}

class _AddCategoriesState extends State<AddCategories> {
  final TextEditingController _title = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _title.dispose(); // Dispose the controller to prevent memory leaks
    super.dispose();
  }

  void addCategory() async {
    if (_formKey.currentState!.validate()) {
      final _titleText = _title.text.trim();

      try {
        await FirebaseFirestore.instance.collection('categories').add({
          'CategoryTitle': _titleText,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category was Successfully Added')),
        );

        _title.clear(); // Clear the text field after adding
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Add Categories"),
      ),
      drawer: const Sidedrawer(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Include the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 300,
                  child: Image.asset(
                    '../../assets/images/add_category.png', // Update the asset path
                    height: 200,
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: 300,
                  child: TextFormField(
                    controller: _title,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Title is required";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.category_outlined),
                      hintText: "Category Title",
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: addCategory,
                    child: const Text("Add Category"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 98, 150),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
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
