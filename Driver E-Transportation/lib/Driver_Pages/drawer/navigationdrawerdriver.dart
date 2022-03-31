// ignore_for_file: import_of_legacy_library_into_null_safe, camel_case_types, non_constant_identifier_names, prefer_const_constructors, duplicate_ignore, avoid_print, unnecessary_new, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:myproject/All_User_Pages/google_sign_in/google_sign_in.dart';
import 'package:myproject/Driver_Pages/drawer/DrawerHeader.dart';
import 'package:myproject/Driver_Pages/drawer/DrawerItem.dart';
import 'package:myproject/Driver_Pages/pages/MyTrips.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawerDriver extends StatefulWidget {
  const navigationDrawerDriver({Key? key}) : super(key: key);

  @override
  State<navigationDrawerDriver> createState() => _navigationDrawerDriverState();
}

class _navigationDrawerDriverState extends State<navigationDrawerDriver> {
  String? rating;
  String? message;
  String? MyDriverID;
  String? isGoogle;

  void getUserCredentioals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyDriverID = prefs.getString("DriverAuthID");
      id = MyDriverID;
      isGoogle = prefs.getString("isGoogle");
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserCredentioals();
  }

  showAlertDialog(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);
    // set up the buttons
    // ignore: deprecated_member_use
    Widget cancelButton = FlatButton(
      // ignore: prefer_const_constructors
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // ignore: deprecated_member_use
    Widget continueButton = FlatButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () async {
        pr.show();
        print(isGoogle);
        if (isGoogle == null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("isDetailsAdded");
          await prefs.remove("isMobileAdded");
          await prefs.remove("Firstname");
          await prefs.remove("Lastname");
          FirebaseAuth.instance.signOut();
          pr.hide().whenComplete(() {
            Navigator.pushNamed(context, MyRoutes.initialRoute);
          });
        } else if (isGoogle != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove("isDetailsAdded");
          await prefs.remove("isMobileAdded");
          await prefs.remove("Firstname");
          await prefs.remove("Lastname");
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          provider.Logout();
          pr.hide().whenComplete(() {
            Navigator.pushNamed(context, MyRoutes.initialRoute);
          });
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure?"),
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
        // ignore: todo
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

        await FirebaseFirestore.instance.collection("Driver Feedback").add({
          'Rating': rating,
          'Message': message,
          'First Name': dfname,
          'Profile pic': dfimage,
        });

        // ignore: todo
        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          _rateAndReviewApp();
        }
        Navigator.pushReplacementNamed(context, MyRoutes.homeRoute);
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),

          createDrawerBodyItem(
              icon: Icons.home,
              text: 'Home',
              onTap: () => {
                    map = 0,
                    Navigator.pushReplacementNamed(context, MyRoutes.homeRoute),
                  }),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.profileRoute),
          ),
          createDrawerBodyItem(
            icon: Icons.car_rental,
            text: 'My Trip',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MyTrips(),
              ),
            ),
          ),

          createDrawerBodyItem(
            icon: Icons.document_scanner,
            text: 'Driver Document',
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.d_update_documentRoute),
          ),
          //Divider(),
          createDrawerBodyItem(
            icon: Icons.document_scanner,
            text: 'Vehicle Document',
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.v_update_documentRoute),
          ),
          createDrawerBodyItem(
            icon: Icons.wallet_giftcard,
            text: 'Earning',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.earningRoute),
          ),
          createDrawerBodyItem(
            icon: Icons.history,
            text: 'History',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.historyRoute),
          ),
          // createDrawerBodyItem(
          //   icon: Icons.add_box_rounded,
          //   text: 'About us',
          //   onTap: () =>
          //       Navigator.pushReplacementNamed(context, MyRoutes.about_usRoute),
          // ),
          createDrawerBodyItem(
              icon: Icons.feedback,
              text: 'FeedBack',
              onTap: () async {
                await getFeedBackDeails();
                _showRatingDialog();
              }),
          createDrawerBodyItem(
            icon: Icons.contact_page,
            text: 'Contact Us',
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.contact_usRoute),
          ),
          createDrawerBodyItem(
              icon: Icons.logout,
              text: 'Log Out',
              onTap: () {
                showAlertDialog(context);
              }),

          SizedBox(
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
              title: Text('App version 1.0.0'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
