import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableRoomsPage extends StatefulWidget {
  @override
  _AvailableRoomsPageState createState() => _AvailableRoomsPageState();
}

class _AvailableRoomsPageState extends State<AvailableRoomsPage> {
  List<Map<String, dynamic>> availableRooms = [];

  late final Razorpay _razorpay;
  int? selectedRoomIndex;

  @override
  void initState() {
    super.initState();
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

      // Store booking data in Cloud Firestore
      await FirebaseFirestore.instance.collection('bookings').add({
        'roomNumber': room['roomNumber'],
        'roomCapacity': room['capacity'],
        'roomPricing': room['pricePerBed'],
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



