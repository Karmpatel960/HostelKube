import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostelkube_frontend/src/models/issue.dart';

class ManageIssuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Issues'),
      ),
      body: IssueList(),
    );
  }
}

class IssueList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('issues').orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        final issues = snapshot.data!.docs.map((doc) {
  final data = doc.data() as Map<String, dynamic>;
  return Issue(
    data['complaintId'],
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Status: ' + issue.status),
                          if (issue.status == 'Open')
                            IconButton(
                              icon: Icon(Icons.check), // Icon to change status to 'Processing'
                              onPressed: () {
                                // Call a function to update the status to 'Processing'
                                updateIssueStatus(issue, 'Processing');
                              },
                            )
                          else if (issue.status == 'Processing')
                            IconButton(
                              icon: Icon(Icons.close), // Icon to change status to 'Closed'
                              onPressed: () {
                                // Call a function to update the status to 'Closed'
                                updateIssueStatus(issue, 'Closed');
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text('No issues found'),
              );
      },
    );
  }

void updateIssueStatus(Issue issue, String newStatus) {
  // Update the status of the issue in Firestore using the complaint ID
  FirebaseFirestore.instance.collection('issues').doc(issue.complaintId).update({
    'status': newStatus,
  });
}
}
