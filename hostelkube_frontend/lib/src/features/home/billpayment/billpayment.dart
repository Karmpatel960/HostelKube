import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostelkube_frontend/src/models/room.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MonthlyBillGenerationPage extends StatefulWidget {
  final List<RoomData> allocatedRooms;

  MonthlyBillGenerationPage({required this.allocatedRooms});

  @override
  _MonthlyBillGenerationPageState createState() => _MonthlyBillGenerationPageState();
}

class _MonthlyBillGenerationPageState extends State<MonthlyBillGenerationPage> {
  TextEditingController unitController = TextEditingController();
  TextEditingController unitRateController = TextEditingController(); // Add this line
  double unitRate = 11; // Default rate per unit

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly Bill Generation'),
      ),
      body: ListView.builder(
        itemCount: widget.allocatedRooms.length,
        itemBuilder: (context, index) {
          final room = widget.allocatedRooms[index];

          return ListTile(
            title: Text('Room: ${room.roomNumber}'),
            subtitle: Text('Capacity: ${room.capacity}'),
            trailing: ElevatedButton(
              onPressed: () async {
                final currentMonth = DateTime.now();
                final isBillGenerated = await isMonthlyBillGenerated(room.roomId, currentMonth);

                if (!isBillGenerated) {
                  await showBillGenerationDialog(context, room);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Monthly bill already generated for room ${room.roomNumber}')),
                  );
                }
              },
              child: Text('Add Monthly Bill'),
            ),
          );
        },
      ),
    );
  }

Future<void> showBillGenerationDialog(BuildContext context, RoomData room) async {
  unitController.clear();
  unitRateController.text = unitRate.toString();

  // Create a variable to store the content of the dialog
  Widget dialogContent = Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Enter the units for ${room.roomNumber}:'),
      TextField(
        controller: unitController,
        keyboardType: TextInputType.number,
      ),
      Text('Rate per unit: \₹'),
      TextField(
        controller: unitRateController,
        keyboardType: TextInputType.number,
        onChanged: (value) {
          // Update the unitRate when the user inputs a new value
          final newRate = double.tryParse(value) ?? 0;
          setState(() {
            unitRate = newRate;
          });
        },
      ),
    ],
  );

  // Show the "Generate Bill" dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Generate Monthly Bill'),
        content: dialogContent,
        actions: [
          ElevatedButton(
            onPressed: () {
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

              // Close the "Generate Bill" dialog
              Navigator.of(context).pop();

              // Show a toast message with the total amount
              Fluttertoast.showToast(
                msg: 'Total Amount: \₹$totalAmount',
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3, // Duration for which the toast message will be visible
              );
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}




Future<bool> isMonthlyBillGenerated(String roomId, DateTime month) async {
  try {
    final DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
    final DateTime lastDayOfMonth = DateTime(month.year, month.month + 1, 0);

    final Timestamp firstTimestamp = Timestamp.fromDate(firstDayOfMonth);
    final Timestamp lastTimestamp = Timestamp.fromDate(lastDayOfMonth);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('bills')
        .where('roomId', isEqualTo: roomId)
        // .where('month', isGreaterThanOrEqualTo: firstTimestamp)
        // .where('month', isLessThanOrEqualTo: lastTimestamp)
        .get();

    // Check if there's already a bill for the same room and month
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    print('Error in isMonthlyBillGenerated: $error');
    return false;
  }
}



void saveMonthlyBillToFirestore(MonthlyBillData bill) async {
  // Save the monthly bill data to the "bills" collection in Firestore
  final billRef = await FirebaseFirestore.instance.collection('bills').add({
    'roomId': bill.roomId,
    'totalAmount': bill.totalAmount,
    'month': bill.month,
    'userIds': bill.userIds,
  });

  final billId = billRef.id;

  // Update the bill document with the bill ID
  await FirebaseFirestore.instance.collection('bills').doc(billRef.id).update({'billId': billId});
}

}
