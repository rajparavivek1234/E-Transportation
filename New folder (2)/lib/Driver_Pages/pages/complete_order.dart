// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, annotate_overrides, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, unused_import, unnecessary_brace_in_string_interps, import_of_legacy_library_into_null_safe, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:myproject/Driver_Pages/drawer/DrawerHeader.dart';
import 'package:myproject/Driver_Pages/pages/driver_home.dart';
import 'package:myproject/Driver_Pages/pages/earning.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/request_list.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'request_details.dart';

class complete_order extends StatefulWidget {
  String rid = "";
  complete_order({
    Key? key,
    required this.rid,
  }) : super(key: key);
  @override
  State<complete_order> createState() => _complete_orderState();
}

String? coid;
String FN = "";
String LN = "";
String DIMG = "";
String PaymentMethod = "";
String PaymentStatus = "";
String tempEarning = "";
String tempTotalEarning = "";

class _complete_orderState extends State<complete_order> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getdeails();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    var now = DateTime.now();
    var MONTHS = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    var formatter = DateFormat('dd-MM-yyyy');
    String date = now.day.toString() +
        " " +
        MONTHS[now.month - 1] +
        " " +
        now.year.toString() +
        ", " +
        now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();

    CollectionReference users = FirebaseFirestore.instance
        .collection('Driver')
        .doc(id)
        .collection('Request');

// Paymentdetails() {
//   if (PaymentMethod == "COD") {
//     Text(
//       "First Receive Payment Then Handover Delivery And Press Complete Button",
//       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   } else if (PaymentMethod == "Online" && PaymentStatus == "Pending") {
//     Text(
//       "Online Payment Is Pending. Ask For Complete Payment",
//       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//     );
//   }
// }

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Complete"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.rid).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              PaymentMethod = data['Payment Method'].toString();
              print("Payment Method ===== ${PaymentMethod}");
              PaymentStatus = data['Payment Status'];
              print("Payment Status ===== ${PaymentStatus}");

              TotalPrice =
                  (double.parse(data['Distance']) * double.parse(data['Price']))
                      .toString();
              print("Total Price === ${TotalPrice}");

              Earning = (double.parse(tempEarning) + double.parse(TotalPrice))
                  .toString();
              TotalEarning =
                  (double.parse(tempTotalEarning) + double.parse(TotalPrice))
                      .toString();

              oid = data['MyOrderID'];
              print("Order ID === ${oid}");

              return Material(
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialogFunc(context, data["Profile pic"]);
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
                                    data["Profile pic"],
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
                            "From : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Starting Point']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "To : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Destination Point']}",
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
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Distance : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Distance']} Km",
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
                            "Payment Method : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            PaymentMethod,
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
                          Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 238, 182, 182),
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 6,
                                    ),
                                    Container(
                                      child: Text(
                                        "* Warning *",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 350,
                                      child: Text(
                                        "1. If Payment Method is Cash On Delivery Then First Receive Payment Then Handover Delivery And Press Complete Trip Button",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: 350,
                                      child: Text(
                                        "2. If Payment Method Is Online Payment And Online Payment Is Pending.Ask For Complete Payment first and then give delivery.",
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          pr.show();
                          //step = "0";
                          if ((PaymentMethod == "Online" &&
                              PaymentStatus == "Pending")) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Payment Is Not Complete By Customer"),
                                backgroundColor: Colors.black,
                              ),
                            );
                          } else {
                            await FirebaseFirestore.instance
                                .collection('History')
                                .add({
                              'User ID': "${data['UserID']}",
                              'Driver ID': id,
                              'Driver Img': DIMG,
                              'User Img': "${data['Profile pic']}",
                              'User First Name': "${data['First Name']}",
                              'User Last Name': "${data['Last Name']}",
                              'Driver First Name': FN,
                              'Driver Last Name': LN,
                              'Starting Point': "${data['Starting Point']}",
                              'Destination Point':
                                  "${data['Destination Point']}",
                              'Distance': "${data['Distance']}",
                              'Total Cost': TotalPrice,
                            });

                            await FirebaseFirestore.instance
                                .collection('vehicle')
                                .doc(vid)
                                .update({
                              'On Trip': 'No',
                            });

                            await FirebaseFirestore.instance
                                .collection('Driver')
                                .doc(id)
                                .collection("Request")
                                .doc(widget.rid)
                                .update({
                              'On Trip': 'No',
                              'Order Completed': "Yes",
                              'Payment Status': "Complete"
                            });

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(data['UserID'])
                                .collection('MyOrders')
                                .doc(oid)
                                .update({
                              'Status': 'Complete',
                              'Order Complete Date': date,
                              'Payment Method': PaymentMethod,
                              'Payment Status': "Complete",
                            });

                            if (PaymentMethod == "COD") {
                              await FirebaseFirestore.instance
                                  .collection('Driver')
                                  .doc(id)
                                  .collection('Transactions')
                                  .add({
                                'Name':
                                    "${data['First Name']} ${data['Last Name']}",
                                'Ammount': TotalPrice,
                                'Method': "COD",
                                'Status': "Earned",
                                'Date': date,
                              });

                              await FirebaseFirestore.instance
                                  .collection('Driver')
                                  .doc(id)
                                  .update({
                                'On Trip': 'No',
                                'Total earning': TotalEarning,
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('Driver')
                                  .doc(id)
                                  .collection('Transactions')
                                  .add({
                                'Name':
                                    "${data['First Name']} ${data['Last Name']}",
                                'Ammount': TotalPrice,
                                'Method': "online",
                                'Status': "Earned",
                                'Date': date,
                              });

                              await FirebaseFirestore.instance
                                  .collection('Driver')
                                  .doc(id)
                                  .update({
                                'On Trip': 'No',
                                'earning': Earning,
                                'Total earning': TotalEarning,
                              });
                            }
                            pr.hide().whenComplete(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => home()),
                              );
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Trip Completed."),
                                backgroundColor: Colors.black,
                              ),
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          width: 330,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Complete Trip",
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

Future<void> getdeails() async {
  //CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  DocumentSnapshot documentSnapshot1 =
      await FirebaseFirestore.instance.collection('Driver').doc(id).get();

  FN = documentSnapshot1['First Name'];
  print("first name ===== ${FN}");
  LN = documentSnapshot1['Last Name'];
  print("last name ===== ${LN}");
  DIMG = documentSnapshot1["Driver Image"];
  print("Driver image ===== ${DIMG}");
  tempEarning = documentSnapshot1["earning"];
  print("earning ===== ${tempEarning}");
  tempTotalEarning = documentSnapshot1["Total earning"];
  print("total earning ===== ${tempTotalEarning}");
  vid = documentSnapshot1["Vehicle ID"];
  print("Vehicle ID ===== ${vid}");
}
