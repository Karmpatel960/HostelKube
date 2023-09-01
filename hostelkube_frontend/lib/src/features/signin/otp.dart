// import 'package:flutter/material.dart';

// class Otp extends StatelessWidget {
//   final ColorScheme colorScheme = ColorScheme(
//   primary: Colors.blue,
//   secondary: Colors.orange,
//   surface: Colors.white,
//   background: Colors.white,
//   error: Colors.red,
//   onPrimary: Colors.white,
//   onSecondary: Colors.black,
//   onSurface: Colors.black,
//   onBackground: Colors.black,
//   brightness: Brightness.light,
// );


//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'OTP Page',
//       home: OtpPage(),
//       theme: ThemeData(
//         colorScheme: colorScheme,
//       ),
//     );
//   }
// }

// class OtpPage extends StatefulWidget {
//   @override
//   _OtpPageState createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
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
//                 'Enter the OTP sent to your Email ID',
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
