// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, annotate_overrides, prefer_const_constructors, avoid_print, unused_import, unnecessary_brace_in_string_interps, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe, must_call_super

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:myproject/Driver_Pages/drawer/DrawerHeader.dart';
import 'package:myproject/Driver_Pages/pages/accept_request.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/request_list.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:progress_dialog/progress_dialog.dart';

String? reqid;
String TotalPrice = "";
String FirstName = "";
String LastName = "";
String MobileNo = "";
String DriverImg = "";
String VehicleName = "";
String VehicleNo = "";
String VPrice = "";
String oid = "";

class request_details extends StatefulWidget {
  String rid = "";
  request_details({
    Key? key,
    required this.rid,
  }) : super(key: key);

  @override
  State<request_details> createState() => _request_detailsState();
}

class _request_detailsState extends State<request_details> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    getvdeails();
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    CollectionReference users = FirebaseFirestore.instance
        .collection('Driver')
        .doc(id)
        .collection('Request');
    return Scaffold(
      appBar: AppBar(
        title: Text("Ride Request"),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => home()));
            }),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.rid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            TotalPrice =
                (double.parse(data['Distance']) * double.parse(data['Price']))
                    .toString();

            slatitude = data['Source lat'];
            print("Starting Latitude ===== ${slatitude}");
            slongitude = data['Source lang'];
            print("Starting Longitude ===== ${slongitude}");

            dlatitude = data['Destination lat'];
            print("Destination Latitude ===== ${dlatitude}");
            dlongitude = data['Destination lang'];
            print("Destination Longitude ===== ${dlongitude}");

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
                      height: 15,
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
                      height: 140,
                    ),
                    InkWell(
                      onTap: () async {
                        pr.show();
                        //step = "2";
                        reqid = widget.rid;
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(data['UserID'])
                            .collection('MyOrders')
                            .add({
                          'Starting Point': data['Starting Point'],
                          'Destination Point': data['Destination Point'],
                          'Type Of Goods': data['Goods Type'],
                          'Driver Name': "${FirstName} ${LastName}",
                          'Driver Img': DriverImg,
                          'Phone No': MobileNo,
                          'Status': 'On The Way',
                          'Vehicle Name': VehicleName,
                          'Vehicle No': VehicleNo,
                          'Distance': data['Distance'],
                          'Total Price': TotalPrice,
                          'Price Per KM': VPrice,
                          'Request ID': rid,
                          'Driver ID': id,
                          'Date': data['Date'],
                          'Time': data['Time'],
                        }).then((value) {
                          oid = value.id;
                        });

                        await FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(id)
                            .collection("Request")
                            .doc(widget.rid)
                            .update({
                          'Status': '1',
                          'On Trip': 'Yes',
                          'MyOrderID': oid,
                          //'Step': step,
                        });

                        await FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(id)
                            .update({
                          'On Trip': 'Yes',
                          //'Step': step,
                        });

                        await FirebaseFirestore.instance
                            .collection('vehicle')
                            .doc(vid)
                            .update({
                          'On Trip': 'Yes',
                          'Driver Latitude': currentPosition!.latitude,
                          'Driver Longitude': currentPosition!.longitude,
                          'sLatitude': slatitude,
                          'sLongitude': slongitude,
                          'dLatitude': dlatitude,
                          'dLongitude': dlongitude,
                        });
                        pr.hide().whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => accept_request(
                                rid: rid,
                              ),
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Request Accepted."),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Accept",
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
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        pr.show();
                        //step = "0";
                        await FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(id)
                            .collection("Request")
                            .doc(widget.rid)
                            .update({
                          'Status': '2',
                          //'step': step,
                        });

                        FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(id)
                            .collection('Request')
                            .doc(widget.rid)
                            .delete()
                            .catchError((e) {
                          print(e);
                        });
                        pr.hide().whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => accept_request(rid: rid),
                            ),
                          );
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Request Rejected."),
                            backgroundColor: Colors.black,
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Decline",
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

Future<void> getvdeails() async {
  //CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Driver').doc(id).get();
  vid = documentSnapshot['Vehicle ID'];
  print("Vehicle Id ===== ${vid}");
  MobileNo = documentSnapshot['Phone no'];
  print("Mobil NO ===== ${MobileNo}");
  FirstName = documentSnapshot['First Name'];
  print("first name ===== ${FirstName}");
  LastName = documentSnapshot['Last Name'];
  print("last name ===== ${LastName}");
  DriverImg = documentSnapshot["Driver Image"];
  print("Driver image ===== ${DriverImg}");
  VehicleName = documentSnapshot["Vehicle Name"];
  print("Vehicle Name ===== ${VehicleName}");
  VehicleNo = documentSnapshot["Vehicle No"];
  print("Vehicle Name ===== ${VehicleNo}");
  VPrice = documentSnapshot["Price"];
  print("Price Per KM ===== ${VPrice}");
}
