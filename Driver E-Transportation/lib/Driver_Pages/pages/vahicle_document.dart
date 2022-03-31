// ignore_for_file: deprecated_member_use, camel_case_types, must_be_immutable, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, unused_local_variable

import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/v_upload_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class vahicle_document extends StatefulWidget {
  String? myentryid1;
  vahicle_document({Key? key, this.myentryid1}) : super(key: key);
  @override
  _vahicle_documentState createState() => _vahicle_documentState();
}

String? rcbook;
String? puc;
String? ip;
String? rd;
int f1 = 0, g1 = 0, h1 = 0, i1 = 0;

class _vahicle_documentState extends State<vahicle_document> {
  @override
  Widget build(BuildContext context) {
    String? myentryid1 = vid;
    String? myentryid2 = id;
    print(myentryid1);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            'Upload Vehicle Document',
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
          padding: const EdgeInsets.only(
            left: 5,
            top: 10,
            right: 5,
          ),
          child: Column(
            children: [
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 1;
                      document = 'RC Book';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: myentryid1,
                            myentryid2: myentryid2,
                          ),
                        ),
                      );
                      rcbook = link;
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'RC Book',
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 1;
                      document = 'PUC';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: myentryid1,
                            myentryid2: myentryid2,
                          ),
                        ),
                      );
                      puc = link;
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'PUC',
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 1;
                      document = 'Insurance Policy';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: myentryid1,
                            myentryid2: myentryid2,
                          ),
                        ),
                      );
                      ip = link;
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Insurance Policy',
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 1;
                      document = 'Ragistration Document';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: myentryid1,
                            myentryid2: myentryid2,
                          ),
                        ),
                      );
                      rd = link;
                    },
                    color: Theme.of(context).accentColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Text(
                          'Ragistration Document',
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
                height: 340,
              ),
              InkWell(
                onTap: () async {
                  if (f1 == 1 && g1 == 1 && h1 == 1 && i1 == 1) {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("isDetailsAdded", "Yes");
                    await prefs.setString("is_Open", "Yes");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => home()),
                    );
                  } else if (f1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your RC Book"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (g1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your PUC"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (h1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload your Insurance Policy"),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else if (i1 == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Please upload your Ragistration Document"),
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









// // ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:testing/pages/home.dart';
// import 'package:testing/pages/vahicle_info.dart';

// class vahicle_documents extends StatefulWidget {
//   @override
//   _vahicle_documentsState createState() => _vahicle_documentsState();
// }

// class _vahicle_documentsState extends State<vahicle_documents> {
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
//                   height: 70,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'RC Book',
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
//                   height: 70,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'PUC',
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
//                   height: 70,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Insurance Policy',
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
//                   height: 70,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Ragistration Document',
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
//                   height: 70,
//                   padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
//                   child: RaisedButton(
//                     onPressed: () {},
//                     color: Theme.of(context).accentColor,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: <Widget>[
//                         Text(
//                           'Permission Document',
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
//                               builder: (context) => vahicle_info()));
//                     },
//                     child: const Text("BACK",
//                         style: TextStyle(
//                             fontSize: 14,
//                             letterSpacing: 2.2,
//                             color: Colors.black)),
//                   ),
//                   RaisedButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => home()));
//                     },
//                     color: Colors.deepPurple,
//                     padding: const EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: const Text(
//                       "SUBMIT",
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
// }
