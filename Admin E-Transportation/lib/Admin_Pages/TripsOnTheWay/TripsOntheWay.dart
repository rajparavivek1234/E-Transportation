import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/TripsOnTheWay/OnTripDetails.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';

import '../../Utils/routes.dart';

class TripsOnTheWay extends StatefulWidget {
  @override
  State<TripsOnTheWay> createState() => _TripsOnTheWayState();
}

class _TripsOnTheWayState extends State<TripsOnTheWay> {
  final db = FirebaseFirestore.instance;

  String id = "";
  String url = "";
  String tid = "";

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
            "Trips On The Way",
          ),
        ),
        drawer: navigationDrawerAdmin(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Driver')
              .where("On Trip", isEqualTo: "Yes")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(body: Center(child: Text("No trip")));
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
                                doc["First Name"] ?? "",
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
                                tid = doc.id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        OnTripDetails(tid: tid),
                                  ),
                                );
                              },
                              subtitle: Text(doc["Owner Of Vehicle"] == "Yes"
                                  ? "Driver itself owner"
                                  : "Driver itself not owner"),
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
