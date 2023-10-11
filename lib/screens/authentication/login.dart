import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:inspiro_quotes/services/auth/authservice.dart';
import 'package:inspiro_quotes/utils/app_routes/app_routes.dart';
import 'package:inspiro_quotes/utils/firebase/firebase.dart';
import 'package:inspiro_quotes/utils/shared_pref/shared_pref.dart';
import 'package:inspiro_quotes/widgets/custom_button.dart';
import 'package:inspiro_quotes/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _pswdController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _pswdController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  void _getUserDetails() async {
    try {
      SharedPreferences pref = await SharedPref.init();
      _emailController.text = pref.getString('email') ?? "";
      _pswdController.text = pref.getString('pswd') ?? "";
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/quote.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _form,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(child: SizedBox()),
                  const Text(
                    "Inspiro Quotes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    controller: _emailController,
                    hintText: "Username",
                    vadidationText: "Please enter username",
                    isObsure: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    controller: _pswdController,
                    hintText: "Password",
                    vadidationText: "Please enter password",
                    isObsure: true,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Login",
                    onTap: () {
                      FirebaseAuth _auth = FirebaseInstance.firebaseInstance();
                      _auth
                          .signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _pswdController.text)
                          .then(
                        (value) {
                          SharedPref.setUserDetails(
                             email: _emailController.text,pswd: _pswdController.text);
                          return Navigator.pushReplacementNamed(
                              context, AppRoutes.dashboardScreen);
                        },
                      ).onError(
                        (error, stackTrace) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                          ),
                        ),
                      );
                    },
                    color: Colors.blue,
                    borderColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    text: "Sign Up",
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.signUpScreen);
                    },
                    color: Colors.transparent,
                    borderColor: Colors.white,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.white,
                        endIndent: 20,
                      )),
                      Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.white,
                        indent: 20,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => AuthService.signInWithGoogle(context)
                            .then(
                              (value) => Navigator.pushNamed(
                                  context, AppRoutes.dashboardScreen),
                            )
                            .onError(
                              (error, stackTrace) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    error.toString(),
                                  ),
                                ),
                              ),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/icons/google.png'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => AuthService.signInWithFB(context).then(
                          (value) => Navigator.pushNamed(
                              context, AppRoutes.dashboardScreen),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle),
                          padding: const EdgeInsets.all(10),
                          child: Image.asset('assets/icons/fb.png'),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/icons/twitter.png'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
