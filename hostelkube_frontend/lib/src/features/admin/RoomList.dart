import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowRoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Existing Rooms'),
      ),
      body: RoomList(),
    );
  }
}

class RoomList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final rooms = snapshot.data?.docs; // Add null check here
        if (rooms == null || rooms.isEmpty) {
          return Text('No rooms available.');
        }
        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text('Room Number: ${room['roomNumber']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Capacity: ${room['capacity']}'),
                  Text('Filled Beds: ${room['filledBeds']}'), // Display filledBeds
                  Text('Price per Bed: \₹${room['pricePerBed']}'),
                  // You can add more room details to be displayed here
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              // You can add onTap logic to navigate to a detailed room view
            );
          },
        );
      },
    );
  }
}

