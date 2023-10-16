import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/router/router.dart';
import '/src/features/features.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _mounted = true;
  @override
  void initState() {
    super.initState();
    _checkAutoLogin();

    // Simulate some time-taking initialization process.
   Future.delayed(Duration(seconds: 3), () {
    if (_mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Welcome()));
    }
    });
  }

  void dispose() {
    _mounted = false; // Set the flag to false when the widget is disposed.
    super.dispose();
  }

Future<void> _checkAutoLogin() async {
  if (!mounted) {
    return; // Check if the widget is still mounted
  }

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  if (userId != null) {
    final userRole = await getUserRoleFromFirebase(userId); // Pass user ID

    if (!mounted) {
      return; // Check if the widget is still mounted
    }

    Widget destinationScreen;

    if (userRole == 'admin') {
      destinationScreen = AdminHomePage(userId: userId);
    } else {
      destinationScreen = HomeScreen(userId: userId);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => destinationScreen));
  }
}




  Future<String> getUserRoleFromFirebase(String userId) async {
    try {
      final usersCollection = FirebaseFirestore.instance.collection('users');
      final userDoc = await usersCollection.doc(userId).get();

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final userRole = userData['selectedRole'];
        return userRole;
      }

      // Handle the case where the user's data is not found in Firestore
      return 'user'; // Default role if not found
    } catch (error) {
      // Handle any potential errors, e.g., network issues, Firestore errors, etc.
      print('Error while fetching user role: $error');
      return 'user'; // Default role if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 12, 39, 1),
      body: const Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "HostelKube",
                  style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20), // Adjust the spacing as needed
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 52, 255, 252))),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20, // Adjust the bottom spacing as needed
            child: Center(
              child: Text(
                'Powered By HostelKube Team @2023',
                style: TextStyle(fontSize: 9, color: Colors.white, height: 1.385),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
