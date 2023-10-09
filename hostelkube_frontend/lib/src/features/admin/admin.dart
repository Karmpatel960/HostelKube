import 'package:flutter/material.dart';
import './room.dart';
import './roomalot.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Admin Screen Content'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the "Add Room" page when the button is pressed
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AdminPage(), // Replace with your "Add Room" page
                  ),
                );
              },
              child: Text('Add Room'),
            ),
            SizedBox(height: 20),
             ElevatedButton(
              onPressed: () {
                // Navigate to the "Add Room" page when the button is pressed
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AvailableRoomsPage(), // Replace with your "Add Room" page
                  ),
                );
              },
              child: Text('Add Student'),
            ),
          ],
        ),
      ),
    );
  }
}
