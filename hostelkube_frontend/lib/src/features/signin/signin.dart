import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hostelkube_frontend/src/features/features.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String selectedRole = 'user';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController emailOrUsernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

 void _signIn() async {
  final apiUrl = Uri.parse("http://localhost:3000/user/login"); // Replace with your API URL

  try {
    final response = await http.post(
      apiUrl,
      body: {
        "email": emailOrUsernameController.text,
        "password": passwordController.text,
        "role": selectedRole,
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPVerificationPage(
            email: emailOrUsernameController.text, // Pass the email
          ),
        ),
      );
    } else {
      // Sign-in failed, show an error message
      _showSnackBar('Sign-in failed');
    }
  } catch (error) {
    // Handle network or other errors
    print(error);
    _showSnackBar('Error occurred during sign-in');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Add the key to the Scaffold
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
                  controller: emailOrUsernameController,
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
                  controller: passwordController,
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
                  items: ['user', 'admin','employee']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)), // Change text color to black
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
                // onPressed: _signIn,

                   onPressed: () {
                  // Add navigation to the forgot password page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomePage(), // Replace with your SignUpPage widget
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Sign In', style: TextStyle(fontSize: 16.0)),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add navigation to the forgot password page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PasswordPage(), // Replace with your SignUpPage widget
                    ),
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.black), // Change text color to black
                ),
              ),
              TextButton(
                onPressed: () {
                  // Add navigation to the registration page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignUpPage(), // Replace with your SignUpPage widget
                    ),
                  );
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

