import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inspiro_quotes/screens/authentication/login.dart';
import 'package:inspiro_quotes/screens/authentication/signup.dart';
import 'package:inspiro_quotes/screens/dashboard/dashboard.dart';
import 'package:inspiro_quotes/screens/splash_screen.dart';
import 'package:inspiro_quotes/utils/app_routes/app_routes.dart';

import '../../screens/error/error.dart';

class AppRouteGenerator {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
        );
      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      case AppRoutes.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => SignUpScreen(),
        );
      case AppRoutes.errorScreen:
        return MaterialPageRoute(
          builder: (context) => ErrorScreen(),
        );
      case AppRoutes.dashboardScreen:
        return MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        );
    }
  }
}
