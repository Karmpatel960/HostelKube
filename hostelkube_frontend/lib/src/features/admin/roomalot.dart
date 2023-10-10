import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final room = availableRooms[selectedRoomIndex!];
      final roomName = room['name'];
      final roomCapacity = room['capacity'];
      final roomPricing = room['pricing'];

      // Store booking data in Cloud Firestore
      await FirebaseFirestore.instance.collection('bookings').add({
        'roomName': roomName,
        'roomCapacity': roomCapacity,
        'roomPricing': roomPricing,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SuccessfulBookingPage()),
      );
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
