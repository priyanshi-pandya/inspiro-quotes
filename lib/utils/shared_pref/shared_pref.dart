import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:inspiro_quotes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static SharedPref? _instance;

  SharedPref._();

  factory SharedPref() => _instance ??= SharedPref._();

  static late SharedPreferences _sharedPreferences;

  static Future<SharedPreferences> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }
  
  static void setUserDetails({required email, String? pswd, String? name}) async {
    try {
      SharedPreferences pref = await SharedPref.init();
      pref.setString('email', email);
      pref.setString('pswd', pswd ?? "");
      pref.setString('name', pref.getString('name') ?? "Priyanshi");
    } catch (e) {
      ScaffoldMessenger.of(navKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

}
