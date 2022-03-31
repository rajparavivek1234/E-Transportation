// ignore_for_file: camel_case_types, use_key_in_widget_constructors, deprecated_member_use, prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/drawer/navigationdrawerdriver.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/v_upload_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

import 'home.dart';

class v_update_document extends StatefulWidget {
  @override
  _v_update_documentState createState() => _v_update_documentState();
}

class _v_update_documentState extends State<v_update_document> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Vahicle Document",
        ),
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      drawer: navigationDrawerDriver(),
      body: Container(
        padding: const EdgeInsets.only(
          left: 5,
          top: 10,
          right: 5,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              // Center(
              //   // ignore: sized_box_for_whitespace
              //   child: Container(
              //     height: 70,
              //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //     child: RaisedButton(
              //       onPressed: () {},
              //       color: Theme.of(context).accentColor,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         // ignore: prefer_const_literals_to_create_immutables
              //         children: <Widget>[
              //           Text(
              //             'RC Book',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.white,
              //             ),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios_rounded,
              //             color: Colors.white,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                // ignore: sized_box_for_whitespace
                child: Container(
                  height: 70,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 2;
                      document = 'PUC';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: vid,
                            myentryid2: id,
                          ),
                        ),
                      );
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
                  height: 70,
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: RaisedButton(
                    onPressed: () {
                      page = 2;
                      document = 'Insurance Policy';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => v_upload_document(
                            myentryid1: vid,
                            myentryid2: id,
                          ),
                        ),
                      );
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
              // Center(
              //   // ignore: sized_box_for_whitespace
              //   child: Container(
              //     height: 70,
              //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //     child: RaisedButton(
              //       onPressed: () {},
              //       color: Theme.of(context).accentColor,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         // ignore: prefer_const_literals_to_create_immutables
              //         children: <Widget>[
              //           Text(
              //             'Ragistration Document',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.white,
              //             ),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios_rounded,
              //             color: Colors.white,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // Center(
              //   // ignore: sized_box_for_whitespace
              //   child: Container(
              //     height: 70,
              //     padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              //     child: RaisedButton(
              //       onPressed: () {},
              //       color: Theme.of(context).accentColor,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         // ignore: prefer_const_literals_to_create_immutables
              //         children: <Widget>[
              //           Text(
              //             'Permission Document',
              //             style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.w700,
              //               color: Colors.white,
              //             ),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios_rounded,
              //             color: Colors.white,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 25,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     RaisedButton(
              //       onPressed: () {
              //         Navigator.push(context,
              //             MaterialPageRoute(builder: (context) => home()));
              //       },
              //       color: Colors.deepPurple,
              //       padding: const EdgeInsets.symmetric(horizontal: 50),
              //       elevation: 2,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(20)),
              //       child: const Text(
              //         "BACK",
              //         style: TextStyle(
              //             fontSize: 14,
              //             letterSpacing: 2.2,
              //             color: Colors.white),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
