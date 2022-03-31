import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/WidrawRequest/WidrawRequestDetails.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';

import '../../Utils/routes.dart';

class WidrawRequestList extends StatefulWidget {
  const WidrawRequestList({Key? key}) : super(key: key);

  @override
  State<WidrawRequestList> createState() => _WidrawRequestListState();
}

class _WidrawRequestListState extends State<WidrawRequestList> {
  final db = FirebaseFirestore.instance;
  String wrid = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacementNamed(context, MyRoutes.AdminDashboard);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Widraw Request",
          ),
        ),
        drawer: navigationDrawerAdmin(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Payment Request')
              .where("Status", isEqualTo: "0")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(
                  body: Center(child: Text("No widraw request")));
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
                                doc["driver name"] ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(doc["Driver Image"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                wrid = doc.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WidrawRequestDetails(
                                            wrid: wrid, drid: doc["Driver ID"]),
                                  ),
                                );
                              },
                              subtitle: Text(
                                "Widraw request Amount:${doc["Withdraw Ammount"]}",
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
    );
  }
}
