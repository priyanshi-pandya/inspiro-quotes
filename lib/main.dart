import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:inspiro_quotes/firebase_options.dart';
import 'package:inspiro_quotes/utils/app_routes/app_route_generator.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final navKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Courgette',
      ),
      darkTheme: ThemeData.dark(useMaterial3: true,),
      initialRoute: '/',
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouteGenerator.generateRoute,
    );
  }
}
