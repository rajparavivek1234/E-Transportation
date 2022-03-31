import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:myproject/User_Pages/MyHistory/MyHistoryDetails.dart';
import 'package:myproject/User_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHistory extends StatefulWidget {
  @override
  State<MyHistory> createState() => _MyHistoryState();
}

class _MyHistoryState extends State<MyHistory> {
  String histId = "";
  final db = FirebaseFirestore.instance;

  String? MyUserID;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  @override
  Widget build(BuildContext context) {
    print(MyUserID);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, MyRoutes.homeRoute);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My History",
          ),
        ),
        drawer: navigationDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('History')
              .where("User ID", isEqualTo: MyUserID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(body: Center(child: Text("No History")));
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
                            child: new ListTile(
                              title: new Text(
                                doc["Driver First Name"] ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                  doc["Driver Img"],
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                histId = doc.id;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => MyHistoryDetails(
                                      histID: histId,
                                    ),
                                  ),
                                );
                              },
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
    );
  }
}
