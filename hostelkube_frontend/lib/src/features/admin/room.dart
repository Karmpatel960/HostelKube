import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRoomPage extends StatefulWidget {
  @override
  _AddRoomPageState createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController capacityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
   final TextEditingController pricePerBedController = TextEditingController();

void _addRoomToFirestore() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final roomData = {
      'roomNumber': roomNumberController.text,
      'capacity': int.parse(capacityController.text),
      'description': descriptionController.text,
      'pricePerBed': double.parse(pricePerBedController.text), // Add price per bed
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      await FirebaseFirestore.instance.collection('rooms').add(roomData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room added to Firestore')),
      );
      roomNumberController.clear();
      capacityController.clear();
      descriptionController.clear();
      pricePerBedController.clear(); // Clear the price per bed field
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding room: $error')),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.home,
                  size: 100,
                  color: Colors.blue,
                ),
                TextFormField(
                  controller: roomNumberController,
                  decoration: InputDecoration(
                    labelText: 'Room Number',
                    icon: Icon(Icons.home),
                  ),
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter a room number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: capacityController,
                  decoration: InputDecoration(
                    labelText: 'Capacity',
                    icon: Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return 'Please enter the room capacity';
                    }
                    return null;
                  },
                ),
                TextFormField(
  controller: pricePerBedController,
  decoration: InputDecoration(
    labelText: 'Price per Bed',
    icon: Icon(Icons.attach_money),
  ),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  validator: (value) {
    if (value != null && value.isEmpty) {
      return 'Please enter the price per bed';
    }
    return null;
  },
),

                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    icon: Icon(Icons.description),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      if (_formKey.currentState!.validate()) {
                        _addRoomToFirestore();
                      }
                    }
                  },
                  
                  child: Text('Add Room'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
