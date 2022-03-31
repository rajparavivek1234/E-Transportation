import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String users = "0";
  String drivers = "0";
  String accepeddrivers = "0";
  String rejecteddrivers = "0";
  String tripsontheway = "0";
  String feedbacks = "0";
  String f1 = "";
  String f2 = "";
  String? Email;

  void getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Email = prefs.getString("Email");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('Users').get().then(((value) {
      setState(() {
        users = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "1")
        .get()
        .then(((value) {
      setState(() {
        drivers = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "2")
        .get()
        .then(((value) {
      setState(() {
        accepeddrivers = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "3")
        .get()
        .then(((value) {
      setState(() {
        rejecteddrivers = value.size.toString();
      });
    }));
    // FirebaseFirestore.instance.collection('User Feedback').get().then(((value) {
    //   feedbacks = value.size.toString();
    // }));
    FirebaseFirestore.instance.collection('User Feedback').get().then(((value) {
      setState(() {
        f1 = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver Feedback')
        .get()
        .then(((value) {
      setState(() {
        f2 = value.size.toString();
      });
    }));
    setState(() {
      int x = int.tryParse(f1) ?? 0;
      int y = int.tryParse(f2) ?? 0;
      int z = x + y;
      feedbacks = z.toString();
    });

    FirebaseFirestore.instance
      ..collection('Driver')
          .where("On Trip", isEqualTo: "Yes")
          .get()
          .then(((value) {
        tripsontheway = value.size.toString();
      }));
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(exit(0));
      },
      child: Scaffold(
        drawer: navigationDrawerAdmin(),
        key: _scaffoldKey,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: [
                  CustomPaint(
                    painter: ShapesPainter(),
                    child: Container(
                      height: 270,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_scaffoldKey
                                        .currentState!.isDrawerOpen) {
                                      _scaffoldKey.currentState!
                                          .openEndDrawer();
                                    } else {
                                      _scaffoldKey.currentState!.openDrawer();
                                    }
                                  },
                                  child: Icon(
                                    Icons.menu,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  "My Dashboard",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 17,
                            ),
                            Container(
                              height: 2,
                              width: 393,
                              color: Colors.black38,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 3),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(100),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            spreadRadius: 4,
                                            blurRadius: 20,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: Offset(5, 15),
                                          )
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Email ==
                                                "pateltrushil046@gmail.com"
                                            ? Image.asset(
                                                "Assets/Images/Admin/Admin_T.jpeg",
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              )
                                            : Email ==
                                                    "prajapatinehansh1@gmail.com"
                                                ? Image.asset(
                                                    "Assets/Images/Admin/Admin_N.jpeg",
                                                    width: 60,
                                                    height: 60,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Email ==
                                                        "rajparavivek1234@gmail.com"
                                                    ? Image.asset(
                                                        "Assets/Images/Admin/Admin_V.jpeg",
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.network(
                                                        "https://freesvg.org/img/abstract-user-flat-4.png",
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Email == "pateltrushil046@gmail.com"
                                          ? "Trushil Patel"
                                          : Email ==
                                                  "prajapatinehansh1@gmail.com"
                                              ? "Nehansh Prajapati"
                                              : Email ==
                                                      "rajparavivek1234@gmail.com"
                                                  ? "Vivek Rajpara"
                                                  : "",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      Email == "pateltrushil046@gmail.com"
                                          ? "pateltrushil046@gmail.com"
                                          : Email ==
                                                  "prajapatinehansh1@gmail.com"
                                              ? "prajapatinehansh1@gmail.com"
                                              : Email ==
                                                      "rajparavivek1234@gmail.com"
                                                  ? "rajparavivek1234@gmail.com"
                                                  : "",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            padding: new EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .22,
                            ),
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.greenAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        users,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Users",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            padding: new EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .22,
                            ),
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.orangeAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        drivers,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Driver Requests",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.pinkAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        tripsontheway,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Trips on the way",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.yellowAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        feedbacks,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Feedbacks",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.topCenter,
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.blueAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        accepeddrivers,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Approved Drivers",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topCenter,
                            child: new Container(
                              height: 190.0,
                              width: 190,
                              child: new Card(
                                color: Colors.lightGreenAccent,
                                elevation: 4.0,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        rejecteddrivers,
                                        style: TextStyle(
                                          fontSize: 40,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Rejected Drivers",
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const double _kCurveHeight = 35;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(p, Paint()..color = Colors.deepPurpleAccent);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
