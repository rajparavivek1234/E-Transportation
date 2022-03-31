import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfNotOwner/DriverItselfNotOwnerDetails2.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfNotOwner/DriverItselfNotOwnerDetails4.dart';
import 'package:url_launcher/url_launcher.dart';

class Driver_ItSelf_Not_Owner_Details_Page3 extends StatelessWidget {
  String id = "";
  String rcbook = "";
  String puc = "";
  String insurancepolicy = "";
  Driver_ItSelf_Not_Owner_Details_Page3({required this.id});

  Widget build(BuildContext context) {
    Future<void> _launchInBrowser(String url) async {
      if (!await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      )) {
        throw 'Could not launch $url';
      }
    }

    CollectionReference users = FirebaseFirestore.instance.collection('Driver');
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle document"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            rcbook = data["RC Book"];
            puc = data["PUC"];
            insurancepolicy = data["Insurance Policy"];
            return Material(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Container(
                        child: Center(
                          child: Text(
                            "RC Book",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        height: 60,
                        width: 390,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 2),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _launchInBrowser(rcbook);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Container(
                        child: Center(
                          child: Text(
                            "PUC",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        height: 60,
                        width: 390,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 2),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _launchInBrowser(puc);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Container(
                        child: Center(
                          child: Text(
                            "Insurance Policy",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        height: 60,
                        width: 390,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(1, 2),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        _launchInBrowser(insurancepolicy);
                      },
                    ),
                    SizedBox(
                      height: 440,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                Driver_ItSelf_Not_Owner_Details_Page4(id: id),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
