import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import '../Signup/signup.dart';
import './forgotpassword.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
  }

  Future<void> _signIn() async {
  final email = emailController.text;
  final password = passwordController.text;

  if (!isValidEmail(email)) {
    _showSnackBar('Invalid email address');
    return;
  }

  try {
    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      final user = userCredential.user!;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', user.uid);

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        _showSnackBar(
          'A verification link has been sent to your email address. Please check your email and click on the link to verify your email before signing in.',
        );
      } else {
        final userId = user.uid;
        final userRole = await getUserRoleFromFirebase(email);

        if (userRole == 'admin') {
          // Redirect to the admin page
          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => AdminHomePage(userId: userId),
  ),
);

        } else {
          // Redirect to the user/home page
          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => HomePage(userId: userId),
  ),
);

        }
      }
    } else {
      _showSnackBar('Sign-in failed');
    }
  } catch (error) {
    print(error);
    _showSnackBar('Error occurred during sign-in: $error');
  }
}

Future<String> getUserRoleFromFirebase(String email) async {
  try {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    final querySnapshot = await usersCollection.where('email', isEqualTo: email).get();
  
    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
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
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Sign In',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ... Rest of your UI code for the sign-in screen
                 Icon(
                Icons.account_circle,
                size: 100.0,
                color: Colors.black,
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress, // Use email keyboard type
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _signIn,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Sign In', style: TextStyle(fontSize: 16.0)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordPage(),
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ),
                  );
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
