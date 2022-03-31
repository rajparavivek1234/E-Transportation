import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Business_UserDetails extends StatelessWidget {
  String id = "";
  String adharcard = "";
  String businessCertificate = "";
  Business_UserDetails({required this.id});

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () async {
        Navigator.pop(context);
        Navigator.pop(context);
        FirebaseFirestore.instance
            .collection('Business_User')
            .doc(id)
            .delete()
            .catchError((e) {
          print(e);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("User deleted with id:${id}."),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Bolck User"),
      content: Text("Do you want to block this user?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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

    CollectionReference users =
        FirebaseFirestore.instance.collection('Business_User');
    return Scaffold(
      appBar: AppBar(
        title: Text("User Detail"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            adharcard = data['aadhar card'];
            businessCertificate = data['business certificate'];
            return Material(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogFunc(context, data["url"]);
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
                                  data["url"],
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
                    Text(
                      "First Name : ${data['First Name']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          "Last Name : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['Last Name']}",
                          style: TextStyle(
                            fontSize: 20,
                          ),
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
                    Text(
                      "DOB : ${data['DOB']}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: () {
                        _launchInBrowser(adharcard);
                      },
                      child: Text("Press to view Aadhar card"),
                    ),
                    Divider(),
                    ElevatedButton(
                      onPressed: () {
                        _launchInBrowser(businessCertificate);
                      },
                      child: Text("Press to view Business Document"),
                    ),
                    Divider(),
                    SizedBox(
                      height: 160,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showAlertDialog(context);
                      },
                      child: Text("Block user"),
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
                  "Profile pic",
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
