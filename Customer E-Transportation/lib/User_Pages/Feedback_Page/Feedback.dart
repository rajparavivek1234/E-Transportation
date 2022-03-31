import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:rating_dialog/rating_dialog.dart';

class Feedback_Screen extends StatefulWidget {
  const Feedback_Screen();

  @override
  _Feedback_ScreenState createState() => new _Feedback_ScreenState();
}

class _Feedback_ScreenState extends State<Feedback_Screen> {
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
      image: Image.asset(
        "Assets/Images/InvoiceImage/Untitled design.jpg",
        height: 100,
      ),
      submitButtonText: 'Submit',
      commentHint: 'Set your custom comment hint',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        //Take current date and Date Format
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
        String totaluser = Data1["Total User"];
        String avgrating = Data1["Avg Rating"];
        String userrating = Data1["User Rating"];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rating Dialog Example')),
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: const Text('Show Rating Dialog'),
            onPressed: _showRatingDialog,
          ),
        ),
      ),
    );
  }
}
