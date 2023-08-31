import 'package:flutter/material.dart';
import 'src/router/router.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.homeRoute, // You can set your desired initial route here
    );
  }
}
