// ignore_for_file: deprecated_member_use, camel_case_types, must_be_immutable, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

import 'upload_document.dart';

class driver_document extends StatefulWidget {
  String? myentryid1;
  driver_document({Key? key, this.myentryid1}) : super(key: key);
  @override
  _driver_documentState createState() => _driver_documentState();
}

int a1 = 0, b1 = 0, c1 = 0;
int page = 0;

class _driver_documentState extends State<driver_document> {
  String? myentryid1;
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
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 1;
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
                      page = 1;
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
                      page = 1;
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
              SizedBox(height: 420),
              InkWell(
                onTap: () async {
                  if (a1 == 1 && b1 == 1 && c1 == 1) {
                    await FirebaseFirestore.instance
                        .collection('vehicle')
                        .doc(vid)
                        .update({
                      'Driver Id': id,
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              vahicle_document(myentryid1: myentryid1)),
                    );
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


























// // ignore_for_file: use_key_in_widget_constructors, camel_case_types, deprecated_member_use, unnecessary_const, prefer_const_constructors, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:testing/pages/driver_info.dart';
// import 'package:testing/pages/vahicle_info.dart';

// class driver_document extends StatefulWidget {
//   String? myentryid1;
//   driver_document({Key? key, this.myentryid1}) : super(key: key);
//   @override
//   _driver_documentState createState() => _driver_documentState();
// }

// class _driver_documentState extends State<driver_document> {
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
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlineButton(
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => driver_info()));
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







// Center(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(10, 15, 10, 500),
//                   child: Container(
//                     height: 75,
//                     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                     child: RaisedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => driver_upload_document(
//                                 myentryid1: widget.myentryid1),
//                           ),
//                         );
//                       },
//                       color: Theme.of(context).accentColor,
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             // ignore: prefer_const_literals_to_create_immutables

//                             children: <Widget>[
//                               Column(
//                                 children: [
//                                   SizedBox(
//                                     height: 18,
//                                   ),
//                                   Text(
//                                     'Aadhar Card',
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.w700,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 ],
//                               ),
//                               Icon(
//                                 Icons.arrow_forward_ios_rounded,
//                                 color: Colors.white,
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),