// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import './forgotpassword.dart';
// import '../Signup/signup.dart';
// import 'package:hostelkube_frontend/src/features/home/home.dart';


// class OTPVerificationScreen extends StatefulWidget {
//   final String phoneNumber; // Change to phoneNumber
//   final String verificationId; // Add this line

//   OTPVerificationScreen({required this.phoneNumber, required this.verificationId}); // Modify constructor

//   @override
//   _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
// }

// class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
//   List<TextEditingController> otpControllers =
//       List.generate(6, (index) => TextEditingController());
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   void _verifyOTP() async {
//     try {
//       String otp = otpControllers.map((controller) => controller.text).join();
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: widget.phoneNumber, // Change to phoneNumber
//         smsCode: otp,
//       );

//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         // User successfully verified, navigate to the next screen
//         // Replace this with your desired navigation logic
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => HomeScreen(),
//           ),
//         );
//       } else {
//         _showSnackBar('OTP verification failed');
//       }
//     } catch (error) {
//       print(error);
//       _showSnackBar('Error occurred during OTP verification');
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text('Enter the OTP sent to your mobile number'), // Change text here
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 6,
//                 (index) => SizedBox(
//                   width: 40.0,
//                   child: TextField(
//                     controller: otpControllers[index],
//                     textAlign: TextAlign.center,
//                     keyboardType: TextInputType.number,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: _verifyOTP,
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

