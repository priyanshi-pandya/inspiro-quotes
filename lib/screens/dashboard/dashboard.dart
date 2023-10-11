import 'dart:developer';
import 'dart:ui';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:inspiro_quotes/services/auth/authservice.dart';
import 'package:inspiro_quotes/utils/app_routes/app_routes.dart';
import 'package:inspiro_quotes/utils/shared_pref/shared_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isCreate = false;
  TextEditingController _quoteController = TextEditingController();
  TextEditingController _quoteNameController = TextEditingController();
  Color _color = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('quote').snapshots(),
          builder: (context, snapshot) {
            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.8),
                  // image: DecorationImage(
                  //     image: AssetImage('assets/images/quote.jpg'),
                  //     fit: BoxFit.cover),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 500,
                    sigmaY: 500,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 20, bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Inspiro Quotes",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Courgette',
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.settings_outlined),
                            IconButton(
                              onPressed: () async {
                                await AuthService.googleSignOut();
                                // await AuthService.fbSignOut();
                                FirebaseAuth.instance.signOut().then(
                                      (value) => Navigator.popAndPushNamed(
                                        context,
                                        AppRoutes.loginScreen,
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.logout_outlined),
                            ),
                          ],
                        ),
                        isCreate == false
                            ? (snapshot.connectionState ==
                                        ConnectionState.waiting ||
                                    !snapshot.hasData)
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, right: 50.0, top: 10.0),
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: AppinioSwiper(
                                      loop: true,
                                      cardsCount: snapshot.data?.size ?? 0,
                                      onSwiping:
                                          (AppinioSwiperDirection direction) {},
                                      cardsBuilder:
                                          (BuildContext context, int index) {
                                            print(snapshot.data?.docs[index]['color'].runtimeType);
                                        _color =
                                            Color(snapshot.data?.docs[index]['color']);
                                            print("color $_color");
                                        return Card(
                                          elevation: 10,
                                          color: _color,
                                          semanticContainer: true,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          // child: Image.asset("images/background.jpg"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(),
                                              Center(
                                                child: Text(
                                                  snapshot.data?.docs[index]
                                                      ['quote'],
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontFamily: 'Courgette',
                                                    color: Colors.white,
                                                    fontSize: 25.0,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 20.0),
                                                child: Text(
                                                  snapshot.data?.docs[index]
                                                      ['by'],
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Courgette',
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                            : Container(
                                padding: const EdgeInsets.only(
                                    left: 50.0, right: 50.0, top: 10.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.7,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: _color ?? Colors.black,
                                    // image: const DecorationImage(
                                    //   image:
                                    //       AssetImage('assets/images/quote.jpg'),
                                    // ),
                                  ),
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                    controller: _quoteController,
                                    textAlign: TextAlign.center,
                                    onTapOutside: (event) =>
                                        FocusScope.of(context).unfocus(),
                                    minLines: 1,
                                    maxLines: 4,
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: 'Please Enter your Quote Here',
                                    ),
                                  ),
                                ),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () async {
                                _color = await showColorPicker(context);
                                setState(() {});
                                print(_color);
                              },
                              icon: Icon(isCreate
                                  ? Icons.color_lens
                                  : Icons.refresh_outlined),
                            ),
                            isCreate == false
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isCreate = true;
                                      });
                                    },
                                    icon: const Icon(Icons.edit_outlined))
                                : IconButton(
                                    onPressed: () async {
                                      if (_quoteController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text("Please add content"),
                                          ),
                                        );
                                      } else {
                                        SharedPreferences _pref =
                                            await SharedPref.init();
                                        String id =
                                            _pref.getString('email').toString();
                                        String name =
                                            _pref.getString('name').toString();
                                        String email =
                                            _pref.getString('email').toString();
                                        try {
                                          FirebaseFirestore.instance
                                              .collection('quote')
                                              .add({
                                            'quote': _quoteController.text,
                                            'by': name,
                                            'liked': false,
                                            'email': email,
                                            'type': 'Motivation',
                                            'color': _color.value,
                                          }).then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Quote added sucessfully"),
                                              ),
                                            );
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(e.toString())));
                                        }
                                        setState(() {
                                          isCreate = false;
                                        });
                                        _quoteController.clear();
                                      }
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.download_outlined),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

showColorPicker(BuildContext context) async {
  Color _color = Colors.black;
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Choose Background color"),
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, _color);
            },
            child: Text("Ok")),
      ],
      content: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        child: ColorPicker(
          color: _color,
          onChanged: (color) {
            _color = color;
          },
        ),
      ),
    ),
  );
}
