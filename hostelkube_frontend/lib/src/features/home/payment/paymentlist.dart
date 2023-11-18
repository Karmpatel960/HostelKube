import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaidBillsPage extends StatefulWidget {
  final String userId;

  PaidBillsPage({required this.userId});

  @override
  _PaidBillsPageState createState() => _PaidBillsPageState();
}

class _PaidBillsPageState extends State<PaidBillsPage> {
  final CollectionReference billsRef = FirebaseFirestore.instance.collection('bills');
  final CollectionReference roomsRef = FirebaseFirestore.instance.collection('rooms');
  List<Map<String, dynamic>> paidBills = [];

  @override
  void initState() {
    super.initState();
    fetchPaidBills();
  }

  void fetchPaidBills() async {
    try {
      final QuerySnapshot snapshot = await billsRef.where('userIds', arrayContains: widget.userId).get();

      if (snapshot.docs.isNotEmpty) {
        final List<Map<String, dynamic>> billsData = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
        final List<Future<Map<String, dynamic>?>> roomDataPromises = [];

        for (final bill in billsData) {
          // Get the room details for each bill
          final roomId = bill['roomId'];
          final roomDataPromise = roomsRef.doc(roomId).get().then((roomSnapshot) {
            if (roomSnapshot.exists) {
              return roomSnapshot.data() as Map<String, dynamic>;
            } else {
              return null;
            }
          });
          roomDataPromises.add(roomDataPromise);
        }

        final roomDataList = await Future.wait(roomDataPromises);

        setState(() {
          paidBills.clear();
          for (int i = 0; i < billsData.length; i++) {
            final bill = billsData[i];
            final roomData = roomDataList[i];
            if (roomData != null) {
              final Map<String, dynamic> monthAndYear = extractMonthAndYear(bill['month']);
              final month = monthAndYear['month'];
              final year = monthAndYear['year'];
              final totalAmount = bill['totalAmount'];
              final roomNumber = roomData['roomNumber'];

              paidBills.add({
                'month': month,
                'year': year,
                'totalAmount': totalAmount,
                'roomNumber': roomNumber,
              });
            }
          }
        });
      }
    } catch (error) {
      // Handle the error
    }
  }

  // Function to extract the month and year from a Firestore Timestamp
  Map<String, dynamic> extractMonthAndYear(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return {
      'month': dateTime.month,
      'year': dateTime.year,
    };
  }

    Future<void> downloadReceipt(Map<String, dynamic> bill) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Receipt for Light Bill Payment of ${bill['month']},${bill['year']}', style: pw.TextStyle(fontSize: 20)),
                pw.Text('Room Number: ${bill['roomNumber']}'),
                pw.Text('Bill Amount: INR ${bill['totalAmount']} Rupees'),
                pw.Text('Bill Paid throw RazorPay'),
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
        title: Text('Paid Bills'),
      ),
      body: paidBills.isEmpty
          ? Center(
              child: Text('No paid bills found.'),
            )
          : ListView.builder(
              itemCount: paidBills.length,
              itemBuilder: (context, index) {
                final bill = paidBills[index];
                final month = bill['month'];
                final year = bill['year'];
                final totalAmount = bill['totalAmount'];
                final roomNumber = bill['roomNumber'];

                return ListTile(
                  title: Text('Month: $month Year: $year'),
                  subtitle: Text('Total Amount: $totalAmount | Room Number: $roomNumber'),
                  trailing: TextButton(
                    onPressed: () {
                      // Handle downloading the receipt for the selected bill
                      downloadReceipt(bill);
                    },
                    child: Text('Download Receipt'),
                  ),
                );
              },
            ),
    );
  }
}
