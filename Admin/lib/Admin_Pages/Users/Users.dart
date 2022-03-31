import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Users/Business_User_DetailsPage.dart';
import 'package:myproject/Admin_Pages/Users/NonBusiness_User_Details.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';

import '../../Utils/routes.dart';

class Users extends StatefulWidget {
  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
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
            "Users",
          ),
        ),
        drawer: navigationDrawerAdmin(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('Users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(body: Center(child: Text("No user")));
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
                                backgroundImage: NetworkImage(doc["url"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () {
                                if (doc["Type"] == "Business") {
                                  id = doc.id;
                                  print(id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Business_UserDetails(id: id),
                                    ),
                                  );
                                } else if (doc["Type"] == "NonBusiness") {
                                  id = doc.id;
                                  print(id);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NonBusiness_UserDetails(id: id),
                                    ),
                                  );
                                }
                              },
                              subtitle: Text('${doc["Type"]}'),
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
