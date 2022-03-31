import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:myproject/All_User_Pages/MyOrder/myorder_details.dart';
import 'package:myproject/User_Pages/Map/Map_Screen.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/User_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../User_Pages/Payment/Payment.dart';

class myorder_list extends StatefulWidget {
  @override
  State<myorder_list> createState() => _myorder_listState();
}

class _myorder_listState extends State<myorder_list> {
  final db = FirebaseFirestore.instance;

  String id = "";
  String? MyUserID;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  @override
  void initState() {
    super.initState();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    print('a= ${MyUserID}');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, MyRoutes.homeRoute);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "My Orders",
          ),
        ),
        drawer: navigationDrawer(),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Users')
              .doc(MyUserID)
              .collection('MyOrders')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return new Scaffold(body: Center(child: Text("No Orders")));
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView(
                  children: snapshot.data!.docs
                      .map(
                        (doc) => Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 8),
                          child: Card(
                            borderOnForeground: true,
                            elevation: 4,
                            child: new ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    doc["Driver Name"] ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              leading: CircleAvatar(
                                radius: 30.0,
                                backgroundImage:
                                    NetworkImage(doc["Driver Img"]),
                                backgroundColor: Colors.transparent,
                              ),
                              onTap: () async {
                                id = doc.id;
                                print(id);
                                print(doc["Request ID"]);
                                String reqid = doc["Request ID"];
                                print(doc["Driver ID"]);
                                Driverid = doc["Driver ID"];
                                Distance = doc["Distance"];
                                PricePerKM = doc["Price Per KM"];
                                source = doc["Starting Point"];
                                Destination = doc["Destination Point"];
                                goodsType = doc["Type Of Goods"];
                                DriverName = doc["Driver Name"];
                                VehicleName = doc["Vehicle Name"];
                                VehicleNo = doc["Vehicle No"];
                                date = doc["Date"];
                                time = doc["Time"];
                                DocumentSnapshot documentSnapshot1 =
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(MyUserID)
                                        .get();
                                FN = documentSnapshot1["First Name"];
                                LN = documentSnapshot1["Last Name"];
                                EMAIL = documentSnapshot1["Email"];
                                DocumentSnapshot documentSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Driver')
                                        .doc(doc["Driver ID"])
                                        .collection('Request')
                                        .doc(doc["Request ID"])
                                        .get();
                                String paymentstatus =
                                    documentSnapshot["Payment Status"];
                                String paymentmethod =
                                    documentSnapshot["Payment Method"];

                                //Driverid = doc["Driver ID"];
                                print(documentSnapshot["Payment Status"]);
                                if (paymentstatus == 'Pending') {
                                  if (paymentmethod == 'Online') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Payment(
                                          rid: reqid,
                                        ),
                                      ),
                                    );
                                  } else if (paymentmethod == 'COD') {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => myorder_details(
                                          id: id,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => Payment(
                                          rid: reqid,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => myorder_details(
                                        id: id,
                                      ),
                                    ),
                                  );
                                }
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
      ),
    );
  }
}
