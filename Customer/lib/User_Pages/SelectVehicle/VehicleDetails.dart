import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/Map/Map_Screen.dart';
import 'package:myproject/User_Pages/ReceiverInfo/ReceiverInfo.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:myproject/User_Pages/WaitingScreen/WaitingScreen.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String Driverid = "";
String? PricePerKM;
String? DriverName;
String? VehicleName;
String? VehicleNo;

class VehicleDetails extends StatefulWidget {
  String Vehicleid = "";

  String? Source;
  String? Destination;
  String? Distance;
  VehicleDetails(
      {Key? key,
      required this.Vehicleid,
      this.Source,
      this.Destination,
      this.Distance})
      : super(key: key);

  @override
  State<VehicleDetails> createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  String reqid = "";

  String adharcard = "";

  String businessCertificate = "";

  String? MyUserID;

  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    print(MyUserID);
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
        FirebaseFirestore.instance.collection('vehicle');
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Detail"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.Vehicleid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            PricePerKM = data["Price"];
            DriverName = "${data["First Name"]} ${data["Last Name"]}";
            VehicleName = "${data["Vehicle Name"]}";
            VehicleNo = "${data["Vehicle No"]}";
            return Material(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogFunc(context, data["Vehicle Image"]);
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
                                  data["Vehicle Image"],
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
                          "Driver First Name : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['First Name']}",
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
                          "Driver Last Name : ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['Last Name']}",
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
                    Divider(),
                    SizedBox(
                      height: 150,
                    ),
                    InkWell(
                      onTap: () async {
                        print(MyUserID);
                        print(widget.Source);
                        print(widget.Destination);
                        print(widget.Distance);
                        print(data['Driver Id']);
                        Driverid = data['Driver Id'];
                        await FirebaseFirestore.instance
                            .collection('Driver')
                            .doc(data['Driver Id'])
                            .collection('Request')
                            .add(
                          {
                            "Profile pic": ProfilePic,
                            "First Name": Firstname,
                            "Last Name": Lastname,
                            "Mobile Number": MobNo,
                            "Starting Point": widget.Source,
                            "Destination Point": widget.Destination,
                            "Distance": widget.Distance,
                            "Goods Type": goodsType,
                            "Date": date,
                            "Time": time,
                            "Receiver Code Digit": Receiver_Dial_code,
                            "Receiver Mob. No.": Receiver_Mobile_No,
                            "Receiver First Name": Receiver_firstname,
                            "Receiver Last Name": Receiver_lastname,
                            "Status": "0",
                            "UserID": MyUserID,
                            "Price": PricePerKM,
                            "On Trip": data['On Trip'],
                            "Payment Status": "Pending",
                            "Source lat": OriginLat,
                            "Source lang": OriginLng,
                            "Destination lat": DestLat,
                            "Destination lang": DestLng,
                            "Order Completed": "No",
                            "Payment Method": "",
                          },
                        ).then(
                          (value) {
                            print(value.id);
                            reqid = value.id;
                          },
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WaitingScreen(
                              reqid: reqid,
                            ),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          "Request For Trip",
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
                  "Vehicle Image",
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
