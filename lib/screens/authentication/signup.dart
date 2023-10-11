import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspiro_quotes/utils/app_routes/app_routes.dart';
import 'package:inspiro_quotes/utils/firebase/firebase.dart';
import 'package:inspiro_quotes/utils/shared_pref/shared_pref.dart';
import 'package:inspiro_quotes/widgets/custom_button.dart';
import 'package:inspiro_quotes/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswdController = TextEditingController();
  final TextEditingController _numController = TextEditingController();

  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _pswdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 50),
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
                    hintText: "Email",
                    vadidationText: "Please enter email",
                    isObsure: false,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                    controller: _numController,
                    hintText: "Phone Number",
                    vadidationText: "Please enter phone number",
                    isObsure: false,
                    keyboardType: TextInputType.number,
                    inputFormaters: [FilteringTextInputFormatter.digitsOnly],
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
                    text: "Sign up",
                    onTap: () {
                      if (_form.currentState!.validate()) {
                        FirebaseAuth _auth = FirebaseInstance.firebaseInstance();
                        _auth
                            .createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _pswdController.text)
                            .then(
                          (value) async {
                            SharedPreferences pref = await SharedPref.init();
                            pref.setString('email', _emailController.text);
                            pref.setString('pswd', _pswdController.text);
                            if (mounted) {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.loginScreen);
                            }
                          },
                        ).onError((error, stackTrace) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error.toString()),
                            ),
                          );
                        });
                      }
                    },
                    color: Colors.blue,
                    borderColor: Colors.blue,
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
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/icons/google.png'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(10),
                        child: Image.asset('assets/icons/fb.png'),
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
