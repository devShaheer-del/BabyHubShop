import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babyshop_hub/Admin/add_categories.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Products Categories"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categoriesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No categories available"));
          }

          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];

              // Check if 'CategoryTitle' exists and is non-null
              final categoryData = category.data() as Map<String, dynamic>;
              final categoryName = categoryData['CategoryTitle'] ?? "Unnamed Category";

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 255, 98, 150),
                    foregroundColor: Colors.white,
                    child: Text(categoryName[0]),
                  ),
                  title: Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          String editedCategory = categoryName;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Edit Category"),
                                content: TextField(
                                  onChanged: (value) {
                                    editedCategory = value;
                                  },
                                  controller:
                                      TextEditingController(text: categoryName),
                                  decoration: const InputDecoration(
                                    hintText: "Enter new category name",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (editedCategory.isNotEmpty) {
                                        categoriesCollection
                                            .doc(category.id)
                                            .update({'CategoryTitle': editedCategory});
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          categoriesCollection.doc(category.id).delete();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddCategories()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
