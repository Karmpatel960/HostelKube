// import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RoomAllocationApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Room Allocation App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: AdminRoomPage(),
//     );
//   }
// }

// class AdminRoomPage extends StatefulWidget {
//   @override
//   _AdminRoomPageState createState() => _AdminRoomPageState();
// }

// class _AdminRoomPageState extends State<AdminRoomPage> {
//   final DatabaseReference _roomsRef =
//       FirebaseDatabase.instance.reference().child('rooms');
//   final DatabaseReference _bookingsRef =
//       FirebaseDatabase.instance.reference().child('bookings');

//   String selectedRoom = '';
//   DateTime? checkInDate;
//   DateTime? checkOutDate;
//   String userId = 'user123'; // Replace with the actual user ID

//   void showSnackbar(String message, {bool success = false}) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: success ? Colors.green : Colors.red,
//       ),
//     );
//   }

//   Future<void> addRoomData(
//     String roomName,
//     int capacity,
//     double pricing,
//     Function(bool) callback,
//   ) async {
//     try {
//       final newRoomRef = _roomsRef.push();
//       await newRoomRef.set({
//         'name': roomName,
//         'capacity': capacity,
//         'pricing': pricing,
//         'available': true,
//       });
//       callback(true); // Room added successfully
//     } catch (error) {
//       print('Error adding room: $error');
//       callback(false); // Room addition failed
//     }
//   }

//   Future<String> fetchUserName(String userId) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       final userDoc = await firestore.collection('users').doc(userId).get();

//       if (userDoc.exists) {
//         final data = userDoc.data() as Map<String, dynamic>;
//         final name = data['name'] as String;

//         return name;
//       } else {
//         return ''; // Return a default value if the user document doesn't exist
//       }
//     } catch (error) {
//       print('Error fetching user name: $error');
//       return ''; // Handle the error and return a default value
//     }
//   }

//   void allocateRoom() {
//     if (selectedRoom.isNotEmpty &&
//         checkInDate != null &&
//         checkOutDate != null) {
//       final roomName = selectedRoom;
//       final checkInDateString = checkInDate!.toIso8601String();
//       final checkOutDateString = checkOutDate!.toIso8601String();

//       // Call addRoomData with a callback
//       addRoomData(roomName, 0, 0.0, (bool roomAddedSuccessfully) {
//         if (roomAddedSuccessfully) {
//           // Fetch the user's name
//           fetchUserName(userId).then((userName) {
//             // Add room allocation
//             _bookingsRef.push().set({
//               'roomId': roomName,
//               'checkInDate': checkInDateString,
//               'checkOutDate': checkOutDateString,
//               'userName': userName, // Add the user's name
//             });

//             // Update room availability
//             _roomsRef.child(roomName).update({'available': false});

//             showSnackbar('Room allocated successfully', success: true);

//             // Clear form fields
//             setState(() {
//               selectedRoom = '';
//               checkInDate = null;
//               checkOutDate = null;
//             });
//           }).catchError((error) {
//             showSnackbar('Failed to fetch user name');
//           });
//         } else {
//           showSnackbar('Failed to add room data');
//         }
//       });
//     } else {
//       showSnackbar('Please fill in all fields');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Admin Page'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Room Allocation',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Column(
//               children: [
//                 DropdownButtonFormField<String>(
//                   value: selectedRoom,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedRoom = newValue!;
//                     });
//                   },
//                   items: ['Room 101', 'Room 102', 'Room 103']
//                       .map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   decoration: InputDecoration(labelText: 'Select Room'),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   onTap: () async {
//                     final selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2101),
//                     );
//                     if (selectedDate != null) {
//                       setState(() {
//                         checkInDate = selectedDate;
//                       });
//                     }
//                   },
//                   controller: TextEditingController(
//                     text: checkInDate != null ? checkInDate!.toString() : '',
//                   ),
//                   decoration: InputDecoration(labelText: 'Check-In Date'),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   onTap: () async {
//                     final selectedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2101),
//                     );
//                     if (selectedDate != null) {
//                       setState(() {
//                         checkOutDate = selectedDate;
//                       });
//                     }
//                   },
//                   controller: TextEditingController(
//                     text: checkOutDate != null ? checkOutDate!.toString() : '',
//                   ),
//                   decoration: InputDecoration(labelText: 'Check-Out Date'),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: allocateRoom,
//                   child: Text('Allocate Room'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 32),
//             Text(
//               'Room Availability',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             StreamBuilder(
//               stream: _roomsRef.onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   final roomData = snapshot.data!.snapshot.value;
//                   if (roomData != null) {
//                     final rooms = (roomData as Map).values.toList();

//                     return ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: rooms.length,
//                       itemBuilder: (context, index) {
//                         final room = rooms[index];
//                         final roomName = room['name'] ?? '';
//                         final isAvailable = room['available'] ?? true;

//                         return ListTile(
//                           title: Text(roomName),
//                           subtitle: Text(isAvailable ? 'Available' : 'Occupied'),
//                         );
//                       },
//                     );
//                   }
//                 }
//                 return CircularProgressIndicator();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AvailableRoomsPage extends StatefulWidget {
  @override
  _AvailableRoomsPageState createState() => _AvailableRoomsPageState();
}

class _AvailableRoomsPageState extends State<AvailableRoomsPage> {
  late final DatabaseReference roomsRef;
  List<Map<String, dynamic>> availableRooms = [];

  late final Razorpay _razorpay;
  int? selectedRoomIndex;

  @override
  void initState() {
    super.initState();
    roomsRef = FirebaseDatabase.instance.reference().child('rooms');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchAvailableRooms();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

void fetchAvailableRooms() async {
  try {
    final DataSnapshot snapshot = await roomsRef.once() as DataSnapshot;
    if (snapshot.value != null) {
      Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        availableRooms.clear();
        values.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            availableRooms.add(value);
          }
        });
      });
    }
  } catch (error) {
    // Handle the error
  }
}


  void openPaymentGateway(double amount) {
    var options = {
      'key': 'rzp_test_wkBRMs93DQ7Iva',
      'amount': amount * 100, // Amount in paise
      'name': 'Room Booking',
      'description': 'Room booking payment',
      'prefill': {'contact': '', 'email': ''},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SuccessfulBookingPage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Payment: ${response.walletName}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Rooms'),
      ),
      body: ListView.builder(
        itemCount: availableRooms.length,
        itemBuilder: (context, index) {
          final room = availableRooms[index];
          final roomName = room['name'];
          final roomCapacity = room['capacity'];
          final roomPricing = room['pricing'];

          return ListTile(
            title: Text('Room: $roomName'),
            subtitle: Text('Capacity: $roomCapacity | Pricing: $roomPricing'),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedRoomIndex = index;
                });
                openPaymentGateway(roomPricing);
              },
              child: Text('Book'),
            ),
            selected: selectedRoomIndex == index,
          );
        },
      ),
    );
  }
}

class SuccessfulBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Booking Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}


