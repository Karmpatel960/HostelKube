import 'package:flutter/material.dart';
import './adminep.dart';
import './room.dart';
import 'RoomList.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import 'package:hostelkube_frontend/src/models/room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatefulWidget {
  final String userId; // User ID passed to this screen

  AdminHomePage({required this.userId});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _currentIndex = 0;




  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
  AHomeScreen(userId: widget.userId), // Use AHomeScreen as the initial screen
  DashboardScreen(), // Dashboard screen
  AProfileScreen(), // Profile screen
];
    return Scaffold(
      body: _children[_currentIndex], // Use the selected screen from _children list
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Update the selected screen index
          });
        },
      ),
    );
  }
}

class AHomeScreen extends StatefulWidget {
  final String userId;

  AHomeScreen({required this.userId});

  @override
  _AHomeScreenState createState() => _AHomeScreenState();
}

class _AHomeScreenState extends State<AHomeScreen> {
  List<RoomData> allocatedRooms = [];

  @override
  void initState() {
    super.initState();
    // Fetch the allocated rooms when the widget initializes
    fetchAllocatedRooms().then((rooms) {
      setState(() {
        allocatedRooms = rooms;
      });
    });
  }

  Future<List<RoomData>> fetchAllocatedRooms() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .where('users', arrayContains: widget.userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final allocatedRooms = querySnapshot.docs
            .map((doc) => RoomData.fromSnapshot(doc))
            .toList();
        return allocatedRooms;
      } else {
        return [];
      }
    } catch (error) {
      // Handle the error (e.g., logging, showing an error message)
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications or alerts
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          buildClickableBoxRow(
            context,
            [
              ClickableBox(
                text: 'Add Room',
                icon: Icons.home,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddRoomPage(),
                    ),
                  );
                },
              ),
              ClickableBox(
                text: 'Add Student',
                icon: Icons.person,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddStudentPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          buildClickableBoxRow(
            context,
            [
              ClickableBox(
                text: 'Add Furniture',
                icon: Icons.weekend,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddFurniturePage(),
                    ),
                  );
                },
              ),
              ClickableBox(
                text: 'Show Rooms',
                icon: Icons.view_list,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShowRoomsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 10),
          buildClickableBoxRow(
            context,
            [
              ClickableBox(
                text: 'Manage Bills',
                icon: Icons.lightbulb,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MonthlyBillGenerationPage(
                        allocatedRooms: allocatedRooms,
                      ),
                    ),
                  );
                },
              ),
              ClickableBox(
                text: 'Payment Analytics',
                icon: Icons.analytics,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PaymentAnalyticsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildClickableBoxRow(BuildContext context, List<Widget> clickableBoxes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: clickableBoxes,
    );
  }
}







class ClickableBox extends StatefulWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  ClickableBox({required this.text, required this.icon, required this.onPressed});

  @override
  _ClickableBoxState createState() => _ClickableBoxState();
}

class _ClickableBoxState extends State<ClickableBox> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
        if (isTapped) {
          // Navigate to the specified page
          widget.onPressed();
        }
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: isTapped ? Colors.grey : Colors.blue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 60,
              color: isTapped ? Colors.blue : Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isTapped ? Colors.blue : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class AddRoomPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Room'),
//       ),
//       body: Center(
//         child: Text('Add Room Form Goes Here'),
//       ),
//     );
//   }
// }

class AddStudentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: Center(
        child: Text('Add Student Form Goes Here'),
      ),
    );
  }
}

class AddFurniturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Furniture'),
      ),
      body: Center(
        child: Text('Add Furniture Form Goes Here'),
      ),
    );
  }
}

// class ShowRoomsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Show Existing Rooms'),
//       ),
//       body: Center(
//         child: Text('List of Existing Rooms Goes Here'),
//       ),
//     );
//   }
// }

// class LightBillsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Light Bills'),
//       ),
//       body: Center(
//         child: Text('Light Bill Management Goes Here'),
//       ),
//     );
//   }
// }

class PaymentAnalyticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Analytics'),
      ),
      body: Center(
        child: Text('Payment Analytics Data Goes Here'),
      ),
    );
  }
}

// class DashboardScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       body: Center(
//         child: Text('Dashboard Goes Here'),
//       ),
//     );
//   }
// }

// class AProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Center(
//         child: Text('Profile Page Goes Here'),
//       ),
//     );
//   }
// }
