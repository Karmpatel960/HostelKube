import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardDataCalculator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<double> calculateTotalCollection(String createdBy) async {
  double totalCollection = 0;

  QuerySnapshot roomsQuery = await _firestore.collection('rooms').where('createdBy', isEqualTo: createdBy).get();
  for (QueryDocumentSnapshot roomSnapshot in roomsQuery.docs) {
    Map<String, dynamic> roomData = roomSnapshot.data() as Map<String, dynamic>;

    if (roomData.containsKey('users') && roomData.containsKey('pricePerBed')) {
      List<dynamic> users = roomData['users'];
      double pricePerBed = roomData['pricePerBed'].toDouble();

      totalCollection += pricePerBed * users.length;
    }
  }

  return totalCollection;
}


Future<int> calculateTotalRegisteredStudents(String userId) async {
  List<dynamic> userIds = [];

  QuerySnapshot roomsQuery = await _firestore.collection('rooms').get();
  for (QueryDocumentSnapshot roomSnapshot in roomsQuery.docs) {
    String createdBy = roomSnapshot['createdBy'];
    List<dynamic> users = roomSnapshot['users'] ?? [];

    if (users.isNotEmpty && createdBy == userId) {
      // Add only rooms created by the specified user
      userIds.add(createdBy); // Add the user who created the room
      userIds.addAll(users); // Add all the users in the room
    }
  }

  Set<dynamic> uniqueUserIds = userIds.toSet();
  return uniqueUserIds.length;
}


Future<double> calculateTotalLightBillPayments() async {
  double totalLightBillPayments = 0;

  QuerySnapshot billsQuery = await _firestore.collection('bills').get();
  for (QueryDocumentSnapshot billSnapshot in billsQuery.docs) {
    double billAmount = billSnapshot['totalAmount'] ?? 0.0; 
    totalLightBillPayments += billAmount;
  }

  return totalLightBillPayments;
}


  Future<int> calculateTotalRooms() async {
    QuerySnapshot roomsQuery = await _firestore.collection('rooms').get();
    return roomsQuery.size;
  }

Future<DashboardData> calculateDashboardData(String userId) async {
    final totalCollection = await calculateTotalCollection(userId);
    final totalStudents = await calculateTotalRegisteredStudents(userId);
    final totalLightBillPayments = await calculateTotalLightBillPayments();
    final totalRooms = await calculateTotalRooms();

    return DashboardData(
      totalCollection: totalCollection,
      totalStudents: totalStudents,
      totalLightBillPayments: totalLightBillPayments,
      totalRooms: totalRooms,
    );
  }
}

class DashboardData {
  final double totalCollection;
  final int totalStudents;
  final double totalLightBillPayments;
  final int totalRooms;

  DashboardData({
    required this.totalCollection,
    required this.totalStudents,
    required this.totalLightBillPayments,
    required this.totalRooms,
  });
}

class DashboardScreen extends StatelessWidget {
  final String userId;

  DashboardScreen({
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
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
      body: Center(
        child: HostelManagementDashboard(userId: userId),
      ),
    );
  }
}


class HostelManagementDashboard extends StatelessWidget {
  final DashboardDataCalculator dataCalculator;
  final String userId;

  HostelManagementDashboard({
    required this.userId,
  }) : dataCalculator = DashboardDataCalculator();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dataCalculator.calculateDashboardData(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final dashboardData = snapshot.data as DashboardData;

          return Column(
            children: [
              _buildDashboardCard(
                title: 'Total Fee Collection',
                value: '\u20B9${dashboardData.totalCollection}',
                color: Colors.green,
              ),
              _buildDashboardCard(
                title: 'Total Registered Students',
                value: '${dashboardData.totalStudents}',
                color: Colors.blue,
              ),
              _buildDashboardCard(
                title: 'Total Light Bill Payments',
                value: '\u20B9${dashboardData.totalLightBillPayments}',
                color: Colors.orange,
              ),
              _buildDashboardCard(
                title: 'Total Rooms',
                value: '${dashboardData.totalRooms}',
                color: Colors.yellow,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

