// ignore_for_file: prefer_const_constructors, avoid_print, camel_case_types, use_key_in_widget_constructors, duplicate_ignore, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/drawer/navigationdrawerdriver.dart';
import 'package:myproject/Driver_Pages/pages/history_request.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class history extends StatefulWidget {
  @override
  State<history> createState() => _historyState();
}

class _historyState extends State<history> {
  final db = FirebaseFirestore.instance;

  String hid = "";
  String url = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          // ignore: unnecessary_const
        ),
      ),
      drawer: navigationDrawerDriver(),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('History')
            .where("Driver ID", isEqualTo: id)
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
                            title: Text(doc["User First Name"] ?? ""),
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: NetworkImage(doc["User Img"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () {
                              hid = doc.id;
                              print(hid);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => history_request(
                                          hid: hid,
                                        )),
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






// // ignore_for_file: unnecessary_const, camel_case_types, use_key_in_widget_constructors, duplicate_ignore

// import 'package:flutter/material.dart';

// import 'home.dart';

// class history extends StatefulWidget {
//   @override
//   _historyState createState() => _historyState();
// }

// class _historyState extends State<history> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "History",
//           // ignore: unnecessary_const
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => home()));
//           },
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.only(
//           left: 16,
//           top: 15,
//           right: 16,
//         ),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 120,
//                     decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(12),
//                         // ignore: prefer_const_literals_to_create_immutables
//                         boxShadow: [
//                           const BoxShadow(
//                             offset: const Offset(0, 2),
//                             blurRadius: 5,
//                             color: Colors.blueAccent,
//                           )
//                         ]),
//                     child: Container(
//                       padding: const EdgeInsets.only(
//                         left: 10,
//                         top: 20,
//                         right: 10,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 // ignore: prefer_const_literals_to_create_immutables
//                                 children: [
//                                   const Text(
//                                     "      Name",
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                   const Text(
//                                     "       surat -> pune",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                   const Text(
//                                     "       192 km",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                   const Text(
//                                     "       Rs. 2021",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 120,
//                     decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(12),
//                         // ignore: prefer_const_literals_to_create_immutables
//                         boxShadow: [
//                           const BoxShadow(
//                             offset: Offset(0, 2),
//                             blurRadius: 5,
//                             color: Colors.blueAccent,
//                           )
//                         ]),
//                     child: Container(
//                       padding: const EdgeInsets.only(
//                         left: 10,
//                         top: 20,
//                         right: 10,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 // ignore: prefer_const_literals_to_create_immutables
//                                 children: [
//                                   const Text(
//                                     "      Name",
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                     ),
//                                   ),
//                                   const Text(
//                                     "       bhopal -> kolkatta",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                   const Text(
//                                     "       305 km",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                   const Text(
//                                     "       Rs. 5100",
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
