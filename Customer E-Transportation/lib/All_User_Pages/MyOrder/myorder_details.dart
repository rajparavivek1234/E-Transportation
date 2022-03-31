import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/Invoice/InvoiceScreen.dart';
import 'package:myproject/User_Pages/Invoice/file_handle_api.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../User_Pages/Home_Page/Home_Page.dart';
import '../../User_Pages/Invoice/Invoice.dart';
import '../../User_Pages/SelectVehicle/VehicleDetails.dart';
import '../../User_Pages/User_Details/User_Details.dart';

String _url = "";

class myorder_details extends StatefulWidget {
  String id = "";

  myorder_details({required this.id});

  @override
  State<myorder_details> createState() => _myorder_detailsState();
}

class _myorder_detailsState extends State<myorder_details> {
  String? MyUserID;

  String? startingpoint;
  String? destinationpoint;
  String? goodstype;
  String? drivername;
  String? vehiclename;
  String? vehicleno;
  String? distance;
  String? totalcost;
  String? priceperkm;

  String? rating;

  String? message;

  // show the rating dialog
  void _showRatingDialog() {
    // actual store listing review & rating
    void _rateAndReviewApp() async {
      // refer to: https://pub.dev/packages/in_app_review
      final _inAppReview = InAppReview.instance;

      if (await _inAppReview.isAvailable()) {
        print('request actual review from store');
        _inAppReview.requestReview();
      } else {
        print('open actual store listing');
        // TODO: use your own store ids
        _inAppReview.openStoreListing(
          appStoreId: '<your app store id>',
          microsoftStoreId: '<your microsoft store id>',
        );
      }
    }

    final _dialog = RatingDialog(
      initialRating: 1.0,
      starColor: Colors.orangeAccent,
      // your app's name?
      title: Text(
        'Rating Dialog',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
      // your app's logo?
      image: const FlutterLogo(size: 80),
      submitButtonText: 'Submit',
      commentHint: 'Set your custom comment hint',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        var now = new DateTime.now();
        var formatter = new DateFormat('dd-MM-yyyy');
        String date = formatter.format(now);

        // print(
        //     'rating: ${response.rating}, comment: ${response.comment} ,date:${date}');

        rating = response.rating.toString();
        message = response.comment;
        print(rating);
        print(message);
        print(Driverid);
        DocumentSnapshot Data = await FirebaseFirestore.instance
            .collection("Driver")
            .doc(Driverid)
            .get();
        String Vehicleid = Data["Vehicle ID"];
        DocumentSnapshot Data1 = await FirebaseFirestore.instance
            .collection("vehicle")
            .doc(Vehicleid)
            .get();
        String totaluser = Data1["Total User"].toString();
        String avgrating = Data1["Avg Rating"].toString();
        String userrating = Data1["User Rating"].toString();
        double newtotaluser = double.parse(totaluser) + 1;
        double newuserrating =
            double.parse(userrating) + double.parse(rating.toString());
        double newaverating = newuserrating / newtotaluser;
        await FirebaseFirestore.instance
            .collection("vehicle")
            .doc(Vehicleid)
            .update({
          'Total User': newtotaluser,
          'Avg Rating': newaverating,
          'User Rating': newuserrating,
        });
        await FirebaseFirestore.instance
            .collection("Driver")
            .doc(Driverid)
            .update({
          'Total User': newtotaluser,
          'Avg Rating': newaverating,
          'User Rating': newuserrating,
        });

        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          _rateAndReviewApp();
        }
      },
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );
  }

  void details() async {
    DocumentSnapshot data = await FirebaseFirestore.instance
        .collection('Users')
        .doc(MyUserID)
        .collection('MyOrders')
        .doc(id)
        .get();

    startingpoint = data["Starting Point"];
    destinationpoint = data["Destination Point"];
    goodstype = data["Types Of Goods"];
    drivername = data["Driver Name"];
    vehiclename = data["Vehicle Name"];
    vehicleno = data["Vehicle No"];
    distance = data["Distance"];
    totalcost = data["Total Price"];
    priceperkm = data["Price Per KM"];
  }

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
    // details();
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

    CollectionReference users = FirebaseFirestore.instance
        .collection('Users')
        .doc(MyUserID)
        .collection('MyOrders');
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(widget.id).get(),
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
                          showDialogFunc(context, data["Driver Img"]);
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
                                    data["Driver Img"],
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
                            "Driver Name : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Driver Name']}",
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
                          Column(
                            children: [
                              Text(
                                "Vehicle Name : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${data['Vehicle Name']}",
                                style: TextStyle(fontSize: 20),
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
                            "Vehicle No : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Vehicle No']}",
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
                            "Type Of Goods : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Type Of Goods']}",
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
                            "Status : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Status']}",
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
                          Column(
                            children: [
                              Text(
                                "From : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 20,
                                child: Text(
                                  "${data['Starting Point']}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "To : ",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 20,
                                child: Text(
                                  "${data['Destination Point']}",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
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
                            "Distance : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Distance']}",
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
                            "Price Per KM : ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data['Price Per KM']}",
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
                            "Total Price Rupees: ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${data["Total Price"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              _url = "tel:= ${data['Phone No']}";
                              _launchURL();
                            },
                            child: AnimatedContainer(
                              duration: Duration(seconds: 2),
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 30,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ]),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _url = "smsto:${data['Phone No']}";
                              _launchURL();
                            },
                            child: AnimatedContainer(
                              duration: Duration(seconds: 2),
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.message,
                                color: Colors.white,
                                size: 30,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          if (data['Status'] == 'Complete') {
                            // generate pdf file

                            final pdfFile = await PdfInvoiceApi.generate();
                            // opening the pdf file
                            await FileHandleApi.openFile(pdfFile);
                            _showRatingDialog();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Your delivery not completed yet"),
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
                            "Generate Invoice",
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
                      SizedBox(
                        height: 50,
                      )
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

void _launchURL() async {
  if (!await launch(_url)) throw 'Could Not Lounch $_url';
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
