import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Food Menu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FoodMenuPage(),
    );
  }
}

class FoodMenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Food Menu'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the user profile page.
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Day-wise Menu
            DayMenu(day: 'Monday', items: [
              'Breakfast: Toast with Jam',
              'Lunch: Vegetable Curry',
              'Dinner: Rice with Dal',
            ]),
            DayMenu(day: 'Tuesday', items: [
              'Breakfast: Oatmeal',
              'Lunch: Paneer Tikka',
              'Dinner: Roti with Mixed Vegetables',
            ]),
            DayMenu(day: 'Wednesday', items: [
              'Breakfast: Idli with Sambar',
              'Lunch: Rajma Chawal',
              'Dinner: Vegetable Biryani',
            ]),
            DayMenu(day: 'Thursday', items: [
              'Breakfast: Poha',
              'Lunch: Aloo Paratha',
              'Dinner: Chole with Rice',
            ]),
            DayMenu(day: 'Friday', items: [
              'Breakfast: Upma',
              'Lunch: Spinach and Cheese Quesadilla',
              'Dinner: Vegetable Fried Rice',
            ]),
            DayMenu(day: 'Saturday', items: [
              'Breakfast: Dosa with Coconut Chutney',
              'Lunch: Veggie Burger',
              'Dinner: Pasta Primavera',
            ]),
            DayMenu(day: 'Sunday', items: [
              'Breakfast: Veggie Omelette',
              'Lunch: Vegetable Pulao',
              'Dinner: Pizza Margherita',
            ]),
          ],
        ),
      ),
    );
  }
}

class DayMenu extends StatelessWidget {
  final String day;
  final List<String> items;

  DayMenu({required this.day, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: items.map((item) => FoodItemCard(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String item;

  FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item),
      // You can add more information about the menu item here
    );
  }
}
