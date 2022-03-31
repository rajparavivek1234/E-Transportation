import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfNotOwner/DriverItselfNotOwnerDetails.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfOwner/DriverselfOwerDetails.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';

class Drivers extends StatefulWidget {
  @override
  State<Drivers> createState() => _DriversState();
}

class _DriversState extends State<Drivers> {
  final db = FirebaseFirestore.instance;

  String id = "";
  String url = "";

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
            "Drivers",
          ),
        ),
        drawer: navigationDrawerAdmin(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Driver')
              .where("Approved", isEqualTo: "1")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(body: Center(child: Text("No Driver")));
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
                              title: Row(
                                children: [
                                  Text(
                                    doc["First Name"] ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    doc["Last Name"] ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(doc["Driver Image"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                if (doc["Owner Of Vehicle"] == "Yes") {
                                  id = doc.id;
                                  print(id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Driver_ItSelf_Owner_Details(id: id),
                                    ),
                                  );
                                } else if (doc["Owner Of Vehicle"] == "No") {
                                  id = doc.id;
                                  print(id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Driver_ItSelf_Not_Owner_Details(
                                              id: id),
                                    ),
                                  );
                                }
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
