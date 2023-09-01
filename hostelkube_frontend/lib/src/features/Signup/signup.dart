import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import '/src/router/router.dart';
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

 Future<void> signUp() async {
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
  // Handle successful registration
} else if (response.statusCode == 400) {
  print(400);
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
                items: ['user', 'admin','employee']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: Colors.black)),
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
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                             MaterialPageRoute(
                                    builder: (context) => SignInScreen(), // Replace with your LoginScreen widget
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
