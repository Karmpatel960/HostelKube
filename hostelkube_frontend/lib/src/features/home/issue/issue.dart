import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Issue {
  final String title;
  final String description;
  bool isSolved;

  Issue(this.title, this.description, {this.isSolved = false});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hostel Issues',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IssuePage(),
    );
  }
}

class IssuePage extends StatefulWidget {
  @override
  _IssuePageState createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  DatabaseReference _database = FirebaseDatabase.instance.reference();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Issue> issues = [];

  void submitIssue() {
    final title = titleController.text;
    final description = descriptionController.text;

    if (title.isEmpty || description.isEmpty) {
      return;
    }

    final newIssue = Issue(title, description);

    // Push the new issue to Firebase Database
    _database.push().set({
      'title': newIssue.title,
      'description': newIssue.description,
      'isSolved': newIssue.isSolved,
    });

    setState(() {
      issues.add(newIssue);
      titleController.clear();
      descriptionController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize Firebase Database reference
    DatabaseReference databaseRef =
        FirebaseDatabase.instance.reference().child('issues'); // Use your database node name

    // Listen for child additions
    // ...

// Listen for child additions
databaseRef.onChildAdded.listen((event) {
  final data = event.snapshot.value as Map<String, dynamic>?; // Cast data to Map

  if (data != null) {
    final issue = Issue(
      data['title'] ?? '',
      data['description'] ?? '',
      isSolved: data['isSolved'] ?? false,
    );
    setState(() {
      issues.add(issue);
    });
  }
});
  }

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
              child: ListView.builder(
                itemCount: issues.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(issues[index].title),
                      subtitle: Text(issues[index].description),
                      trailing: Checkbox(
                        value: issues[index].isSolved,
                        onChanged: (newValue) {
                          setState(() {
                            issues[index].isSolved = newValue ?? false;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

