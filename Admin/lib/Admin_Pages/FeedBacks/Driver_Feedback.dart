import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Driver_Feedback extends StatefulWidget {
  const Driver_Feedback({Key? key}) : super(key: key);

  @override
  _Driver_FeedbackState createState() => _Driver_FeedbackState();
}

class _Driver_FeedbackState extends State<Driver_Feedback> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Driver Feedback').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return new Scaffold(
                body: Center(child: Text("No Driver Feedback")));
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
