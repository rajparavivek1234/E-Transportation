import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/OTP.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Phone_Number extends StatefulWidget {
  const Phone_Number({key}) : super(key: key);

  @override
  _Phone_NumberState createState() => _Phone_NumberState();
}

class _Phone_NumberState extends State<Phone_Number> {
  bool clickButton = false;
  countrypicker() {
    return CountryCodePicker(
      onChanged: (country) {
        setState(() {
          dialCodeDigits = country.dialCode!;
        });
      },
      initialSelection: "IN",
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      favorite: ["+1", "US", "+91", "IND"],
    );
  }

  String number = "";
  String dialCodeDigits = "+91";
  TextEditingController controller = TextEditingController();

  bool changestate = false;
  var firstName = "";
  var lastName = "";
  var Email = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  String? MyUserID;
  String? isGoogle;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isGoogle = prefs.getString("isGoogle");
    });
    if (isGoogle != null) {
      print(isGoogle);
      MyUserID = FirebaseAuth.instance.currentUser!.uid;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("UserAuthID", MyUserID.toString());
      var user = FirebaseAuth.instance.currentUser;
      final names = user!.displayName.toString().split(' ');
      firstName = names[0];
      lastName = names.length > 1 ? names[1] : '';
      Email = user.email.toString();
      await prefs.setString("Firstname", firstName);
      await prefs.setString("Lastname", lastName);
      FirebaseFirestore.instance.collection("Users").doc(MyUserID).set({
        'First Name': firstName,
        'Last Name': lastName,
        'Email': Email,
      });
    } else {
      MyUserID = prefs.getString("UserAuthID");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MyUserID);
    print(isGoogle);

    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, exit(0));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, left: 20),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 0, 20),
                    child: Text(
                      "Mobile Verification",
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 200,
                child: Image.asset(
                    "Assets/Images/Phone_Auth/Phone_Number_Image.png",
                    height: 250),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: TextFormField(
                    onChanged: (value) {
                      number = value;
                      setState(() {});
                      changestate = true;
                    },
                    decoration: InputDecoration(
                        hintText: "Phone Number",
                        suffixIcon: changestate
                            ? Image.network(
                                'https://img.icons8.com/ios-glyphs/20/000000/checked--v2.png',
                                color: Colors.green,
                              )
                            : null,
                        prefixIcon: countrypicker(),
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                        )),
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    controller: controller,
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  print(MyUserID);
                  setState(() {
                    clickButton = true;
                  });

                  FirebaseFirestore.instance
                      .collection("Users")
                      .doc(MyUserID)
                      .update({
                    'UserId': MyUserID,
                    'Phone no': dialCodeDigits + " " + number,
                  });

                  await Future.delayed(Duration(seconds: 2));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (c) => Otp(
                        phone: controller.text,
                        codeDigits: dialCodeDigits,
                      ),
                    ),
                  );
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    clickButton = false;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: clickButton ? 40 : 330,
                  height: 40,
                  alignment: Alignment.center,
                  child: clickButton
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Text(
                          "Get OTP",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius:
                          BorderRadius.circular(clickButton ? 20 : 10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
