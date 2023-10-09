import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
                );
              },
            ),
    );
  }
}
