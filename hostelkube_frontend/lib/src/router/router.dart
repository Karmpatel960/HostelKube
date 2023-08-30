import 'package:flutter/material.dart';
import '/src/features/features.dart';

class Routes {
  static const String homeRoute = '/';
  static const String adminRoute = '/admin';
  static const String loginRoute = '/login';
  static const String SplashRoute = '/splash';

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case adminRoute:
        return MaterialPageRoute(builder: (_) => AdminScreen());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case SplashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());


      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
