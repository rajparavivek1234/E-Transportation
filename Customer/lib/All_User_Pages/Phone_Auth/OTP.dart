// ignore_for_file: unused_local_variable

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/User_Pages/Home_Page/Home_Page.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:myproject/Utils/SharedVar.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:otp_count_down/otp_count_down.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final String phone;
  final String codeDigits;
  Otp({required this.phone, required this.codeDigits});
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinCode = TextEditingController();
  final FocusNode _pinCodeFocus = FocusNode();
  String? varificationCode;
  bool codeNotSent = true;
  int _duration = 120;

  final BoxDecoration pinCodeDecoration = BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: Colors.grey,
      ));

  @override
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential).then(
          (value) {
            if (value.user != null) {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => kdialougebox());
            }
          },
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message.toString(),
            ),
          ),
        );
      },
      codeSent: (String vID, int? resendToken) {
        setState(() {
          varificationCode = vID;
          codeNotSent = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP sent."),
            backgroundColor: Colors.orangeAccent,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          varificationCode = vID;
        });
      },
      timeout: Duration(seconds: 120),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(LogInid);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20),
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
              Container(
                height: 200,
                width: 200,
                child: Image.asset(
                  "Assets/Images/Phone_Auth/Phone_Number_Image.png",
                ),
              ),
              Container(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      verifyPhoneNumber();
                    },
                    child: Text(
                      "Verifying : ${widget.codeDigits}-${widget.phone} : Please wait.....",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Lottie.asset(
                  "Assets/Animation/Splash_Screen/89023-loading-circles.json",
                  height: 60,
                  repeat: codeNotSent ? true : false),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: PinPut(
                  fieldsCount: 6,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  eachFieldWidth: 40,
                  eachFieldHeight: 55,
                  autofocus: true,
                  focusNode: _pinCodeFocus,
                  controller: _pinCode,
                  submittedFieldDecoration: pinCodeDecoration,
                  selectedFieldDecoration: pinCodeDecoration,
                  followingFieldDecoration: pinCodeDecoration,
                  pinAnimationType: PinAnimationType.rotation,
                  onSubmit: (pin) async {
                    ProgressDialog pr = ProgressDialog(context);
                    try {
                      pr.show();
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: varificationCode!, smsCode: pin))
                          .then(
                        (value) async {
                          if (value.user != null) {
                            SharedVariables.phoneVerified = true;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login Successfully."),
                                backgroundColor: Colors.orangeAccent,
                              ),
                            );
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString("isMobileAdded", "Yes");
                            pr.hide().whenComplete(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => User_Details(),
                                ),
                              );
                            });
                          }
                        },
                      );
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      pr.hide().whenComplete(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Invalid OTP"),
                          ),
                        );
                      });
                    }
                  },
                ),
              ),
              CircularCountDownTimer(
                // Countdown duration in Seconds.
                duration: _duration,

                // Countdown initial elapsed Duration in Seconds.
                initialDuration: 0,

                // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.

                // Width of the Countdown Widget.
                width: 40,

                // Height of the Countdown Widget.
                height: 40,

                // Ring Color for Countdown Widget.
                ringColor: Colors.grey[300]!,

                // Ring Gradient for Countdown Widget.
                ringGradient: null,

                // Filling Color for Countdown Widget.
                fillColor: Colors.deepPurple,

                // Filling Gradient for Countdown Widget.
                fillGradient: null,

                // Background Color for Countdown Widget.
                backgroundColor: Colors.white,

                // Background Gradient for Countdown Widget.
                backgroundGradient: null,

                // Border Thickness of the Countdown Ring.
                strokeWidth: 5.0,

                // Begin and end contours with a flat edge and no extension.
                strokeCap: StrokeCap.round,

                // Text Style for Countdown Text.
                textStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),

                // Format for the Countdown Text.
                textFormat: CountdownTextFormat.S,

                // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                isReverse: true,

                // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                isReverseAnimation: false,

                // Handles visibility of the Countdown Text.
                isTimerTextShown: true,

                // Handles the timer start.
                autoStart: true,

                // This Callback will execute when the Countdown Starts.
                onStart: () {
                  // Here, do whatever you want

                  print('Countdown Started');
                },
                // This Callback will execute when the Countdown Ends.
                onComplete: () {
                  // Here, do whatever you want

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class kdialougebox extends StatefulWidget {
  const kdialougebox({
    Key? key,
  }) : super(key: key);

  @override
  State<kdialougebox> createState() => _kdialougeboxState();
}

class _kdialougeboxState extends State<kdialougebox> {
  void initState() {
    super.initState();
    // Timer(
    //   const Duration(seconds: 2),
    //   () =>
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => User_Details(),
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      children: <Widget>[
        Lottie.asset(
            "Assets/Animation/PhoneVerification/58201-success-tick.json",
            height: 150,
            repeat: false),
        SizedBox(
          height: 10,
        ),
        Center(child: Text("Verification Successfull")),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
