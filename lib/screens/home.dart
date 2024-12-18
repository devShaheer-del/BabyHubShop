import 'package:babyshop_hub/CustomeWidget/MyBottomNavigation.dart';
import 'package:babyshop_hub/screens/favourite.dart';
import 'package:babyshop_hub/screens/profile.dart';
import 'package:babyshop_hub/screens/settings.dart';
import 'package:babyshop_hub/screens/shop.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0; // Track the selected tab index

  // Screens for each tab
  final List<Widget> screens = [
    const Center(child: Text("Welcome to Home Screen")), // Placeholder content
    const Shop(),
    const Favourite(),
    const Profile(),
    const Settings(),
  ];

  // Titles for each screen
  final List<String> titles = [
    "Home",
    "Shop",
    "Favourites",
    "Profile",
    "Settings",
  ];

  // Handle tab changes
  void onTap(int index) {
    setState(() {
      currentIndex = index; // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 98, 150),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(titles[currentIndex]), // Dynamic AppBar title
        actions: const [Icon(Icons.more_vert_outlined)],
      ),
      body: screens[currentIndex], // Display the selected screen's content
      bottomNavigationBar: MyBottomNavigation(
        currentIndex: currentIndex, // Pass the current tab index
        onTap: onTap, // Handle tab change
      ),
    );
  }
}
