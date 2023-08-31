import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/src/router/router.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate some time-taking initialization process.
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, Routes.loginRoute); 
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromRGBO(26, 12, 39, 1),
    body: Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "HostelKube",
                style: TextStyle(fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),  // Adjust the spacing as needed
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 52, 255, 252))),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,  // Adjust the bottom spacing as needed
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

