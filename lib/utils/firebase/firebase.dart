import 'package:firebase_auth/firebase_auth.dart';

class FirebaseInstance{
  static FirebaseInstance? _instance;

  FirebaseInstance._();

 factory FirebaseInstance() => _instance ??= FirebaseInstance._(); 

  static late FirebaseAuth _firebaseAuth;

  static FirebaseAuth firebaseInstance(){
    _firebaseAuth =  FirebaseAuth.instance;
    return _firebaseAuth;
  }
}