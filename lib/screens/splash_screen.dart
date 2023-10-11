import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inspiro_quotes/utils/app_routes/app_routes.dart';
import 'package:inspiro_quotes/utils/shared_pref/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async{
    SharedPreferences pref = await SharedPref.init();
    print(pref.containsKey('email'));
    Timer(
      Duration(seconds: 3),
      () {
        if(pref.containsKey('email')) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboardScreen);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/quote.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: const Center(
          child: Text(
            "Embrace the 'Quote' that speaks to your soul",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
