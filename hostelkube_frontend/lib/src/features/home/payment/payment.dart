import 'package:flutter/material.dart';
import 'package:razorpay_web/razorpay_web.dart';
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
  List<Map<String, dynamic>> monthlyBills = [];
  late final Razorpay _razorpay;
  int? selectedBillIndex;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    fetchUserRoomId(widget.userId);
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

        // Fetch the user's room document data
        final userRoomData = roomsSnapshot.docs.first.data() as Map<String, dynamic>;
        final filledBeds = userRoomData['filledBeds'] as int;
        final roomNumber = userRoomData['roomNumber'] as String;

             print('Filled Beds in User\'s Room: $filledBeds');
      print('Room Number: $roomNumber');

        // You can proceed to fetch the light bills for that room
        fetchLightBills(userRoomId, userId, filledBeds, roomNumber);
      } else {
        print('User is not registered in any room.');
      }
    } catch (error) {
      // Handle the error
    }
  }

  void fetchLightBills(String userRoomId, String userId, int filledBeds, String roomNumber) async {
  try {
    final lightBillsSnapshot = await FirebaseFirestore.instance.collection('bills')
        .where('roomId', isEqualTo: userRoomId)
        .get();

    if (lightBillsSnapshot.docs.isNotEmpty) {
      final lightBillsData = lightBillsSnapshot.docs.map((doc) {
        final billData = doc.data() as Map<String, dynamic>;

        final totalAmount = billData['totalAmount'] as double;
        final dynamic userIds = billData['userIds'];

        // Handle the case when userIds is not a List<String> but a List<dynamic>
        List<String> castedUserIds = (userIds as List<dynamic>).map((id) => id.toString()).toList();

        if (!castedUserIds.contains(userId)) {
          final share = totalAmount / filledBeds;
          return {
            ...billData,
            'share': share,
            'userPaid': false,
            'roomNumber': roomNumber,
          };
        }
        return null;
      }).whereType<Map<String, dynamic>>().toList();

      if (lightBillsData.isNotEmpty) {
        print('Light bills fetched successfully: $lightBillsData');

        setState(() {
          monthlyBills = lightBillsData;
        });
      } else {
        print('No unpaid light bills found for the user in room $userRoomId.');
      }
    } else {
      print('No light bills found for the user in room $userRoomId.');
    }
  } catch (error) {
    print('Error fetching light bills: $error');
    // Handle the error
  }
}



  void openPaymentGateway(Map<String, dynamic> bill, String userId) {
    final billAmount = bill['share'];
    var options = {
      'key': 'rzp_test_wkBRMs93DQ7Iva',
      'amount': (billAmount * 100).toInt(), // Amount in paise
      'name': 'Light Bill Payment',
      'description': 'Payment for Room ${bill['roomNumber']} Light Bill',
      'prefill': {'contact': '', 'email': ''},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }


void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  final userId = widget.userId;
  final razorpayId = response.paymentId; // Assuming the response contains the payment ID

  // Get the bill data for the selected bill
  final selectedBill = monthlyBills[selectedBillIndex ?? 0];

  final billId = selectedBill['billId']; // Retrieve the billId

  if (billId.isNotEmpty) {
    final billRef = FirebaseFirestore.instance.collection('bills').doc(billId);
    final billSnapshot = await billRef.get();

    if (billSnapshot.exists) {
      // Document exists, proceed with the update
      await billRef.update({
        'userIds': FieldValue.arrayUnion([userId]),
        'razorpayIds': FieldValue.arrayUnion([razorpayId]),
      });
    } else {
      // Handle the case when the document does not exist
      print('Document with ID $billId does not exist.');
    }
  } else {
    // Handle the case when no matching billId is found
    print('No billId found in the selectedBill.');
  }
}




  void _handlePaymentError(PaymentFailureResponse response) {
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
      body: monthlyBills.isEmpty
          ? Center(
              child: Text('No bill pending'),
            )
          : ListView.builder(
              itemCount: monthlyBills.length,
              itemBuilder: (context, index) {
                final bill = monthlyBills[index];

                return ListTile(
                  title: Text('Room: ${bill['roomNumber']}'),
                  subtitle: Text('Amount: ₹${bill['share'].toStringAsFixed(2)}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedBillIndex = index;
                      });
                      openPaymentGateway(bill, widget.userId);
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
