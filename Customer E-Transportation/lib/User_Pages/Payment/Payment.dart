import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/Home_Page/Home_Page.dart';
import 'package:myproject/User_Pages/Invoice/InvoiceScreen.dart';
import 'package:myproject/User_Pages/Map/Map_Screen.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:myproject/User_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:toast/toast.dart';

class Payment extends StatefulWidget {
  String? rid;
  Payment({Key? key, this.rid}) : super(key: key);
  @override
  State<Payment> createState() => _PaymentState();
}

String? FN;
String? LN;
String? EMAIL;

var TotalPrice = double.parse(Distance) * double.parse(PricePerKM!);

class _PaymentState extends State<Payment> {
  late Razorpay razorpay;
  String? MyUserID;

  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  void initState() {
    super.initState();
    getUserCredentials();
    razorpay = new Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }

  void openCheckout() {
    var options = {
      "key": "rzp_test_rd2cCIJUyDe4fG",
      "amount": num.parse(TotalPrice.toString()) * 100,
      "name": "Transportation app",
      "description": "Payment for your trip",
      "prefill": {
        "contact": "2323232323",
        "email": "sdrges23@gmail.com",
      },
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Payment Successful."),
        backgroundColor: Colors.green,
      ),
    );
    // await FirebaseFirestore.instance
    //     .collection("Driver")
    //     .doc(Driverid)
    //     .collection("Payment")
    //     .add({
    //   "UserID": MyUserID,
    //   "UserFirstName": FN,
    //   "UserLastName": LN,
    //   "Total Price": TotalPrice,
    //   "Payment Method": 'Online',
    //   "Status": 'added',
    // });
    FirebaseFirestore.instance
        .collection('Driver')
        .doc(Driverid)
        .collection("Request")
        .doc(widget.rid)
        .update({
      'Payment Status': 'Completed',
      // "Payment Method": 'Online',
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home_Page(),
      ),
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {}

  void handleExternalWallet(ExternalWalletResponse response) {
    Toast.show("External wallet", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    print(MyUserID);
    FirebaseFirestore.instance
        .collection('Driver')
        .doc(Driverid)
        .collection("Request")
        .doc(widget.rid)
        .update({
      'Status': '0',
    });
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return new Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(MyUserID).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            FN = data["First Name"];
            LN = data["Last Name"];
            EMAIL = data["Email"];
            print(FN);
            print(LN);
            print(EMAIL);
            return Scaffold(
                body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      "Trip Summary",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(),
                    Text(
                      "User & Trip Details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "User name:${FN} ${LN}",
                    ),
                    Text(
                      "Starting point:${source}",
                    ),
                    Text(
                      "Destination point:${Destination}",
                    ),
                    Text(
                      "Goods Type:${goodsType}",
                    ),
                    Text(
                      "Date:${date}",
                    ),
                    Text(
                      "Time:${time}",
                    ),
                    Divider(),
                    Text(
                      "Driver & Vehicle Details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Driver Name:${DriverName}",
                    ),
                    Text(
                      "Vehicle Name:${VehicleName}",
                    ),
                    Text(
                      "Vehicle No:${VehicleNo}",
                    ),
                    Divider(),
                    Text(
                      "Distance & Price Details",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Distance:${Distance}",
                    ),
                    Text(
                      "Price/KM:${PricePerKM}",
                    ),
                    Text(
                      "Total price:${TotalPrice.toStringAsFixed(2)}",
                    ),
                    Divider(),
                    SizedBox(
                      height: 100,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('example.com');
                          if (result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty) {
                            print("Connected");
                            FirebaseFirestore.instance
                                .collection('Driver')
                                .doc(Driverid)
                                .collection("Request")
                                .doc(widget.rid)
                                .update({
                              //'Payment Status': 'Completed',
                              "Payment Method": 'Online',
                            });
                            openCheckout();
                          }
                        } on SocketException catch (_) {
                          print("Not Connected");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Check your Internet connection."),
                              backgroundColor: Colors.blueGrey,
                            ),
                          );
                        }
                      },
                      child: Container(
                        height: 55,
                        width: 350,
                        child: Center(
                            child: Text(
                          "Online Payment",
                          style: TextStyle(fontSize: 20),
                        )),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 3,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () async {
                        // await FirebaseFirestore.instance
                        //     .collection("Driver")
                        //     .doc(Driverid)
                        //     .collection("Payment")
                        //     .add({
                        //   "UserID": MyUserID,
                        //   "UserFirstName": FN,
                        //   "UserLastName": LN,
                        //   "Total Price": TotalPrice,
                        //   "Payment Method": 'COD',
                        // });

                        FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(Driverid)
                            .collection("Request")
                            .doc(widget.rid)
                            .update({
                          "Payment Method": 'COD',
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home_Page(),
                          ),
                        );
                      },
                      child: Container(
                        height: 55,
                        width: 350,
                        child: Center(
                          child: Text(
                            "Cash On Delivery",
                            style: TextStyle(fontSize: 20),
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
