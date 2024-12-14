import 'package:babyshop_hub/Admin/Add_product.dart';
import 'package:babyshop_hub/Admin/DashBoard.dart';
import 'package:babyshop_hub/Admin/add_categories.dart';
import 'package:babyshop_hub/Admin/categories.dart';
import 'package:babyshop_hub/screens/login.dart';
import 'package:flutter/material.dart';

class Sidedrawer extends StatelessWidget {
  const Sidedrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              color: const Color.fromARGB(255, 255, 98, 150),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'john.doe@example.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Navigation Items
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            onTap: () {
              // Handle navigation to Home
              Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));; // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Add Product Categories'),
            onTap: () {
              // Handle navigation to Profile
              Navigator.push(context, MaterialPageRoute(builder: (context) => Categories())); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_checkout_outlined),
            title: const Text('Add Products'),
            onTap: () {
              // Handle navigation to Settings
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct())); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.link_off_outlined),
            title: const Text('Order Tracking'),
            onTap: () {
              // Handle navigation to Settings
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback_outlined),
            title: const Text('Customer Feedbacks'),
            onTap: () {
              // Handle navigation to Settings
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_2_outlined),
            title: const Text('Customer Compalints'),
            onTap: () {
              // Handle navigation to Settings
              Navigator.pop(context); // Close the drawer
            },
          ),
          
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Handle logout
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login())); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
