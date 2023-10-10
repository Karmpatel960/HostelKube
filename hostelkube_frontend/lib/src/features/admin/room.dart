import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
            SizedBox(height: 20,),
            TextField(
              onChanged: (value) {
                capacity = int.tryParse(value) ?? 0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Capacity'),
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (value) {
                pricing = double.tryParse(value) ?? 0.0;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Pricing'),
            ),
            SizedBox(height: 20,),
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  
  try {
    final newRoomRef = roomsRef.push(); // Create a new reference for the room
    final roomData = {
      'name': roomName,
      'capacity': capacity,
      'pricing': pricing,
    };
    await newRoomRef.set(roomData);

    // Store room data in Cloud Firestore
    if (user != null) {
      final CollectionReference userRoomsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('rooms');
      
      final roomDocRef = await userRoomsCollection.add(roomData);
      print('Room data added to Cloud Firestore with document ID: ${roomDocRef.id}');
    }

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
