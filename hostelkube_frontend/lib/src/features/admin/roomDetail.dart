import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomDetailsPage extends StatelessWidget {
  final Map<String, dynamic> roomData;

  RoomDetailsPage({required this.roomData});

  @override
  Widget build(BuildContext context) {
    final List<String> userIDs = roomData['users']?.cast<String>() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Room Details'),
      ),
      body: Column(
        children: [
          Card(
            child: Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey, // You can change the border color to your preference
        width: 1.0, // You can adjust the border width as needed
      ),
    ),
            child: ListTile(
              title: Text('Room Number: ${roomData['roomNumber']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Capacity: ${roomData['capacity']}'),
                  Text('Description: ${roomData['description']}'),
                  Text('Price per Bed: ₹${roomData['pricePerBed']}'),
                ],
              ),
            ),
          ),
          ),
          SizedBox(height: 20),
          Text(
            'Users in this Room:',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchUsersDetails(userIDs),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final users = snapshot.data;

                if (users == null || users.isEmpty) {
                  return Center(child: Text('No users in this room.'));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final userData = users[index];
                    return Card(
                      child: ListTile(
                        title: Text('User Name: ${userData['name']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${userData['email']}'),
                            Text('Mobile: ${userData['mobile']}'),
                            Text('Address: ${userData['address']}'),
                            Text('Emergency Contact: ${userData['emergencyContact']}'),
                            // You can add more user details to be displayed here
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchUsersDetails(List<String> userIDs) async {
    final List<Future<DocumentSnapshot>> userFutures = userIDs.map((userID) {
      return FirebaseFirestore.instance.collection('users').doc(userID).get();
    }).toList();

    final List<DocumentSnapshot> userSnapshots = await Future.wait(userFutures);

    final List<Map<String, dynamic>> users = userSnapshots.map((snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    }).toList();

    return users;
  }
}

