import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import '/src/router/router.dart';




class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HostelKube',
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/background.png', // Replace with your background image path
            fit: BoxFit.cover,
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                color: Colors.black.withOpacity(0.5), // Add a semi-transparent black overlay
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME TO HOSTELKUBE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                   ElevatedButton(
  onPressed: () {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(), // Replace with your LoginScreen widget
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.white, // Button color
  ),
  child: Text(
    'Get Started',
    style: TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
  ),
),

                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}