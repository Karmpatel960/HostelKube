import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = ''; // Initialize with empty string
  String roomNumber = '';
  String phoneNumber = '';
  // Add more variables for other profile details as needed

  @override
  void initState() {
    super.initState();
    // Fetch profile data from the backend here and update the state variables
    fetchDataFromBackend();
  }

  void fetchDataFromBackend() {
    // Simulate fetching data from the backend (replace with your actual data fetching logic)
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        // Update the state variables with fetched data
        userName = 'John Doe'; // Replace with fetched data
        roomNumber = '101'; // Replace with fetched data
        phoneNumber = '+1234567890'; // Replace with fetched data
        // Update other profile details as needed
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/profile_image.jpg'), // Replace with your profile image
          ),
          SizedBox(height: 20),
          Text(
            userName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Room: $roomNumber',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Phone: $phoneNumber',
            style: TextStyle(fontSize: 16),
          ),
          // Display other profile details using state variables
        ],
      ),
  

    );
  }
}
