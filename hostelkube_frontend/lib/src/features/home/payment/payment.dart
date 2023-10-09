import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final Razorpay _razorpay = Razorpay();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, paymentSuccessCallback);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, paymentErrorCallback);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletCallback);
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  void _handlePayment() {
    int amount = int.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) {
      // Show an error message to the user
      return;
    }

    var options = {
      'key': 'YOUR_RAZORPAY_API_KEY',
      'amount': amount * 100, // Amount in paisa (multiply by 100)
      'name': 'Your App Name',
      'description': 'Payment for Room Booking',
      'prefill': {
        'contact': 'user@example.com',
        'email': 'user@example.com',
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error during payment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the amount:'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (in INR)',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _handlePayment,
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

void paymentSuccessCallback(PaymentSuccessResponse response) {
  // Handle successful payment here
}

void paymentErrorCallback(PaymentFailureResponse response) {
  // Handle payment failure here
}

void externalWalletCallback(ExternalWalletResponse response) {
  // Handle external wallet selection here
}
