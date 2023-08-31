import 'package:flutter/material.dart';
import '/src/features/features.dart';

class Routes {
  static const String homeRoute = '/';
  static const String adminRoute = '/admin';
  static const String loginRoute = '/login';
  static const String SplashRoute = '/splash';

  static bool _isFirstTime = true;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    if (_isFirstTime) {
      _isFirstTime = false;
      return MaterialPageRoute(builder: (_) => SplashScreen());
    }

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case adminRoute:
        return MaterialPageRoute(builder: (_) => AdminScreen());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      default:
        return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}

