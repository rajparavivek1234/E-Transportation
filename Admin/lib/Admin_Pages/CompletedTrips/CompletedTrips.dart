import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/CompletedTrips/CompletedTripDetails.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';

class CompletedTrips extends StatefulWidget {
  @override
  State<CompletedTrips> createState() => _CompletedTripsState();
}

class _CompletedTripsState extends State<CompletedTrips> {
  final db = FirebaseFirestore.instance;

  String histID = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacementNamed(context, MyRoutes.AdminDashboard);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My History",
            // ignore: unnecessary_const
          ),
        ),
        drawer: navigationDrawerAdmin(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('History').snapshots(),
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 8),
                          child: Card(
                            borderOnForeground: true,
                            elevation: 4,
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "User:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(doc["User First Name"] ?? ""),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(doc["User Last Name"] ?? ""),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Driver:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(doc["Driver First Name"] ?? ""),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(doc["Driver Last Name"] ?? ""),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                histID = doc.id;
                                print(histID);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CompletedTripDetails(
                                      histID: histID,
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
      ),
    );
  }
}
