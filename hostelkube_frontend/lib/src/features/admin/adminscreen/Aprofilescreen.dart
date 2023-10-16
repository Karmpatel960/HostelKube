import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AProfileScreen extends StatefulWidget {
  @override
  _AProfileScreenState createState() => _AProfileScreenState();
}

class _AProfileScreenState extends State<AProfileScreen> {
  String userName = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Fetch and set the user's data from Firestore
    fetchUserDataFromFirestore();
  }

  Future<void> fetchUserDataFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final fetchedName = userData['name'];
          print('Fetched Name: $fetchedName'); // Add this line for debugging
          setState(() {
            userName = fetchedName ?? ''; // Update userName
          });
        } else {
          print('User document does not exist');
        }
      } else {
        print('User is not signed in');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
        final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignInScreen(), // Replace with your sign-in screen
      ));
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
         actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications or alerts
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ], // Set the title here
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('./profile_image.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                userName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                'Email:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'john.doe@example.com', // Replace with the student's email
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '123-456-7890', // Replace with the student's phone number
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '123 Main St, City, Country', // Replace with the student's address
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: logout, // Call the logout function
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


