// ignore_for_file: prefer_const_constructors, file_names, unused_local_variable, unused_import, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

String? driver_img;

Widget createDrawerHeader() {
  CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  return DrawerHeader(
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    child: FutureBuilder<DocumentSnapshot>(
      future: users.doc(id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          driver_img = data["Driver Image"];

          return Material(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogFunc(context, data["Driver Image"]);
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0,
                                  blurRadius: 20,
                                  color: Colors.black.withOpacity(0),
                                  offset: Offset(5, 15),
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                data["Driver Image"],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${data['First Name']} ${data['Last Name']}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${data['Email']}",
                    style: TextStyle(),
                  )
                ],
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    ),
    //Stack(
    //   children: <Widget>[
    //     Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Column(
    //           // ignore: prefer_const_literals_to_create_immutables
    //           children: [
    //             SizedBox(
    //               height: 20,
    //             ),
    //             CircleAvatar(
    //               backgroundColor: Colors.black,
    //               radius: 25,
    //               child: Icon(
    //                 Icons.person,
    //                 size: 35,
    //               ),
    //             ),
    //             SizedBox(
    //               height: 10,
    //             ),
    //             Text(
    //               "Abcd",
    //               style: TextStyle(fontSize: 20),
    //             ),
    //             SizedBox(
    //               height: 5,
    //             ),
    //             Text("abcd@gmail.com")
    //           ],
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
  );
}

showDialogFunc(context, img) {
  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            height: 400,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Driver Image",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 2,
                  width: 500,
                  color: Colors.black,
                ),
                SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    img,
                    width: 300,
                    height: 300,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
