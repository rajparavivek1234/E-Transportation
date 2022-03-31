import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/Phone_Number.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

String password = "";
String eMail = "";
String firstname = "";
String lastname = "";
String? id;

class _SignUpState extends State<SignUp> {
  String conformpassword = "";

  bool PassShow = true;
  bool confirmPassShow = true;
  bool clickSignUpButton = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Registration(BuildContext context) async {
    ProgressDialog pr = ProgressDialog(context);

    if (password == conformpassword) {
      pr.show();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: eMail, password: password);
        print(userCredential);

        String UserAuthID = FirebaseAuth.instance.currentUser!.uid;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("UserAuthID", UserAuthID);
        await prefs.setString("Firstname", firstname);
        await prefs.setString("Lastname", lastname);
        setState(() {
          clickSignUpButton = true;
        });

        FirebaseFirestore.instance.collection("Users").doc(UserAuthID).set({
          'First Name': firstname,
          'Last Name': lastname,
          'Email': eMail,
        });

        await Future.delayed(Duration(seconds: 2));
        pr.hide().whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Phone_Number(),
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration Successfully and logged in"),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          pr.hide().whenComplete(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Password is too weak.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.black,
              ),
            );
          });
        } else if (e.code == 'email-already-in-use') {
          pr.hide().whenComplete(() {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Account already exist.",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.black,
              ),
            );
          });
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("pass not match");
      pr.hide().whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Password and Confirm Password must be same.",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.black,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: 50,
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
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "U",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
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
                  Column(
                    children: [
                      Text(
                        "S",
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "ign ",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Text(
                    "u",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Text(
                    "p",
                    style: TextStyle(
                      fontSize: 55,
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
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    firstname = value;
                  },
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: "Firstname",
                    hintText: "Enter Firstname",
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Firstname can't be empty";
                    } else if (!RegExp(r"[A-Za-z]").hasMatch(value)) {
                      return "Enter Correct Firstname";
                    }
                    null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    lastname = value;
                  },
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: "Lastname",
                    hintText: "Enter Lastname",
                    prefixIcon: Icon(Icons.account_circle),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Lastname can't be empty";
                    } else if (!RegExp(r"[A-Za-z]").hasMatch(value)) {
                      return "Enter Correct Lastname";
                    }
                    null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    eMail = value;
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
                    } else if (!RegExp(r"^[a-z0-9.]+@[a-z]+\.[a-z]+")
                        .hasMatch(value)) {
                      if (RegExp(r"^[a-z0-9.]+@[a-z]+\.[a-z]+\.[a-z]")
                          .hasMatch(value)) {
                        null;
                      }
                      return "Enter Correct Email";
                    }
                    null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    password = value;
                  },
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: confirmPassShow,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Enter Confirm Password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: _confirmShowPass,
                      child: Icon(
                        confirmPassShow
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Confirm Password can't be empty.";
                    }
                    null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () async {
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      eMail = _emailController.text;
                      password = _passwordController.text;
                      conformpassword = _confirmPasswordController.text;
                    });
                    Registration(context);
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: clickSignUpButton ? 50 : 330,
                  height: 50,
                  alignment: Alignment.center,
                  child: clickSignUpButton
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
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
                  text: "Already have account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                      }),
              ])),
              SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
