import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  final String email;

  OTPVerificationPage({required this.email});

  @override
  _OTPVerificationPageState createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false; // Added to show loading indicator

  Future<void> verifyOTP() async {
    final String enteredOTP = otpController.text;
    final String apiUrl = 'http://localhost:3000/user/sendotp'; // Replace with your API URL

    final Map<String, dynamic> requestBody = {
      'email': widget.email,
      'otp': enteredOTP,
    };

    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // OTP verification successful, navigate to the success page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(),
          ),
        );
      } else {
        // Handle errors here
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid OTP. Please try again.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      // Handle network or other errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $error',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter the OTP sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  fontSize: 24,
                ),
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : verifyOTP, // Disable button during loading
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).colorScheme.primary,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Verify OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Success Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            SizedBox(height: 30),
            Text(
              'OTP Verified Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:hostelkube_frontend/src/features/features.dart';

// class OTPVerificationPage extends StatefulWidget {
//   final String email; // Add a parameter to accept the email

//   OTPVerificationPage({required this.email});

//   @override
//   _OTPVerificationPageState createState() => _OTPVerificationPageState();
// }

// class _OTPVerificationPageState extends State<OTPVerificationPage> {
//   final TextEditingController otpController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 // 'Enter the OTP sent to ${widget.email}',
//                 'Enter the OTP sent to', // Display the email
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//               ),
//               SizedBox(height: 30),
//               TextFormField(
//                 controller: otpController,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(
//                   fontSize: 24,
//                 ),
//                 decoration: InputDecoration(
//                   labelText: 'OTP',
//                   hintText: 'Enter OTP',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(
//                     Icons.lock,
//                     color: Theme.of(context).colorScheme.primary,
//                   ),
//                   contentPadding: EdgeInsets.all(16),
//                 ),
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: () {
//                   // Add OTP verification logic here
//                   String enteredOTP = otpController.text;
//                   // Validate the OTP and navigate to the next screen
//                   if (enteredOTP == '1234') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SuccessPage(),
//                       ),
//                     );
//                   } else {
//                     // Show an error message for an incorrect OTP
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Incorrect OTP. Please try again.',
//                           style: TextStyle(
//                             fontSize: 18,
//                           ),
//                         ),
//                         backgroundColor: Theme.of(context).colorScheme.error,
//                       ),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   primary: Theme.of(context).colorScheme.primary,
//                   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text(
//                   'Verify OTP',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class SuccessPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Success Page'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.check_circle,
//               size: 100,
//               color: Colors.green,
//             ),
//             SizedBox(height: 30),
//             Text(
//               'OTP Verified Successfully!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
