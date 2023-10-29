import 'package:cloud_firestore/cloud_firestore.dart';

class RoomData {
  String roomId;
  String roomNumber;
  int capacity;
  String description;
  int pricePerBed;
  String createdBy;
  DateTime createdAt; 
  List<String> users;

  RoomData({
    required this.roomId,
    required this.roomNumber,
    required this.capacity,
    required this.description,
    required this.pricePerBed,
    required this.createdBy,
    required this.createdAt,
    required this.users,
  });

  factory RoomData.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return RoomData(
      roomId: snapshot.id,
      roomNumber: data['roomNumber'],
      capacity: data['capacity'],
      description: data['description'],
      pricePerBed: data['pricePerBed'],
      createdBy: data['createdBy'],
      createdAt: (data['createdAt'] as Timestamp).toDate(), // Convert to DateTime
      users: (data['users'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }
}


class MonthlyBillData {
  final String roomId;
  final double totalAmount;
  final DateTime month;
  final List<String> userIds;

  MonthlyBillData({
    required this.roomId,
    required this.totalAmount,
    required this.month,
    required this.userIds,
  });
}


