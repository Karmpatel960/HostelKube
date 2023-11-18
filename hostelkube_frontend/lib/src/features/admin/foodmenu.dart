import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminWeekMenuPage extends StatefulWidget {
  @override
  _AdminWeekMenuPageState createState() => _AdminWeekMenuPageState();
}

class _AdminWeekMenuPageState extends State<AdminWeekMenuPage> {
  final Map<String, TextEditingController> dayControllers = {};
  String selectedWeek = 'Week 1'; // Initial week selection

  @override
  void initState() {
    super.initState();
    // Initialize text controllers for each day of the week
    final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    for (final day in daysOfWeek) {
      dayControllers[day] = TextEditingController();
    }
  }

  void addWeekMenu() {
    final weekNumber = selectedWeek; // Use the selected week
    final menuData = {};

    for (final day in dayControllers.keys) {
      final menu = dayControllers[day]?.text;
      if (menu != null && menu.isNotEmpty) {
        menuData[day] = menu;
      }
    }

    if (menuData.isNotEmpty) {
      FirebaseFirestore.instance.collection('weekMenus').add({
        'weekNumber': weekNumber,
        ...menuData,
      });

      // Clear the text controllers after adding the menu
      for (final controller in dayControllers.values) {
        controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Week Menu Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedWeek,
              items: <String>['Week 1', 'Week 2', 'Week 3', 'Week 4']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedWeek = value!;
                });
              },
            ),
            for (final day in dayControllers.keys)
              TextField(
                controller: dayControllers[day],
                decoration: InputDecoration(labelText: day),
              ),
            ElevatedButton(
              onPressed: addWeekMenu,
              child: Text('Add Week Menu'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of text controllers when the widget is disposed
    for (final controller in dayControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
