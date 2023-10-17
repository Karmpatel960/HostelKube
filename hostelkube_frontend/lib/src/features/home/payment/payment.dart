import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LightBillPaymentPage extends StatefulWidget {
  final String userId;
  final String userName;

  LightBillPaymentPage({
    required this.userId,
    required this.userName,
  });

  @override
  _LightBillPaymentPageState createState() => _LightBillPaymentPageState();
}

class _LightBillPaymentPageState extends State<LightBillPaymentPage> {
  List<Map<String, dynamic>> lightBills = [];
  late final Razorpay _razorpay;
  int? selectedBillIndex;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchUserRoomId(widget.userId,);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

void fetchUserRoomId(String userId) async {
  try {
    // Query the rooms collection to find the user's room
    final roomsSnapshot = await FirebaseFirestore.instance.collection('rooms')
        .where('users', arrayContains: userId) // Check if the user is in the 'users' array
        .get();

    if (roomsSnapshot.docs.isNotEmpty) {
      // Get the room ID from the first room where the user is found
      final userRoomId = roomsSnapshot.docs.first.id;
      
      // Now you have the user's room ID
      print('User Room ID: $userRoomId');

      // You can proceed to fetch the light bills for that room
      fetchLightBills(userRoomId,userId);
    } else {
      print('User is not registered in any room.');
    }
  } catch (error) {
    // Handle the error
  }
}

void fetchLightBills(String userRoomId, String userId) async {
  try {
    final lightBillsSnapshot = await FirebaseFirestore.instance.collection('Bills')
        .where('roomId', isEqualTo: userRoomId) // Filter bills by the user's room
        .get();

    if (lightBillsSnapshot.docs.isNotEmpty) {
      final lightBillsData = lightBillsSnapshot.docs.map((doc) {
        final billData = doc.data() as Map<String, dynamic>;
        final totalAmount = billData['amount'] as double;
        final occupiedCapacity = billData['capacity'] as int; - billData['filledBeds'] as int;
        final userIds = billData['userIds'] as List<String>;
        
        // Calculate the share of the bill for each user
        final share = totalAmount / occupiedCapacity;

        // Check if the current user has paid their share
        final userPaid = userIds.contains(userId);

        // Update the bill data with share and userPaid fields
        return {
          ...billData,
          'share': share,
          'userPaid': userPaid,
        };
      }).toList();

      setState(() {
        lightBills = lightBillsData;
      });
    }
  } catch (error) {
    // Handle the error
  }
}


void openPaymentGateway(Map<String, dynamic> bill, String userId) {
  final billAmount = bill['share']; // Use the calculated share instead of the total amount
  var options = {
    'key': 'rzp_test_wkBRMs93DQ7Iva',
    'amount': (billAmount * 100).toInt(), // Amount in paise
    'name': 'Light Bill Payment',
    'description': 'Payment for Room ${bill['roomNumber']} Light Bill Share',
    'prefill': {'contact': '', 'email': ''},
  };
  try {
    _razorpay.open(options);
  } catch (e) {
    debugPrint(e.toString());
  }
}

void _handlePaymentSuccess(PaymentSuccessResponse response, Map<String, dynamic> bill, String userId) async {
  // Handle a successful payment
  // Update the payment status in Firestore and perform any other necessary actions.
  final userRoomId = bill['roomId'];
  final billId = bill['billId'];
  
  // Add the user to the list of users who have paid this bill
  final billRef = FirebaseFirestore.instance.collection('Bills').doc(billId);
  await billRef.update({
    'userIds': FieldValue.arrayUnion([userId]),
  });

  // You can check whether all users in the room have paid the bill here
  // and update the status accordingly.
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
        title: Text('Light Bill Payments'),
      ),
      body: ListView.builder(
        itemCount: lightBills.length,
        itemBuilder: (context, index) {
          final bill = lightBills[index];

          return ListTile(
            title: Text('Room: ${bill['roomNumber']}'),
            subtitle: Text('Amount: \₹${bill['amount']}'),
            trailing: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedBillIndex = index;
                });
                openPaymentGateway(bill,widget.userId);
              },
              child: Text('Pay'),
            ),
            selected: selectedBillIndex == index,
          );
        },
      ),
    );
  }
}
