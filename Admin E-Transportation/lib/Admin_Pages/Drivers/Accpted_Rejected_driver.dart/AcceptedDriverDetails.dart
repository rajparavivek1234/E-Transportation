import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Drivers/Accpted_Rejected_driver.dart/AcceptedDriverVehicle.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfOwner/DriverItselfOwnerDetails1.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AcceptedDriverDetails extends StatelessWidget {
  String id = "";

  AcceptedDriverDetails({required this.id});

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
            .collection('Driver')
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
      content: Text("Are you sure?"),
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

  @override
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
        title: Text("Driver details"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
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
                        height: 15,
                      ),
                      RatingBarIndicator(
                        rating: data["Avg Rating"],
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 40.0,
                        direction: Axis.horizontal,
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
                            "First Name : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['First Name']}",
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
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Email : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${data['Email']}",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
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
                            "DOB : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['DOB']}",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Address : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${data['Address']}",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
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
                            "City : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['City']}",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "State : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['State']}",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Driver Itselt Owner of Vehicle : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Owner Of Vehicle']}",
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
                      ElevatedButton(
                        onPressed: () {
                          _launchInBrowser(data["Aadhar Card"]);
                        },
                        child: Text("Tap to view Aadhar card"),
                      ),
                      Divider(),
                      ElevatedButton(
                        onPressed: () {
                          _launchInBrowser(data["Address Proof"]);
                        },
                        child: Text("Tap to view Address Proof"),
                      ),
                      Divider(),
                      ElevatedButton(
                        onPressed: () {
                          _launchInBrowser(data["Licence"]);
                        },
                        child: Text("Tap to view Licence"),
                      ),
                      Divider(),
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  AcceptedDriverVehicleDetails(id: id),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 330,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "View Vehicle Details",
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showAlertDialog(context);
                        },
                        child: Text("Block Driver"),
                      ),
                      SizedBox(
                        height: 50,
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
