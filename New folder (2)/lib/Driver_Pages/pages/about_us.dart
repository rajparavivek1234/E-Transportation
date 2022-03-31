// ignore_for_file: unnecessary_const, deprecated_member_use, camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';

import 'home.dart';

class about_us extends StatefulWidget {
  @override
  _about_usState createState() => _about_usState();
}

class _about_usState extends State<about_us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About Us",
        ),
        leading: IconButton(
          // ignore: prefer_const_constructors
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home()));
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(
          left: 16,
          top: 15,
          right: 16,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
          // child: ListView(
          //   children: [
          //     Text(""),
          //    RaisedButton(
          //         onPressed: () {
          //           Navigator.push(context,
          //               MaterialPageRoute(builder: (context) => home()));
          //         },
          //         color: Colors.deepPurple,
          //         padding: const EdgeInsets.symmetric(horizontal: 50),
          //         elevation: 2,
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20)),
          //         // ignore: prefer_const_constructors
          //         child: Text(
          //           "Back",
          //           style: const TextStyle(
          //               fontSize: 14, letterSpacing: 2.2, color: Colors.white),
          //         ),
          //       ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
