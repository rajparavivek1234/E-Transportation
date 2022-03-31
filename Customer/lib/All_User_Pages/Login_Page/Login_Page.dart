import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myproject/User_Pages/Home_Page/Home_Page.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Login_Page extends StatefulWidget {
  @override
  State<Login_Page> createState() => _Login_PageState();
}

String email = "";
String? LogInid;

class _Login_PageState extends State<Login_Page> {
  String password = "";
  String conformpassword = "";

  bool PassShow = true;
  bool confirmPassShow = true;
  bool clickSignUpButton = false;
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        clickSignUpButton = true;
      });
      // await Future.delayed(Duration(seconds: 2));
      // var users = await FirebaseFirestore.instance
      //     .collection('Users')
      //     .snapshots()
      //     .listen((data) {
      //   data.docChanges.forEach(
      //     (change) async {
      //       Map<String, dynamic>? myMap = change.doc.data();
      //       print(myMap);
      //       if (myMap!["Email"] == email) {
      //         LogInid = myMap["UserId"];

      //         print(LogInid);
      //         await Navigator.pushNamed(context, MyRoutes.homeRoute);
      //       }
      //     },
      //   );
      // });

      //start new
      String UserAuthID = FirebaseAuth.instance.currentUser!.uid;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserAuthID", UserAuthID);

      await prefs.setString("isDetailsAdded", "Yes");
      await prefs.setString("isMobileAdded", "Yes");
      await prefs.setString("is_Open", "Yes");

      Navigator.pushNamed(context, MyRoutes.homeRoute);

      //end new

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Successfully"),
          backgroundColor: Colors.orangeAccent,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            "No user found.",
            style: TextStyle(color: Colors.white),
          ),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black87,
          content: Text(
            "Wrong password.",
            style: TextStyle(color: Colors.white),
          ),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  _showPassword() {
    setState(() {
      PassShow = !PassShow;
    });
  }

  _confirmShowPass() {
    setState(() {
      confirmPassShow = !confirmPassShow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Material(
          child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                //  Image.asset("Assets/Images/Login_Page/Login_Image.png"),
                SizedBox(
                  height: 100,
                ),
                GradientText(
                  "E Trasporatation",
                  style: GoogleFonts.greatVibes(
                    fontSize: 45,
                    fontWeight: FontWeight.w500,
                  ),
                  colors: [Colors.blue, Colors.red, Colors.teal],
                ),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "U",
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      "ser",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "L",
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Text(
                      "ogin",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),

                Container(
                  height: 3,
                  width: 80,
                  color: Colors.black87,
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Email can't be empty";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: PassShow,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: _showPassword,
                        child: Icon(
                          PassShow ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Password can't be empty";
                      }
                      null;
                    },
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRoutes.forgotPasswordRoute);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 250,
                    ),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        email = _emailController.text;
                        password = _passwordController.text;
                      });
                      Login();
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    width: clickSignUpButton ? 50 : 330,
                    height: 50,
                    alignment: Alignment.center,
                    child: clickSignUpButton
                        ? Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        : Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        color: Colors.deepPurple,
                        borderRadius:
                            BorderRadius.circular(clickSignUpButton ? 25 : 10)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "Don't have account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  TextSpan(
                      text: "Register",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, MyRoutes.signUpRoute);
                        }),
                ]))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
