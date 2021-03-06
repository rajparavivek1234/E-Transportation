import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myproject/Admin_Pages/AdminLogin/AdminLogin.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Splash_Screen_Admin extends StatefulWidget {
  @override
  _Splash_Screen_AdminState createState() => _Splash_Screen_AdminState();
}

class _Splash_Screen_AdminState extends State<Splash_Screen_Admin> {
  String? is_Open;
  if_Open() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      is_Open = prefs.getString("is_Open");
    });

    print("is_Open ${is_Open}");
  }

  @override
  void initState() {
    super.initState();
    if_Open();
    Timer(
        const Duration(seconds: 10),
        () => is_Open != null
            ? Navigator.pushNamed(context, MyRoutes.AdminDashboard)
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => Admin_Login_Page())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                child: SvgPicture.asset(
                  "Assets/Images/Admin/E Transportation (2).svg",
                  height: 200,
                ),
                decoration: BoxDecoration(
                  //color: Colors.deepPurple,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(158, 158, 158, 1).withOpacity(0.9),
                      spreadRadius: 7,
                      blurRadius: 20,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
              ),
              // Image.asset(
              //   "Assets/Images/Login_Page/Login_Image.png",
              //   height: 450,
              //   alignment: Alignment.center,
              // ),
              SizedBox(
                height: 40,
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
                height: 250,
              ),
              Lottie.asset(
                "Assets/Animation/Splash_Screen/89023-loading-circles.json",
                height: 95,
              )
            ],
          ),
        ));
  }
}
