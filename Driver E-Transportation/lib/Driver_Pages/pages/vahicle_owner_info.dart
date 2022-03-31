// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable, body_might_complete_normally_nullable, unused_import, import_of_legacy_library_into_null_safe, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:progress_dialog/progress_dialog.dart';

class vahicle_owner_info extends StatefulWidget {
  String? myentryid1;
  vahicle_owner_info({Key? key, this.myentryid1}) : super(key: key);
  @override
  _vahicle_owner_infoState createState() => _vahicle_owner_infoState();
}

String? of;
String? ol;
String? oa;
String? oc;
String? os;
String? om;

class _vahicle_owner_infoState extends State<vahicle_owner_info> {
  CollectionReference User =
      FirebaseFirestore.instance.collection('vahicle_owner_info');

  String? myentryid1;

  TextEditingController _FirstNamecontroller = TextEditingController();
  TextEditingController _LastNamecontroller = TextEditingController();
  TextEditingController _MobileNocontroller = TextEditingController();
  TextEditingController _Addresscontroller = TextEditingController();
  TextEditingController _Address1controller = TextEditingController();
  TextEditingController _Citycontroller = TextEditingController();
  TextEditingController _Statecontroller = TextEditingController();

  var firebaseInstance;
  final _formKey = GlobalKey<FormState>();
  //Future<void> uploadPic() async {

  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vehicle Owner Details",
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  of = value;
                },
                controller: _FirstNamecontroller,
                decoration: const InputDecoration(
                  labelText: "First Name",
                  hintText: "ex:jay",
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "First Name Can't be Empty.";
                  } else if (!RegExp(r"^[a-zA-Z]+|\s").hasMatch(value)) {
                    return "Enter Correct First Name";
                  }
                  null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  ol = value;
                },
                controller: _LastNamecontroller,
                decoration: const InputDecoration(
                  labelText: "Last Name ",
                  hintText: "Ex. patel",
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Last Name Can't be Empty.";
                  } else if (!RegExp(r"^[a-zA-Z]+|\s").hasMatch(value)) {
                    return "Enter Correct Last Name";
                  }
                  null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  om = value;
                },
                controller: _MobileNocontroller,
                decoration: const InputDecoration(
                  labelText: "Mobile  No. ",
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
                  oa = value;
                },
                controller: _Addresscontroller,
                decoration: const InputDecoration(
                  labelText: "Address ",
                  hintText: "Ex. 321 , krishna so",
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "Address Can't be Empty.";
                  } else if (!RegExp(r"^[a-zA-Z,]+|\s").hasMatch(value)) {
                    return "Enter Correct Address";
                  }
                  null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  oc = value;
                },
                controller: _Citycontroller,
                decoration: const InputDecoration(
                  labelText: "City ",
                  hintText: "Ex. Nadiad",
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "City Can't be Empty.";
                  } else if (!RegExp(r"^[a-zA-Z,]+|\s").hasMatch(value)) {
                    return "Enter Correct City";
                  }
                  null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  os = value;
                },
                controller: _Statecontroller,
                decoration: const InputDecoration(
                  labelText: "State ",
                  hintText: "Ex. Gujrat",
                ),
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return "State Can't be Empty.";
                  } else if (!RegExp(r"^[a-zA-Z,]+|\s").hasMatch(value)) {
                    return "Enter Correct State";
                  }
                  null;
                },
              ),
            ),
            SizedBox(
              height: 160,
            ),
            InkWell(
              onTap: () async {
                ProgressDialog pr = ProgressDialog(context);
                if (_formKey.currentState!.validate()) {
                  pr.show();
                  await FirebaseFirestore.instance
                      .collection("Driver")
                      .doc(MyDriverID)
                      .update({
                    'Owner Of Vehicle': 'No',
                    'Owner First Name': of,
                    'Owner Last Name': ol,
                    'Owner Mobile No': om,
                    'Owner Address': oa,
                    'Owner City': oc,
                    'Owner State': os,
                  });
                  pr.hide().whenComplete(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              vahicle_info(myentryid1: myentryid1)),
                    );
                  });
                }
              },
              child: AnimatedContainer(
                duration: Duration(seconds: 2),
                width: 330,
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  "Submit",
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
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}









// // ignore_for_file: camel_case_types, prefer_const_constructors, use_key_in_widget_constructors, deprecated_member_use, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:testing/pages/dando_document.dart';
// import 'package:testing/pages/driver_info.dart';

// class vahicle_owner_info extends StatefulWidget {
//   String? myentryid1;
//   vahicle_owner_info({Key? key, this.myentryid1}) : super(key: key);
//   @override
//   _vahicle_owner_infoState createState() => _vahicle_owner_infoState();
// }

// class _vahicle_owner_infoState extends State<vahicle_owner_info> {
//   bool showPassword = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(
//           left: 16,
//           top: 25,
//           right: 16,
//         ),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               Text(
//                 "Edit Vahicle Owner Detail",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               buildTextField("First Name", "Ex. jay", false),
//               buildTextField("Last Name", "Ex. patel", false),
//               buildTextField("Mobile No,", "Ex. 00000 00000", false),
//               buildTextField("Address", "Ex. 301 , aster ", false),
//               buildTextField("Address1", "Ex. Collage road", false),
//               buildTextField("City", "Ex. Nadiad", false),
//               buildTextField("State", "Ex. Gujrat", false),
//               SizedBox(
//                 height: 5,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlineButton(
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => driver_info()));
//                     },
//                     child: Text("BACK",
//                         style: TextStyle(
//                             fontSize: 14,
//                             letterSpacing: 2.2,
//                             color: Colors.black)),
//                   ),
//                   RaisedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => dando_document()));
//                     },
//                     color: Colors.deepPurple,
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text(
//                       "NEXT",
//                       style: TextStyle(
//                           fontSize: 14,
//                           letterSpacing: 2.2,
//                           color: Colors.white),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       String labelText, String placeholder, bool isPasswordTextField) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 35.0),
//       child: TextField(
//         obscureText: isPasswordTextField ? showPassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField
//                 ? IconButton(
//                     onPressed: () {
//                       setState(() {
//                         showPassword = !showPassword;
//                       });
//                     },
//                     icon: Icon(
//                       Icons.remove_red_eye,
//                       color: Colors.grey,
//                     ),
//                   )
//                 : null,
//             contentPadding: EdgeInsets.only(bottom: 3),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placeholder,
//             hintStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             )),
//       ),
//     );
//   }
// }
