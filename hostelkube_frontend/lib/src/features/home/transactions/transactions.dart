import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:open_file/open_file.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final DatabaseReference transactionsRef =
      FirebaseDatabase.instance.reference().child('transactions');
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    try {
      final DataSnapshot snapshot = await transactionsRef.once() as DataSnapshot;
      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          transactions.clear();
          values.forEach((key, value) {
            if (value is Map<String, dynamic>) {
              transactions.add(value);
            }
          });
        });
      }
    } catch (error) {
      // Handle the error
    }
  }

  Future<void> generateAndSaveReceipt(Map<String, dynamic> transaction) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text('Receipt for Transaction', style: pw.TextStyle(fontSize: 20)),
                pw.Text('Date: ${transaction['date']}'),
                pw.Text('Amount: ${transaction['amount']}'),
                pw.Text('Description: ${transaction['description']}'),
              ],
            ),
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/receipt.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  void printReceipt(Map<String, dynamic> transaction) {
    generateAndSaveReceipt(transaction);
    // Optionally, you can display a confirmation message to the user here.
  }

  void downloadReceipt() async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/receipt.pdf');
    if (file.existsSync()) {
      // Open the PDF using the default PDF viewer on the device.
      await OpenFile.open(file.path);
    } else {
      // Handle the case where the PDF file does not exist.
      // You can show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: transactions.isEmpty
          ? Center(
              child: Text('No transactions found.'),
            )
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                final transactionDate = transaction['date'];
                final transactionAmount = transaction['amount'];
                final transactionDescription = transaction['description'];

                return ListTile(
                  title: Text('Date: $transactionDate'),
                  subtitle: Text('Amount: $transactionAmount | Description: $transactionDescription'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.print),
                        onPressed: () {
                          printReceipt(transaction);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          downloadReceipt();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
