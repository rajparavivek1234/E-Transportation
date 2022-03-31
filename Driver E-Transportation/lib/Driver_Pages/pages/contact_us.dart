// ignore_for_file: camel_case_types, use_key_in_widget_constructors, deprecated_member_use, non_constant_identifier_names, prefer_final_fields, unused_field, unused_import, body_might_complete_normally_nullable

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';

class contact_us extends StatefulWidget {
  @override
  _contact_usState createState() => _contact_usState();
}

class _contact_usState extends State<contact_us> {
  bool showPassword = false;
  String? name;
  String? mobileno;
  String? email;
  String? query;
  String? myentryid1;

  TextEditingController _Namecontroller = TextEditingController();
  TextEditingController _MobileNocontroller = TextEditingController();
  TextEditingController _Emailcontroller = TextEditingController();
  TextEditingController _Querycontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
        ),
        // ignore: unnecessary_const

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => home()));
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.only(
            left: 16,
            top: 15,
            right: 16,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    controller: _Namecontroller,
                    decoration: const InputDecoration(
                      labelText: "Name ",
                      hintText: "Ex. patel",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Name Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z]+|\s").hasMatch(value)) {
                        return "Enter Correct Name";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      mobileno = value;
                    },
                    controller: _MobileNocontroller,
                    decoration: const InputDecoration(
                      labelText: "Mobile No. ",
                      hintText: "Ex. 00000 00000",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Mobile No. Can't be Empty.";
                      } else if (!RegExp(r"[0-9]{10}").hasMatch(value)) {
                        return "Enter Correct Mobile No.";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    controller: _Emailcontroller,
                    decoration: const InputDecoration(
                      labelText: "E-mail ",
                      hintText: "Ex. Abcd00@gmail.com",
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
                      query = value;
                    },
                    controller: _Querycontroller,
                    decoration: const InputDecoration(
                      labelText: "What is Your Query? ",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Query Can't be Empty.";
                      }
                      Null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                // OutlineButton(
                //   padding: EdgeInsets.symmetric(horizontal: 50),
                //   shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20)),
                //   onPressed: () {},
                //   child: Text("CANCEL",
                //       style: TextStyle(
                //           fontSize: 14,
                //           letterSpacing: 2.2,
                //           color: Colors.black)),
                // ),

                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await FirebaseFirestore.instance.collection("Query").add({
                        'Name': name,
                        'Mobile No.': mobileno,
                        'E-mail': email,
                        'Query': query,
                      }).then((value) {
                        //print(value.id);
                        myentryid1 = value.id;
                        //print(myentryid);
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => home()));
                    }
                  },
                  color: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    "SEND",
                    style: TextStyle(
                        fontSize: 16, letterSpacing: 2.2, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
