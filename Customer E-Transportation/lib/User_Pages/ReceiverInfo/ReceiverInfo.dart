import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/OTP.dart';
import 'package:myproject/User_Pages/SelectVehicle/SelectVehicle.dart';
import 'package:myproject/Utils/routes.dart';

class ReceiverInfo extends StatefulWidget {
  String? Source;
  String? Destination;
  String? Distance;
  ReceiverInfo({Key? key, this.Source, this.Destination, this.Distance})
      : super(key: key);

  @override
  _ReceiverInfoState createState() => _ReceiverInfoState();
}

String? Receiver_Mobile_No;
String? Receiver_Dial_code;
String? Receiver_firstname;
String? Receiver_lastname;

class _ReceiverInfoState extends State<ReceiverInfo> {
  bool clickButton = false;
  String name = "";
  final _formkey = GlobalKey<FormState>();
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
  TextEditingController _Namecontroller = TextEditingController();

  bool changestate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Receiver's Information"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "First Name",
                    hintText: "Enter receiver's First Name",
                  ),
                  validator: (String? value) {
                    Receiver_firstname = value;
                    if (value!.isEmpty) {
                      return "First Name can't be empty";
                    }
                    null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    hintText: "Enter receiver's Last Name",
                  ),
                  validator: (String? value) {
                    Receiver_lastname = value;
                    if (value!.isEmpty) {
                      return "Last Name can't be empty";
                    }
                    null;
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: TextFormField(
                    onChanged: (value) {
                      number = value;
                      setState(() {});
                      changestate = true;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Enter Phone Number",
                      suffixIcon: changestate
                          ? Image.network(
                              'https://img.icons8.com/ios-glyphs/20/000000/checked--v2.png',
                              color: Colors.green,
                            )
                          : null,
                      prefixIcon: countrypicker(),
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Phone no. can't be empty";
                      }
                      null;
                    },
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    controller: controller,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  Receiver_Dial_code = dialCodeDigits;
                  Receiver_Mobile_No = number;
                  if (_formkey.currentState!.validate()) {
                    setState(() {
                      name = _Namecontroller.text;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Select_Vehicle(
                            Source: widget.Source,
                            Destination: widget.Destination,
                            Distance: widget.Distance),
                      ),
                    );
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: 330,
                  height: 50,
                  alignment: Alignment.center,
                  child: clickButton
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
