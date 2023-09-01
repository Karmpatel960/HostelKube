import 'package:flutter/material.dart';

class CommonBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  CommonBottomBar({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color to white
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          // Handle tap if needed
        },
        child: Icon(
          Icons.home,
          color: currentIndex == 0 ? Colors.blue : Colors.grey, // Customize color here
        ),
      ),
      label: 'Home',
      backgroundColor: Colors.transparent, // Set background color if needed
    ),
    BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          // Handle tap if needed
        },
        child: Icon(
          Icons.receipt_long,
          color: currentIndex == 1 ? Colors.blue : Colors.grey, // Customize color here
        ),
      ),
      label: 'Receipt',
      backgroundColor: Colors.transparent, // Set background color if needed
    ),
    BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          // Handle tap if needed
        },
        child: Icon(
          Icons.food_bank,
          color: currentIndex == 2 ? Colors.blue : Colors.grey, // Customize color here
        ),
      ),
      label: 'Food',
      backgroundColor: Colors.transparent, // Set background color if needed
    ),
    BottomNavigationBarItem(
      icon: InkWell(
        onTap: () {
          // Handle tap if needed
        },
        child: Icon(
          Icons.person,
          color: currentIndex == 3 ? Colors.blue : Colors.grey, // Customize color here
        ),
      ),
      label: 'Profile',
      backgroundColor: Colors.transparent, // Set background color if needed
    ),
        ],
      ),
    );
  }
}


