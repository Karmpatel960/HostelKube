import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/models/room.dart';

class MonthlyBillGenerationPage extends StatefulWidget {
  final List<RoomData> allocatedRooms;

  MonthlyBillGenerationPage({required this.allocatedRooms});

  @override
  _MonthlyBillGenerationPageState createState() => _MonthlyBillGenerationPageState();
}

class _MonthlyBillGenerationPageState extends State<MonthlyBillGenerationPage> {
  TextEditingController unitController = TextEditingController();
  double unitRate = 11; // Default rate per unit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Bill Generation'),
      ),
      body: ListView.builder(
        itemCount: widget.allocatedRooms.length, // Access the allocatedRooms from the widget
        itemBuilder: (context, index) {
          final room = widget.allocatedRooms[index];

          return ListTile(
            title: Text('Room: ${room.roomNumber}'),
            subtitle: Text('Capacity: ${room.capacity}'),
            trailing: ElevatedButton(
              onPressed: () async {
                // Check if a bill is already generated for the current month
                final currentMonth = DateTime.now();
                final isBillGenerated = await isMonthlyBillGenerated(room.roomId, currentMonth);

                if (!isBillGenerated) {
                  // If the bill is not generated, show the bill generation dialog
                  await showBillGenerationDialog(context, room);
                } else {
                  // If the bill is already generated, show a message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Monthly bill already generated for room ${room.roomNumber}')),
                  );
                }
              },
              child: Text('Generate Monthly Bill'),
            ),
          );
        },
      ),
    );
  }

  Future<void> showBillGenerationDialog(BuildContext context, RoomData room) async {
    unitController.clear(); // Clear the previous input

    // Show a dialog to enter units and optionally change the rate
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate Monthly Bill'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter the units for ${room.roomNumber}:'),
              TextField(
                controller: unitController, // Connect the controller to the TextField
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // Calculate the total amount based on entered units and rate
                  final units = double.tryParse(value) ?? 0;
                  final totalAmount = units * unitRate;

                  // Display the calculated total amount
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Total Amount: \$$totalAmount'),
                    ),
                  );
                },
              ),
              Text('Rate per unit: \$11 (default)'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Generate and save the monthly bill
                final units = double.tryParse(unitController.text) ?? 0;
                final totalAmount = units * unitRate;

                final currentMonth = DateTime.now();

                final newBill = MonthlyBillData(
                  roomId: room.roomId,
                  totalAmount: totalAmount,
                  month: currentMonth,
                  userIds: [],
                );

                saveMonthlyBillToFirestore(newBill);

                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Generate Bill'),
            ),
          ],
        );
      },
    );
  }

    Future<bool> isMonthlyBillGenerated(String roomId, DateTime month) async {
    // Check if a bill is already generated for the specified room and month
    // You should implement your specific logic to check if a bill exists for the room and month.
    // For example, you can query the "bills" collection in Firestore.
    return false; // Replace with your logic.
  }

  void saveMonthlyBillToFirestore(MonthlyBillData bill) {
    // Save the monthly bill data to the "bills" collection in Firestore
    FirebaseFirestore.instance.collection('bills').add({
      'roomId': bill.roomId,
      'totalAmount': bill.totalAmount,
      'month': bill.month,
    });
  }

  // The rest of your code for isMonthlyBillGenerated and saveMonthlyBillToFirestore remains the same.
}
