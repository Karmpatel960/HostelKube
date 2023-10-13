import 'package:flutter/material.dart';
import './room.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Admin'),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome, Admin!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Create a row with two clickable boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClickableBox(
                  text: 'Add Room',
                  icon: Icons.home,
                  onPressed: () {
                    // Navigate to the "Add Room" page
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
                    // Navigate to the "Add Student" page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddStudentPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Create another row with two clickable boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClickableBox(
                  text: 'Add Furniture',
                  icon: Icons.weekend,
                  onPressed: () {
                    // Navigate to the "Add Furniture" page
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
                    // Navigate to the "Show Rooms" page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowRoomsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Create the last row with two clickable boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClickableBox(
                  text: 'Manage Bills',
                  icon: Icons.lightbulb,
                  onPressed: () {
                    // Navigate to the "Manage Light Bills" page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LightBillsPage(),
                      ),
                    );
                  },
                ),
                ClickableBox(
                  text: 'Payment Analytics',
                  icon: Icons.analytics,
                  onPressed: () {
                    // Navigate to the "Payment Analytics" page
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
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        // Add functionality for bottom navigation items
        onTap: (int index) {
          // Handle bottom navigation item selection
        },
      ),
    );
  }
}

class ClickableBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  ClickableBox({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class AddRoomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'),
      ),
      body: Center(
        child: Text('Add Room Form Goes Here'),
      ),
    );
  }
}

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

class ShowRoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Existing Rooms'),
      ),
      body: Center(
        child: Text('List of Existing Rooms Goes Here'),
      ),
    );
  }
}

class LightBillsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Light Bills'),
      ),
      body: Center(
        child: Text('Light Bill Management Goes Here'),
      ),
    );
  }
}

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

