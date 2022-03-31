import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myproject/Admin_Pages/TripsOnTheWay/Tracking.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';

class WidrawRequestDetails extends StatefulWidget {
  String wrid = "";
  String drid = "";
  WidrawRequestDetails({Key? key, required this.wrid, required this.drid})
      : super(key: key);

  @override
  State<WidrawRequestDetails> createState() => _WidrawRequestDetailsState();
}

String did = "";
String widrawamm = "";
String totalbal = "";
String totalwidrawl = "";
String drname = "";
String widrawid = "";

class _WidrawRequestDetailsState extends State<WidrawRequestDetails> {
  getDriverDetails() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Driver')
        .doc(widget.drid)
        .get();
    print(widget.drid);
    did = widget.drid;
    print(did);
    totalbal = documentSnapshot["earning"];
    totalwidrawl = documentSnapshot["Total Withdraw"];

    print("=============${documentSnapshot["Total earning"]}================");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverDetails();
  }

  @override
  Widget build(BuildContext context) {
    widrawid = widget.wrid;
    print(did);
    CollectionReference users =
        FirebaseFirestore.instance.collection('Payment Request');
    return Scaffold(
      appBar: AppBar(
        title: Text("Widraw Request details"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.wrid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              widrawamm = data["Withdraw Ammount"];
              drname = data["driver name"];

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
                            "Driver Name : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['driver name']}",
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
                            "Total Earning : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Total Balance']} INR",
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
                            "Request Ammount : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Withdraw Ammount']}",
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
                        height: 90,
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
                                  offset: Offset(
                                      0, 2), // changes position of shadow
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
                                  offset: Offset(
                                      0, 2), // changes position of shadow
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

showAlertDialog1(BuildContext context) {
  ProgressDialog pr = ProgressDialog(context);
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text(
      "No",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () {
      print(widrawid);
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text(
      "Yes",
      style: TextStyle(color: Colors.deepPurple),
    ),
    onPressed: () async {
      pr.show();
      DateTime now = DateTime.now(); // 30/09/2021 15:54:30
      String dateOnly = DateFormat('dd-MM-yyyy').format(DateTime.now());
      print(dateOnly);

      String newtotalearning =
          (double.parse(totalbal) - double.parse(widrawamm)).toString();
      String newtotalwidraw =
          (double.parse(totalwidrawl) + double.parse(widrawamm)).toString();
      await FirebaseFirestore.instance.collection("Driver").doc(did).update({
        'earning': newtotalearning,
        'Total Withdraw': newtotalwidraw,
      });
      await FirebaseFirestore.instance
          .collection("Driver")
          .doc(did)
          .collection("Transactions")
          .add({
        'Name': drname,
        'Ammount': widrawamm,
        'Method': "Online",
        'Status': "Widrawed",
        'Date': dateOnly,
      });
      await FirebaseFirestore.instance
          .collection("Payment Request")
          .doc(widrawid)
          .update({
        'Status': "1",
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Widraw request has been Accepted."),
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
    content: Text("Do you want to accept widraw request of Driver?"),
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

showAlertDialog(BuildContext context) {
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
      // await FirebaseFirestore.instance.collection('Driver').doc(mid).update({
      //   'Approved': '2',
      // });

      // await FirebaseFirestore.instance.collection('vehicle').doc(vhcid).update({
      //   'Approved': 'Yes',
      // });
      await FirebaseFirestore.instance
          .collection("Payment Request")
          .doc(widrawid)
          .update({
        'Status': "2",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Driver has been Accepted."),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      Navigator.pushReplacementNamed(context, MyRoutes.AdminDashboard);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Reject"),
    content: Text("Do you want to Reject widraw request of Driver?"),
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
