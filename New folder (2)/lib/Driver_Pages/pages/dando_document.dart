// ignore_for_file: deprecated_member_use, camel_case_types, must_be_immutable, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/upload_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class dando_document extends StatefulWidget {
  String? myentryid1;
  dando_document({Key? key, this.myentryid1}) : super(key: key);
  @override
  _dando_documentState createState() => _dando_documentState();
}

int d1 = 0, e1 = 0;

class _dando_documentState extends State<dando_document> {
  @override
  Widget build(BuildContext context) {
    print(widget.myentryid1);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            'Upload Your Document',
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: true,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      document = 'Aadhar Card';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              upload_document(myentryid1: widget.myentryid1),
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'AdharCard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      document = 'Address Proof';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              upload_document(myentryid1: widget.myentryid1),
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Address Proof',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      document = 'Licence';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              upload_document(myentryid1: widget.myentryid1),
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Licence',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      document = 'Owner Adharcard';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              upload_document(myentryid1: widget.myentryid1),
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Owner Adharcard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      document = 'Owner Address Proof';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              upload_document(myentryid1: widget.myentryid1),
                        ),
                      );
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Owner Address Proof',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 270,
              ),
              InkWell(
                onTap: () async {
                  if (a1 == 1 && b1 == 1 && c1 == 1 && d1 == 0 && e1 == 0) {
                    await FirebaseFirestore.instance
                        .collection('vehicle')
                        .doc(vid)
                        .update({
                      'Driver Id': id,
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => vahicle_document(
                                myentryid1: widget.myentryid1)));
                  } else if (a1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Aadhar Card"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (b1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Licence"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (c1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Address Proof"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (d1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Owner Adharcard"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (e1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Owner Address Proof"),
                        backgroundColor: Colors.black,
                      ),
                    );
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
            ],
          ),
        ),
      ),
    );
  }
}










// 
// // ignore_for_file: use_key_in_widget_constructors, camel_case_types, deprecated_member_use, unnecessary_const, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:testing/pages/vahicle_info.dart';
// import 'package:testing/pages/vahicle_owner_info.dart';

// class dando_document extends StatefulWidget {
//   String? myentryid1;
//   dando_document({Key? key, this.myentryid1}) : super(key: key);
//   @override
//   _dando_documentState createState() => _dando_documentState();
// }

// class _dando_documentState extends State<dando_document> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.only(
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
//               const Text(
//                 "Upload Documents",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               Center(
//                 // ignore: sized_box_for_whitespace
//                 child: Container(
//                   height: 75,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Your ID \n(AdharCard)',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 // ignore: sized_box_for_whitespace
//                 child: Container(
//                   height: 75,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Licence',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 // ignore: sized_box_for_whitespace
//                 child: Container(
//                   height: 75,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Address Proof \n(Electricity/Property Tax Bill)',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 // ignore: sized_box_for_whitespace
//                 child: Container(
//                   height: 75,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Vahicle Owner ID \n(AdharCard)',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Center(
//                 // ignore: sized_box_for_whitespace
//                 child: Container(
//                   height: 75,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Owner Address Proof \n(Electricity/Property Tax Bill)',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           color: Colors.white,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlineButton(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () {
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => vahicle_owner_info(
//                       //               myentryid1: 'myentryid1',
//                       //             )));
//                     },
//                     child: const Text("BACK",
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
//                               builder: (context) => vahicle_info()));
//                     },
//                     color: Colors.deepPurple,
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: const Text(
//                       "NEXT",
//                       style: const TextStyle(
//                           fontSize: 14,
//                           letterSpacing: 2.2,
//                           color: Colors.white),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
