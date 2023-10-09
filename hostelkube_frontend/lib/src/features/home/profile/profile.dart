import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = ''; // Initialize with empty string

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
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            userName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Display other profile details using state variables
        ],
      ),
    );
  }
}
