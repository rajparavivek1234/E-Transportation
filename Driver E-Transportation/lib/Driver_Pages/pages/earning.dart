// ignore_for_file: use_key_in_widget_constructors, camel_case_types, unnecessary_const, duplicate_ignore, prefer_const_literals_to_create_immutables, prefer_const_constructors, deprecated_member_use, unused_import, non_constant_identifier_names, sized_box_for_whitespace

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/drawer/navigationdrawerdriver.dart';
import 'package:myproject/Driver_Pages/pages/request_details.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:myproject/Driver_Pages/pages/withdraw.dart';

import 'home.dart';

class earning extends StatefulWidget {
  @override
  _earningState createState() => _earningState();
}

String Earning = "0";
String TotalEarning = "0";
String TotalWithdraw = "0";

class _earningState extends State<earning> {
  CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Earning",
        ),
        // ignore: unnecessary_const
      ),
      drawer: navigationDrawerDriver(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<DocumentSnapshot>(
              future: users.doc(id).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;

                  return Material(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 180,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(12),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    boxShadow: [
                                      const BoxShadow(
                                        offset: const Offset(0, 2),
                                        blurRadius: 5,
                                        color: Colors.blueAccent,
                                      )
                                    ]),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 20,
                                    right: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Rs.",
                                            // ignore: prefer_const_constructors
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              height: 0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            "${data['earning']}",
                                            // ignore: prefer_const_constructors
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 35,
                                              height: 1.5,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Your Earning",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 17,
                                          height: 1,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      withdraw()));
                                        },
                                        color: Colors.deepPurple,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50, vertical: 5),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          "WITHDRAW",
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            height: 320,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Driver")
                  .doc(id)
                  .collection('Transactions')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.size == 0) {
                  return Scaffold(body: Center(child: Text("No Transections")));
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListView(
                      children: snapshot.data!.docs
                          .map(
                            (doc) => Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 8),
                              child: Card(
                                borderOnForeground: true,
                                elevation: 4,
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${doc['Name']}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${doc['Method']}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      doc['Status'] == "Widrawed"
                                          ? Text(
                                              " - ${doc['Ammount']}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    doc['Status'] == "Widrawed"
                                                        ? Colors.red
                                                        : Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              " + ${doc['Ammount']}",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color:
                                                    doc['Status'] == "Widrawed"
                                                        ? Colors.red
                                                        : Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  );
                }
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}

// void transections() {
//   Text("=============================================");
//   // StreamBuilder<QuerySnapshot>(
//   //   stream: FirebaseFirestore.instance
//   //       .collection("Driver")
//   //       .doc(id)
//   //       .collection('Payment')
//   //       .snapshots(),
//   //   builder: (context, snapshot) {
//   //     if (!snapshot.hasData) {
//   //       return Center(
//   //         child: CircularProgressIndicator(),
//   //       );
//   //     }
//   //     if (snapshot.data!.size == 0) {
//   //       return Scaffold(body: Center(child: Text("No Transection")));
//   //     } else {
//   //       return Padding(
//   //         padding: const EdgeInsets.only(top: 10),
//   //         child: ListView(
//   //           children: snapshot.data!.docs
//   //               .map(
//   //                 (doc) => Padding(
//   //                   padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
//   //                   child: Card(
//   //                     borderOnForeground: true,
//   //                     elevation: 4,
//   //                     child: ListTile(
//   //                       title: Text(doc["UserFirstName"] ?? ""),

//   //                       // leading: CircleAvatar(
//   //                       //   radius: 25.0,
//   //                       //   //backgroundImage: NetworkImage(doc["User Img"]),
//   //                       //   backgroundColor: Colors.transparent,
//   //                       // ),
//   //                       // onTap: () {
//   //                       //   // hid = doc.id;
//   //                       //   // print(hid);
//   //                       //   // Navigator.of(context).push(
//   //                       //   //   MaterialPageRoute(
//   //                       //   //       builder: (context) => history_request(
//   //                       //   //             hid: hid,
//   //                       //   //           )),
//   //                       //   // );
//   //                       // },
//   //                       // subtitle: Text(
//   //                       //     '${doc['Starting Point']} ~> ${doc['Destination Point']}'),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               )
//   //               .toList(),
//   //         ),
//   //       );
//   //     }
//   //   },
//   // );
// }
