import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TransactionPage extends StatefulWidget {
  final String userId;

  TransactionPage({required this.userId});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final CollectionReference bookingsRef = FirebaseFirestore.instance.collection('bookings');
  List<Map<String, dynamic>> bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  void fetchBookings() async {
    try {
      final QuerySnapshot snapshot = await bookingsRef.where('userId', isEqualTo: widget.userId).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          bookings.clear();
          bookings = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        });
      }
    } catch (error) {
      // Handle the error
    }
  }

  Future<void> generateAndOpenReceipt(Map<String, dynamic> booking) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Receipt for Booking', style: pw.TextStyle(fontSize: 20)),
                pw.Text('Room Number: ${booking['roomNumber']}'),
                pw.Text('Room Pricing: INR ${booking['roomPricing']} Rupees'),
                pw.Text('User: ${booking['userName']}'),
                pw.Text('Time: ${booking['timestamp']}'),
                pw.Text('Transaction ID: ${booking['transactionId']}'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async {
        return pdf.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking History'),
      ),
      body: bookings.isEmpty
          ? Center(
              child: Text('No bookings found.'),
            )
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final roomNumber = booking['roomNumber'];
                final roomPricing = booking['roomPricing'];
                final user = booking['userName'];
                final transactionId = booking['transactionId'];

                return ListTile(
                  title: Text('Room Number: $roomNumber'),
                  subtitle: Text('Price: $roomPricing | User: $user'),
                  trailing: TextButton(
                    onPressed: () {
                      // Handle viewing or printing the receipt
                      generateAndOpenReceipt(booking);
                    },
                    child: Text('View Receipt'),
                  ),
                );
              },
            ),
    );
  }
}
