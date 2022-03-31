import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myproject/User_Pages/Payment/Payment.dart';
import 'package:myproject/User_Pages/SelectVehicle/SelectVehicle.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/Utils/routes.dart';

class WaitingScreen extends StatefulWidget {
  String? reqid;

  WaitingScreen({Key? key, this.reqid}) : super(key: key);

  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  CountDownController _controller = CountDownController();
  int _duration = 120;
  var status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var users = FirebaseFirestore.instance
        .collection('Driver')
        .doc(Driverid)
        .collection("Request")
        .snapshots()
        .listen((data) {
      data.docChanges.forEach(
        (change) async {
          Map<String, dynamic>? myMap = change.doc.data();
          print(myMap);
          status = myMap!["Status"];
          print(status);
          if (status == "1") {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Payment(
                  rid: widget.reqid,
                ),
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Your Request has been accepted"),
                backgroundColor: Colors.black,
              ),
            );
          } else if (status == "2") {
            FirebaseFirestore.instance
                .collection('Driver')
                .doc(Driverid)
                .collection("Request")
                .doc(widget.reqid)
                .update({
              'Status': '0',
            });
            Navigator.pop(context);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Your Request has been rejected"),
                backgroundColor: Colors.black,
              ),
            );
          }
        },
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle Detail"),
      ),
      body: Material(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              CircularCountDownTimer(
                // Countdown duration in Seconds.
                duration: _duration,

                // Countdown initial elapsed Duration in Seconds.
                initialDuration: 0,

                // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                controller: _controller,

                // Width of the Countdown Widget.
                width: MediaQuery.of(context).size.width / 2,

                // Height of the Countdown Widget.
                height: MediaQuery.of(context).size.height / 2,

                // Ring Color for Countdown Widget.
                ringColor: Colors.grey[300]!,

                // Ring Gradient for Countdown Widget.
                ringGradient: null,

                // Filling Color for Countdown Widget.
                fillColor: Colors.purpleAccent[100]!,

                // Filling Gradient for Countdown Widget.
                fillGradient: null,

                // Background Color for Countdown Widget.
                backgroundColor: Colors.purple[500],

                // Background Gradient for Countdown Widget.
                backgroundGradient: null,

                // Border Thickness of the Countdown Ring.
                strokeWidth: 15.0,

                // Begin and end contours with a flat edge and no extension.
                strokeCap: StrokeCap.round,

                // Text Style for Countdown Text.
                textStyle: TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),

                // Format for the Countdown Text.
                textFormat: CountdownTextFormat.S,

                // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                isReverse: true,

                // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                isReverseAnimation: false,

                // Handles visibility of the Countdown Text.
                isTimerTextShown: true,

                // Handles the timer start.
                autoStart: true,

                // This Callback will execute when the Countdown Starts.
                onStart: () {
                  // Here, do whatever you want
                  print('Countdown Started');
                },
                // This Callback will execute when the Countdown Ends.
                onComplete: () async {
                  // Here, do whatever you want
                  await FirebaseFirestore.instance
                      .collection("Driver")
                      .doc(Driverid)
                      .collection("Request")
                      .doc(widget.reqid)
                      .delete();
                  print('Countdown Ended');
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              Text("Please wait....."),
              Text("Driver will accept your request soon."),
              SizedBox(
                height: 80,
              ),
              InkWell(
                onTap: () async {
                  await FirebaseFirestore.instance
                      .collection("Driver")
                      .doc(Driverid)
                      .collection("Request")
                      .doc(widget.reqid)
                      .delete();

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: 330,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "Cancel Request",
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
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
