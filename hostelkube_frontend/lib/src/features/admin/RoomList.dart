// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import './roomDetail.dart';

// class ShowRoomsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Show Existing Rooms'),
//       ),
//       body: RoomList(),
//     );
//   }
// }

// class RoomList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         final rooms = snapshot.data?.docs; // Add null check here
//         if (rooms == null || rooms.isEmpty) {
//           return Text('No rooms available.');
//         }

//         return ListView.builder(
//           itemCount: rooms.length,
//           itemBuilder: (context, index) {
//             final room = rooms[index].data() as Map<String, dynamic>;
//             final filledBeds = room['filledBeds'];
//             final capacity = room['capacity'];

//             // Determine the room's occupancy state
//             String occupancyState;
//             Color backgroundColor;

//             if (filledBeds == 0) {
//               occupancyState = 'Empty';
//               backgroundColor = Colors.green; // Set a color for empty rooms
//             } else if (filledBeds < capacity) {
//               occupancyState = 'Half-Filled';
//               backgroundColor = Colors.yellow; // Set a color for half-filled rooms
//             } else {
//               occupancyState = 'Fully-Filled';
//               backgroundColor = Colors.red; // Set a color for fully-filled rooms
//             }

//             return Card(
//               color: backgroundColor,
//               child: ListTile(
//                 title: Text('Room Number: ${room['roomNumber']}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Occupancy: $occupancyState'),
//                     Text('Capacity: $capacity'),
//                     Text('Filled Beds: $filledBeds'),
//                     Text('Price per Bed: \₹${room['pricePerBed']}'),
//                     // You can add more room details to be displayed here
//                   ],
//                 ),
//                 onTap: () {
//                   // When the user taps on a room, navigate to RoomDetailsPage
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => RoomDetailsPage(roomData: room),
//                     ),
//                   );
//                 },
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './roomDetail.dart';

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

class RoomList extends StatefulWidget {
  @override
  _RoomListState createState() => _RoomListState();
}

class _RoomListState extends State<RoomList> {
  String filter = "All";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FilterButton("All", setFilter),
            FilterButton("Empty", setFilter),
            FilterButton("Half-Filled", setFilter),
            FilterButton("Fully-Filled", setFilter),
          ],
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final rooms = snapshot.data?.docs;

            if (rooms == null || rooms.isEmpty) {
              return Text('No rooms available.');
            }
            return Expanded(


            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index].data() as Map<String, dynamic>;
                final filledBeds = room['filledBeds'];
                final capacity = room['capacity'];

                String occupancyState;
                Color backgroundColor;

                if (filledBeds == 0) {
                  occupancyState = 'Empty';
                  backgroundColor = Colors.green;
                } else if (filledBeds < capacity) {
                  occupancyState = 'Half-Filled';
                  backgroundColor = Colors.yellow;
                } else {
                  occupancyState = 'Fully-Filled';
                  backgroundColor = Colors.red;
                }

                if (filter == "All" || filter == occupancyState) {
                  return Card(
                    color: backgroundColor,
                    child: ListTile(
                      title: Text('Room Number: ${room['roomNumber']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Occupancy: $occupancyState'),
                          Text('Capacity: $capacity'),
                          Text('Filled Beds: $filledBeds'),
                          Text('Price per Bed: \₹${room['pricePerBed']}'),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RoomDetailsPage(roomData: room),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
            );
          },
        ),
      ],
    );
  }

  void setFilter(String value) {
    setState(() {
      filter = value;
    });
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final Function(String) onPressed;

  FilterButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed(label);
      },
      child: Text(label),
    );
  }
}
