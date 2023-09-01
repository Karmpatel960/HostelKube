import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import '/src/router/router.dart';


class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignInPage(),
      theme: ThemeData(
        primaryColor: Colors.blue, // Change the primary color
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue, // Change the primary color
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  String selectedRole = 'User';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Center(
    child: Text(
      'Sign In',
      style: TextStyle(
        color: Colors.black, // Text color
      ),
    ),
  ),
  backgroundColor: Colors.white, // Set the background color of the AppBar to white
),
      body: Container(
      decoration: BoxDecoration(
  color: Colors.white, // Set the background color to white
),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100.0,
                color: Colors.black,
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: TextField(
                  style: TextStyle(color: Colors.black), // Change text color to black
                  decoration: InputDecoration(
                    labelText: 'Email or Username',
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
                  style: TextStyle(color: Colors.black), // Change text color to black
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: ['User', 'Admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)), // Change text color to black
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedRole = newValue!;
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
                onPressed: () {
                  // Add sign-in logic here
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Sign In', style: TextStyle(fontSize: 16.0)),
                ),
              ),
              TextButton(
                onPressed: () {
                   Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PasswordPage(), // Replace with your LoginScreen widget
      ),
    );
                  // Add navigation to the forgot password page
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black), // Change text color to black
                ),
              ),
              TextButton(
                onPressed: () {
                   Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage(), // Replace with your LoginScreen widget
      ),
    );
                  // Add navigation to the registration page
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.black), // Change text color to black
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}