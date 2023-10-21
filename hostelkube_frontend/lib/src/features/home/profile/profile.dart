import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelkube_frontend/src/features/features.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String email = 'john.doe@example.com';
  String phoneNumber = '123-456-7890';
  String address = '123 Main St, City, Country';
  String roomNumber = 'Not Alloted'; // Initialize with a default room number
  String emergencyContact = '987-654-3210';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final emergencyContactController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirestore();
  }

  Future<void> fetchUserDataFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final fetchedName = userData['name'];
          final fetchedEmail = userData['email'];
          final fetchedPhoneNumber = userData['phoneNumber'];
          final fetchedAddress = userData['address'];
          final fetchedEmergencyContact = userData['emergencyContact'];

          setState(() {
            userName = fetchedName ?? '';
            email = fetchedEmail ?? '';
            phoneNumber = fetchedPhoneNumber ?? '';
            address = fetchedAddress ?? '';
            emergencyContact = fetchedEmergencyContact ?? '';
          });

          // Fetch the user's room number from the rooms collection
          fetchRoomNumberFromRoomsCollection(uid);
        } else {
          print('User document does not exist');
        }
      } else {
        print('User is not signed in');
      }

      nameController.text = userName;
      phoneNumberController.text = phoneNumber;
      addressController.text = address;
      emergencyContactController.text = emergencyContact;
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

Future<void> fetchRoomNumberFromRoomsCollection(String userId) async {
  try {
    final roomsQuery = await FirebaseFirestore.instance.collection('rooms')
      .where('users', arrayContains: userId) // Check if the user is in the 'users' array
      .get();

    if (!roomsQuery.docs.isEmpty) {
      final roomData = roomsQuery.docs[0].data() as Map<String, dynamic>;
      final fetchedRoomNumber = roomData['roomNumber'];
      setState(() {
        roomNumber = fetchedRoomNumber ?? '';
      });
    }
  } catch (error) {
    print('Error fetching room number: $error');
  }
}


  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        saveUserDataToFirestore();
      }
    });
  }

  Future<void> saveUserDataToFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'name': nameController.text,
          'phoneNumber': phoneNumberController.text,
          'address': addressController.text,
          'emergencyContact': emergencyContactController.text,
        });
      }
    } catch (error) {
      print('Error saving user data: $error');
    }
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ));
    } catch (error) {
      print('Error logging out: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('profile_image.jpg'),
              ),
              SizedBox(height: 20),
              Text(
                'Name:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextFormField(
                  controller: nameController,
                )
              else
                Text(
                  userName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              Text(
                'Email:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
                Text(
                  email,
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 16.0),
              Text(
                'Phone Number:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextFormField(
                  controller: phoneNumberController,
                )
              else
                Text(
                  phoneNumber,
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 16.0),
              Text(
                'Address:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextFormField(
                  controller: addressController,
                )
              else
                Text(
                  address,
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 16.0),
              Text(
                'Room Number:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
                Text(
                  roomNumber,
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 16.0),
              Text(
                'Emergency Contact:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isEditing)
                TextFormField(
                  controller: emergencyContactController,
                )
              else
                Text(
                  emergencyContact,
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 32.0),
              if (isEditing)
                ElevatedButton(
                  onPressed: toggleEdit,
                  child: Text('Save Changes'),
                )
              else
                ElevatedButton(
                  onPressed: toggleEdit,
                  child: Text('Edit'),
                ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: logout,
                child: Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
