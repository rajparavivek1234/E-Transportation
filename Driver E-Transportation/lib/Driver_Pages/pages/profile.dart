// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, annotate_overrides, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, duplicate_ignore, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/drawer/navigationdrawerdriver.dart';
import 'package:myproject/Driver_Pages/pages/edit%20_profile.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class profile extends StatelessWidget {
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Driver');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          // ignore: unnecessary_const
        ),
      ),
      drawer: navigationDrawerDriver(),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Material(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
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
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 4,
                                    blurRadius: 20,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(5, 15),
                                  )
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  data["Driver Image"],
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Name : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['First Name']} ${data['Last Name']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Date Of Birth : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['DOB']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Phone no : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['Phone no']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Eimail : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['Email']}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Address : ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${data['Address']} ${data['City']}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    SizedBox(
                      height: 120,
                    ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => edit_profile()),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
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
    );
  }
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





// // ignore_for_file: camel_case_types, use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:testing/pages/home.dart';

// class profile extends StatefulWidget {
//   @override
//   _profileState createState() => _profileState();
// }

// class _profileState extends State<profile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Profile",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 25,
//           ),
//         ),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         elevation: 1,
//         leading: IconButton(
//           // ignore: prefer_const_constructors
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.deepPurple,
//           ),
//           onPressed: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => home()));
//           },
//         ),
//       ),
//       body: Container(
//         padding: EdgeInsets.only(
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
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                               width: 4,
//                               color: Theme.of(context).scaffoldBackgroundColor),
//                           boxShadow: [
//                             BoxShadow(
//                                 spreadRadius: 2,
//                                 blurRadius: 10,
//                                 color: Colors.black.withOpacity(0.1),
//                                 offset: Offset(0, 10))
//                           ],
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                 "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
//                               ))),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 "profile picture",
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Name",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 30,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Contact No",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 30,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "E-mail",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 30,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Address",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 30,
//                 ),
//               ),
//               SizedBox(
//                 height: 200,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   // OutlineButton(
//                   //   padding: EdgeInsets.symmetric(horizontal: 50),
//                   //   shape: RoundedRectangleBorder(
//                   //       borderRadius: BorderRadius.circular(20)),
//                   //   onPressed: () {},
//                   //   child: Text("CANCEL",
//                   //       style: TextStyle(
//                   //           fontSize: 14,
//                   //           letterSpacing: 2.2,
//                   //           color: Colors.black)),
//                   // ),
//                   RaisedButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => home()));
//                     },
//                     color: Colors.deepPurple,
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text(
//                       "Back",
//                       style: TextStyle(
//                           fontSize: 14,
//                           letterSpacing: 2.2,
//                           color: Colors.white),
//                     ),
//                   ),
//                   RaisedButton(
//                     onPressed: () {
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) => home()));
//                     },
//                     color: Colors.deepPurple,
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text(
//                       "Edit",
//                       style: TextStyle(
//                           fontSize: 14,
//                           letterSpacing: 2.2,
//                           color: Colors.white),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
