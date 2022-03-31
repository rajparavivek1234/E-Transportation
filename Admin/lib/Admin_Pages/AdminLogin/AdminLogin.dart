import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Admin_Login_Page extends StatefulWidget {
  const Admin_Login_Page({Key? key}) : super(key: key);

  @override
  State<Admin_Login_Page> createState() => _Admin_Login_PageState();
}

String? LogInid;

class _Admin_Login_PageState extends State<Admin_Login_Page> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  double getSmallDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 2 / 3;

  double getBiglDiameter(BuildContext context) =>
      MediaQuery.of(context).size.width * 7 / 8;

  String password = "";
  String conformpassword = "";
  String email = "";
  bool PassShow = true;
  bool confirmPassShow = true;

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

  void checkiflogin() async {
    String? login;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    login = prefs.getString("Login");
    print("ID${login}");
    if (login != null) {
      Navigator.pushNamed(context, MyRoutes.AdminDashboard);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkiflogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEEEEEE),
      body: Form(
        key: _formkey,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: -getSmallDiameter(context) / 3,
              top: -getSmallDiameter(context) / 3,
              child: Container(
                width: getSmallDiameter(context),
                height: getSmallDiameter(context),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFFB226B2),
                          Color.fromARGB(255, 38, 163, 236)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
              ),
            ),
            Positioned(
              left: -getBiglDiameter(context) / 4,
              top: -getBiglDiameter(context) / 3.6,
              child: Container(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50, top: 40),
                    child: Text(
                      "E Transportation",
                      style: GoogleFonts.greatVibes(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                width: getBiglDiameter(context),
                height: getBiglDiameter(context),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB226B2),
                      Color.fromARGB(255, 102, 26, 243)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -getBiglDiameter(context) / 1.5,
              bottom: -getBiglDiameter(context) / 1.5,
              child: Container(
                width: getBiglDiameter(context),
                height: getBiglDiameter(context),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 245, 212, 229)),
              ),
            ),
            Positioned(
              left: -getBiglDiameter(context) / 4,
              bottom: -getBiglDiameter(context) / 6,
              child: Container(
                width: getBiglDiameter(context),
                height: getBiglDiameter(context),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 236, 212, 245)),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 5,
                            blurRadius: 13,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        //border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30)),
                    margin: const EdgeInsets.fromLTRB(20, 240, 20, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "A",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Text(
                              "dmin ",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            Text(
                              "L",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            Text(
                              "ogin",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                          child: TextFormField(
                            onChanged: (value) {
                              email = value;
                            },
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "Enter Admin email",
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
                              hintText: "Enter Admin Password",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: InkWell(
                                onTap: _showPassword,
                                child: Icon(
                                  PassShow
                                      ? Icons.visibility
                                      : Icons.visibility_off,
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
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: 40,
                                child: Container(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      splashColor: Colors.amber,
                                      onTap: () async {
                                        ProgressDialog pr =
                                            ProgressDialog(context);

                                        if (_formkey.currentState!.validate()) {
                                          setState(() {
                                            email = _emailController.text;
                                            password = _passwordController.text;
                                          });
                                          if (email == "prajapatinehansh1@gmail.com" ||
                                              email ==
                                                  "pateltrushil046@gmail.com" ||
                                              email ==
                                                  "rajparavivek1234@gmail.com") {
                                            if (password == "NTV@123") {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setString("Email", email);
                                              prefs.setString("Login", "Yes");
                                              prefs.setString("is_Open", "Yes");
                                              Navigator.pushNamed(context,
                                                  MyRoutes.AdminDashboard);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      "Admin Password is incorrect."),
                                                  backgroundColor: Colors.black,
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Enter correct Admin Email."),
                                                backgroundColor: Colors.black,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Sign in",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        spreadRadius: 1,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 2), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 139, 48, 243),
                                        Color.fromARGB(255, 160, 58, 228)
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
