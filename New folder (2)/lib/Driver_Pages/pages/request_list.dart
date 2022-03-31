// ignore_for_file: prefer_const_constructors, avoid_print, camel_case_types, use_key_in_widget_constructors, duplicate_ignore, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/accept_request.dart';
import 'package:myproject/Driver_Pages/pages/complete_order.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/request_details.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class request_list extends StatefulWidget {
  @override
  State<request_list> createState() => _request_listState();
}

String rid = "";

class _request_listState extends State<request_list> {
  final db = FirebaseFirestore.instance;

  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Trip Requests",
          // ignore: unnecessary_const
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('Driver')
            .doc(id)
            .collection('Request')
            .where("On Trip", isEqualTo: "No")
            .where("Order Completed", isEqualTo: "No")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return Scaffold(body: Center(child: Text("No Request")));
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: snapshot.data!.docs
                    .map(
                      (doc) => Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 8),
                        child: Card(
                          borderOnForeground: true,
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              doc["First Name"] ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(doc["Profile pic"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () async {
                              //step = "1";
                              rid = doc.id;
                              // await FirebaseFirestore.instance
                              //     .collection('Driver')
                              //     .doc(id)
                              //     .collection("Request")
                              //     .doc(rid)
                              //     .update({
                              //   //'Step': step,
                              // });
                              print(rid);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => request_details(
                                    rid: rid,
                                  ),
                                ),
                              );
                            },
                            subtitle: Text(
                                '${doc['Starting Point']} ~> ${doc['Destination Point']}'),
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
    );
  }
}
