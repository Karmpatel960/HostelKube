import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostelkube_frontend/src/models/issue.dart';

class Issue {
  final String userId;
  final String roomId;
  final String title;
  final String description;
  final String status;

  Issue(this.userId, this.roomId, this.title, this.description, this.status);
}

class IssuePage extends StatefulWidget {

  final String userId;

  IssuePage({
    required this.userId,
  });
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  CollectionReference issuesCollection = FirebaseFirestore.instance.collection('issues');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Issues'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Issue Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Issue Description'),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: submitIssue,
              child: Text('Submit Issue'),
            ),
            SizedBox(height: 24),
            Text(
              'Submitted Issues:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: issuesCollection.where('userId', isEqualTo: widget.userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
final issues = snapshot.data!.docs.map((doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Issue(
    data['userId'],
    data['roomId'],
    data['title'],
    data['description'],
    data['status'],
  );
}).toList();


            return issues.isNotEmpty
  ? ListView.builder(
      itemCount: issues.length,
      itemBuilder: (ctx, index) {
        final issue = issues[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(issue.title),
            subtitle: Text(issue.description),
            trailing: Text('Status : '+ issue.status),
          ),
        );
      },
    )
  : Center(
      child: Text('No issues found'),
    );


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

void submitIssue() async {
  final title = titleController.text;
  final description = descriptionController.text;

  if (title.isEmpty || description.isEmpty) {
    return;
  }

  try {
    // Query the rooms collection to find the user's room
    final roomsSnapshot = await FirebaseFirestore.instance.collection('rooms')
        .where('users', arrayContains: widget.userId) // Check if the user is in the 'users' array
        .get();

    // Check if a room is found for the user
    if (roomsSnapshot.docs.isNotEmpty) {
      final userRoomId = roomsSnapshot.docs[0]['roomId']; // Get the room ID

      // Create a new issue document reference
      final newIssueRef = issuesCollection.doc();

      // Add the new issue to Firestore with the document ID
      await newIssueRef.set({
        'complaintId': newIssueRef.id,
        'userId': widget.userId,
        'roomId': userRoomId,
        'title': title,
        'description': description,
        'status': 'Open', // Initial status
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Clear the text controllers
      titleController.clear();
      descriptionController.clear();
    } else {
      // Handle the case where the user is not registered in any room.
      print('User is not registered in any room.');
    }
  } catch (error) {
    // Handle the error
    print('Error submitting issue: $error');
  }
}



  // void updateIssueStatus(Issue issue, String newStatus) {
  //   // Update the status of the issue in Firestore
  //   issuesCollection.doc(issue.userId).update({
  //     'status': newStatus,
  //   });
  // }
}
