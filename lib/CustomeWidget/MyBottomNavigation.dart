import 'package:flutter/material.dart';

class MyBottomNavigation extends StatefulWidget {
  final int currentIndex; // To track the selected tab
  final Function(int) onTap; // Callback function for handling taps

  const MyBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex, // Active tab index
      onTap: widget.onTap, // Handle tab selection
      type: BottomNavigationBarType.fixed, // Ensures all icons are visible
      backgroundColor: Colors.white, // Background color for the navigation bar
      selectedItemColor: const Color.fromARGB(255, 255, 98, 150), // Active item color
      unselectedItemColor: Colors.grey, // Inactive item color
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold, // Highlight selected label
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12, // Slightly smaller for unselected labels
      ),
      iconSize: 28, // Larger icons for better visibility
      elevation: 10, // Adds a shadow for depth
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_checkout_outlined),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_outlined),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_2_outlined),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
