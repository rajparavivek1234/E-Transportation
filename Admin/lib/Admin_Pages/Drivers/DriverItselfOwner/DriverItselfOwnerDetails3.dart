import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/Drivers/DriverItselfNotOwner/DriverItselfNotOwnerDetails4.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

String? AadharCard;
String? Address;
String? AddressProof;
String? City;
String? DOB;
String? DriverImage;
String? FirstName;
String? LastName;
String? Licence;
String? PUC;
String? RCBook;
String? RagistrationDocument;
String? State;
String? VehicleImage;
String? VehicleName;
String? VehicleNo;
String? YearofModel;
String? myId;
String? VehicleId;

class Driver_ItSelf_Owner_Details_Page3 extends StatelessWidget {
  String rcbook = "";
  String puc = "";
  String insurancepolicy = "";

  String id;
  Driver_ItSelf_Owner_Details_Page3({required this.id});

  Widget build(BuildContext context) {
    myId = id;
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
            VehicleId = data["Vehicle ID"];
            rcbook = data["RC Book"];
            puc = data["PUC"];
            insurancepolicy = data["Insurance Policy"];
            AadharCard = data['Aadhar Card'];
            Address = data['Address'];
            AddressProof = data['Address Proof'];
            City = data['City'];
            DOB = data['DOB'];
            DriverImage = data['Driver Image'];
            FirstName = data['First Name'];
            LastName = data['Last Name'];
            Licence = data['Licence'];
            PUC = data['PUC'];
            RCBook = data['RC Book'];
            RagistrationDocument = data['Ragistration Document'];
            State = data['State'];
            VehicleImage = data['Vehicle Image'];
            VehicleName = data['Vehicle Name'];
            VehicleNo = data['Vehicle No'];
            YearofModel = data['Year of Model'];
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
                      height: 380,
                    ),
                    InkWell(
                      onTap: () async {
                        showAlertDialog1(context);
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Approve Application",
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
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        showAlertDialog(context);
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 1),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Reject Application",
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
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
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

showAlertDialog(BuildContext context) {
  ProgressDialog pr = ProgressDialog(context);
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "No",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Yes",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () async {
      await FirebaseFirestore.instance.collection('Driver').doc(myId).update({
        'Approved': '3',
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Driver has been Rejected."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      pr.hide().whenComplete(() {
        Navigator.pushReplacementNamed(context, MyRoutes.AdminDashboard);
      });
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Reject"),
    content: Text("Do you want to reject this Driver?"),
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

showAlertDialog1(BuildContext context) {
  ProgressDialog pr = ProgressDialog(context);
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "No",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Yes",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () async {
      await FirebaseFirestore.instance.collection('Driver').doc(myId).update({
        'Approved': '2',
      });

      print(VehicleId);

      await FirebaseFirestore.instance
          .collection('vehicle')
          .doc(VehicleId)
          .update({
        'Approved': 'Yes',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Driver has been Accepted."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      pr.hide().whenComplete(() {
        Navigator.pushReplacementNamed(context, MyRoutes.AdminDashboard);
      });
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Accept"),
    content: Text("Do you want to accept this Driver?"),
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
