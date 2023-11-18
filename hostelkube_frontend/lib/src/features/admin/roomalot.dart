import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:razorpay_web/razorpay_web.dart';

class AvailableRoomsPage extends StatefulWidget {

  final String userId;
  final String userName;

  AvailableRoomsPage({
    required this.userId,
    required this.userName,
  });

  @override
  _AvailableRoomsPageState createState() => _AvailableRoomsPageState();
}

class _AvailableRoomsPageState extends State<AvailableRoomsPage> {
  List<Map<String, dynamic>> availableRooms = [];
    bool userAlreadyBought = false;
  late final Razorpay _razorpay;
  int? selectedRoomIndex;
   String filter = "All";

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    checkUserAlreadyBoughtRoom();
    fetchAvailableRooms();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void fetchAvailableRooms() async {
    try {
      final roomsSnapshot = await FirebaseFirestore.instance.collection('rooms').get();
      if (roomsSnapshot.docs.isNotEmpty) {
        final roomsData = roomsSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        setState(() {
          availableRooms = roomsData;
        });
      }
    } catch (error) {
      // Handle the error
    }
  }

   Future<void> checkUserAlreadyBoughtRoom() async {
    final roomsSnapshot = await FirebaseFirestore.instance.collection('rooms')
        .where('users', arrayContains: widget.userId) // Check if the user is in the 'users' array
        .get();

    if (roomsSnapshot.docs.isNotEmpty) {
      setState(() {
        userAlreadyBought = true;
      });
    }
  }

  void openPaymentGateway(Map<String, dynamic> room) {
    final roomPricing = room['pricePerBed'];
    var options = {
      'key': 'rzp_test_wkBRMs93DQ7Iva',
      'amount': roomPricing * 100, // Amount in paise
      'name': 'Room Booking',
      'description': 'Room booking payment for ${room['roomNumber']}',
      'prefill': {'contact': '', 'email': ''},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  try {
    final room = availableRooms[selectedRoomIndex!];

    if (widget.userId != null && widget.userName != null) {
      // Get the roomId of the selected room
      final roomId = room['roomId'];

      // Subtract 1 from vacant beds and add 1 to filled beds
      final roomRef = FirebaseFirestore.instance.collection('rooms').doc(roomId);
      final filledBeds = room['filledBeds'] + 1;

      roomRef.update({
        'filledBeds': filledBeds,
        'users': FieldValue.arrayUnion([widget.userId]),
      });

      final transactionId = response.paymentId;

      // Define the payment data
      final paymentData = {
        'roomId': room['roomId'],
        'roomPricing': room['pricePerBed'],
        'userId': widget.userId,
        'userName': widget.userName,
        'roomNumber': room['roomNumber'],
        'transactionId': transactionId,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Save payment data to Firestore
      await FirebaseFirestore.instance.collection('bookings').add(paymentData);

      // Navigate to the successful booking page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessfulBookingPage(transactionId: transactionId ?? 'defaultTransactionId'),
        ),
      );

      // Rest of your code...
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User not authenticated.'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $e'),
      ),
    );
  }
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
      body: userAlreadyBought
          ? Center(
              child: Text('You have already booked a room.'),
            )
          : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton("All", setFilter),
                    FilterButton("Empty", setFilter),
                    FilterButton("Half-Filled", setFilter),
                    FilterButton("Fully-Filled", setFilter),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableRooms.length,
                    itemBuilder: (context, index) {
                      final room = availableRooms[index];

                      String occupancyState;
                      Color backgroundColor;

                      final filledBeds = room['filledBeds'];
                      final capacity = room['capacity'];

                      if (filledBeds == 0) {
                        occupancyState = 'Empty';
                        backgroundColor = Colors.green;
                      } else if (filledBeds < capacity) {
                        occupancyState = 'Half-Filled';
                        backgroundColor = Colors.yellow;
                      } else {
                        occupancyState = 'Fully-Filled';
                        backgroundColor = Colors.red;
                      }

                      if (filter == "All" || filter == occupancyState) {
                        return ListTile(
                          title: Text('Room: ${room['roomNumber']}'),
                          subtitle: Text('Capacity: ${room['capacity']} | Price per Bed: \₹${room['pricePerBed']}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedRoomIndex = index;
                              });
                              openPaymentGateway(room);
                            },
                            child: Text('Book'),
                          ),
                          selected: selectedRoomIndex == index,
                          tileColor: backgroundColor,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
    );
  }

  void setFilter(String value) {
    setState(() {
      filter = value;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Available Rooms'),
  //     ),
  //     body: userAlreadyBought
  //         ? Center(
  //             child: Text('You have already booked a room.'),
  //           )
  //         : ListView.builder(
  //             itemCount: availableRooms.length,
  //             itemBuilder: (context, index) {
  //               final room = availableRooms[index];

  //               return ListTile(
  //                 title: Text('Room: ${room['roomNumber']}'),
  //                 subtitle: Text('Capacity: ${room['capacity']} | Price per Bed: \₹${room['pricePerBed']}'),
  //                 trailing: ElevatedButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       selectedRoomIndex = index;
  //                     });
  //                     openPaymentGateway(room);
  //                   },
  //                   child: Text('Book'),
  //                 ),
  //                 selected: selectedRoomIndex == index,
  //               );
  //             },
  //           ),
  //   );
  // }

}

  class FilterButton extends StatelessWidget {
  final String label;
  final Function(String) onPressed;

  FilterButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(label);
      },
      child: Text(label),
    );
  }
  }

class SuccessfulBookingPage extends StatelessWidget {
  final String transactionId;

  SuccessfulBookingPage({required this.transactionId});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 10), () {
      Navigator.of(context).pop();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Successful Booking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.done,  // Use the "done" icon from Icons class
              size: 100,  // Adjust the size as needed
              color: Colors.green,  // Set the color of the icon
            ),
            SizedBox(height: 20),  // Add some spacing
            Text('Booking ID: $transactionId'),
            // Add other content related to the successful booking
          ],
        ),
      ),
    );
  }
}




