// ignore_for_file: unused_import, file_names, use_key_in_widget_constructors, camel_case_types, prefer_typing_uninitialized_variables, prefer_const_constructors, sized_box_for_whitespace, import_of_legacy_library_into_null_safe, non_constant_identifier_names

import 'dart:io';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/Phone_Number.dart';
import 'package:myproject/All_User_Pages/google_sign_in/google_sign_in.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:provider/provider.dart';

class Initial_Page extends StatefulWidget {
  @override
  State<Initial_Page> createState() => _Initial_PageState();
}

var login;

class _Initial_PageState extends State<Initial_Page> {
  String? MyDriverID;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    MyDriverID = prefs.getString('DriverAuthID');
  }

  String? detail;
  isDetailsAdded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      detail = prefs.getString("isDetailsAdded");
    });
  }

  String? mobile;
  isMobileAdded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile = prefs.getString("isMobileAdded");
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserCredentials();
    isDetailsAdded();
    isMobileAdded();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return mobile == null
                ? Phone_Number()
                : detail != null
                    ? home()
                    : driver_info();
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong!"),
            );
          } else {
            return Material(
              child: Scaffold(
                body: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      Text(
                        "Transport your goods with us",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(
                        height: 120,
                      ),
                      Lottie.asset(
                        "Assets/Animation/Initial_Page/Initial_Animation.json",
                        repeat: true,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      InkWell(
                        onTap: () async {
                          await pr.show();
                          pr.hide().whenComplete(() {
                            Navigator.pushNamed(context, MyRoutes.loginRoute);
                          });
                        },
                        child: Container(
                          height: 55,
                          width: 350,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    "Assets/Images/Initial_Page/Gmail.jpeg",
                                  ),
                                ),
                                Text(
                                  "  Continue with Email",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          )),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.deepPurpleAccent,
                                width: 3,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          await pr.show();
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("isGoogle", "Yes");
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false);
                          pr.hide().whenComplete(() {
                            provider.googleLogin();
                          });
                        },
                        child: Container(
                          height: 55,
                          width: 350,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 35,
                                    width: 35,
                                    child: Image.asset(
                                      "Assets/Images/Initial_Page/Google.jpeg",
                                    ),
                                  ),
                                  Text(
                                    " Login with google",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
