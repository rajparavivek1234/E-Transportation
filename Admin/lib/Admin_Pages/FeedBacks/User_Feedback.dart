import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfOwner/DriverselfOwerDetails.dart';

class User_Feedback extends StatefulWidget {
  @override
  State<User_Feedback> createState() => _User_Feedback_OwnerState();
}

class _User_Feedback_OwnerState extends State<User_Feedback> {
  final db = FirebaseFirestore.instance;

  String id = "";
  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('User Feedback').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return new Scaffold(body: Center(child: Text("No User Feedback")));
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
                              backgroundImage: NetworkImage(doc["Profile pic"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () {},
                            subtitle: Text(
                              'Rating:${doc['Rating']}\nMessage:${doc['Message']}',
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
    );
  }
}
