import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Utils/routes.dart';

class Forgot_password extends StatefulWidget {
  @override
  State<Forgot_password> createState() => _Forgot_passwordState();
}

class _Forgot_passwordState extends State<Forgot_password> {
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool clickButton = false;

  moveToNext(BuildContext context) async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      setState(() {
        clickButton = true;
      });

      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);

      setState(() {
        clickButton = false;
      });
    }
  }

  TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Forgot password"),
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Image.asset(
              "Assets/Images/Forgot_Paswword/Forgot_Pasword.png",
              scale: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Email",
                  prefixIcon: Icon(
                    Icons.mail,
                  ),
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Username can't be empty";
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
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _email.text)
                    .then((value) {
                  Navigator.pushNamed(context, MyRoutes.loginRoute);
                });
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 1),
                width: clickButton ? 50 : 380,
                height: 50,
                alignment: Alignment.center,
                child: clickButton
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                      )
                    : Text(
                        "Reset password",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(clickButton ? 20 : 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
