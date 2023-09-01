import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String selectedRole = 'user';
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String registrationMessage = ''; // Added variable to display registration message

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
      emailController.text.isEmpty ||
      mobileController.text.isEmpty ||
      passwordController.text.isEmpty) {
    print("Empty fields");
    return; // Prevent further execution if fields are empty
  }
  
    final url = Uri.parse("http://localhost:3000/user/register"); // Replace with your backend API URL
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode({
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "phone_no": mobileController.text,
        "role": selectedRole,
      }),
    );

    if (response.statusCode == 200) {
      print(200);
      setState(() {
        registrationMessage = 'Your account is registered'; // Set registration message
      });

      Fluttertoast.showToast(
        msg: "Registration successful", // Toast message
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, // Position of the toast message
        timeInSecForIosWeb: 1, // Duration to display the toast message
        backgroundColor: Colors.green, // Background color of the toast
        textColor: Colors.white, // Text color of the toast
      );
      // Handle successful registration and navigate to login page
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SignInPage(), // Replace with your LoginScreen widget
        ),
      );
    } else if (response.statusCode == 400) {
      print(400);
       setState(() {
        registrationMessage = 'Please Enter all Details'; // Set registration message
      });
      // Handle validation error or other client-side error
    } else {
      print(420);
      // Handle other errors (e.g., server errors)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Sign Up',
            style: TextStyle(
              color: Colors.black, // Text color
            ),
          ),
        ),
        backgroundColor: Colors.white, // Set the background color of the AppBar to white
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.account_circle,
                size: 100.0,
                color: Colors.black,
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email or Username',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.black),
                controller: passwordController,
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
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedRole,
                items: ['user', 'admin', 'employee']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Role',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: Colors.black),
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
                onPressed: signUp,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Sign Up', style: TextStyle(fontSize: 16.0)),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                registrationMessage, // Display registration message
                style: TextStyle(color: Colors.green), // Customize the text color
              ),
              TextButton(
                onPressed: () {
                  // Navigate to the sign-in screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignInPage(), // Replace with your LoginScreen widget
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Sign In',
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

