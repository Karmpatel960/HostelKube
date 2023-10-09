import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; 

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String roomName = '';
  int capacity = 0;
  double pricing = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                roomName = value;
              },
              decoration: InputDecoration(labelText: 'Room Name'),
            ),
            TextField(
              onChanged: (value) {
                capacity = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Capacity'),
            ),
            TextField(
              onChanged: (value) {
                pricing = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Pricing'),
            ),
            ElevatedButton(
              onPressed: () {
                // Add room data to Firebase Realtime Database
                addRoomData(roomName, capacity, pricing);
              },
              child: Text('Add Room'),
            ),
          ],
        ),
      ),
    );
  }

Future<void> addRoomData(String roomName, int capacity, double pricing) async {
  final DatabaseReference roomsRef = FirebaseDatabase.instance.reference().child('rooms');
  
  try {
    final newRoomRef = roomsRef.push(); // Create a new reference for the room
    await newRoomRef.set({
      'name': roomName,
      'capacity': capacity,
      'pricing': pricing,
    });

    // Clear text fields after successful save
    setState(() {
      roomName = '';
      capacity = 0;
      pricing = 0.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Room added successfully'),
      ),
    );
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
      ),
    );
  }
}

}
