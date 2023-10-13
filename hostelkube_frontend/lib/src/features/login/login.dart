import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hostelkube_frontend/src/features/Signup/signup.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import '/src/router/router.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.1, 0.4, 0.6, 0.9],
            colors: [
              Color(0xff9f56fc),
              Color(0xffff26a7),
              Color(0xffff9a7a),
              Color(0xffe2d66e),
            ],
          ),
        ),
        child: Column(
          children: [
            // Image Carousel at the top
            ImageCarousel(),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  // Your main content here
                ),
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to HostelKube",
                      style: GoogleFonts.sora(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                             MaterialPageRoute(
                                    // builder: (context) => SignInScreen(), // Replace with your LoginScreen widget
                                    builder: (context) => AdminHomePage(),
                                                        ),
                                    );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "Sign In",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignUpPage(), // Replace with your LoginScreen widget
      ),
    );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280, // Set a fixed height for the carousel
      child: CarouselSlider(
        items: [
          _buildRoundedImage('assets/Rectangle5.png'),
          _buildRoundedImage('assets/pexels-pixabay-50987.jpg'),
          _buildRoundedImage('assets/pexels-spencer-davis-4393021.jpg'),
        ],
        options: CarouselOptions(
          viewportFraction: 1.0, // Make each item take the full width
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          autoPlay: true,
        ),
      ),
    );
  }

  Widget _buildRoundedImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}


