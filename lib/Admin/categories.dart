import 'package:babyshop_hub/Admin/add_categories.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Sample categories list
  List<String> categories = [
    "Baby Clothing",
    "Toys",
    "Diapers",
    "Baby Food",
    "Strollers",
    "Car Seats",
    "Nursery Furniture",
    "Bath Essentials"
  ];

  void addCategory(String category) {
    setState(() {
      categories.add(category);
    });
  }

  void editCategory(int index, String newCategory) {
    setState(() {
      categories[index] = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("Products Categories"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 255, 98, 150),
                  foregroundColor: Colors.white,
                  child: Text(categories[index][0]),
                ),
                title: Text(
                  categories[index],
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
                        String editedCategory = categories[index];
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Edit Category"),
                              content: TextField(
                                onChanged: (value) {
                                  editedCategory = value;
                                },
                                controller: TextEditingController(
                                    text: categories[index]),
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
                                      editCategory(index, editedCategory);
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
                        setState(() {
                          categories.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategories()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
