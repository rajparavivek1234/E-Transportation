import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';
import 'package:myproject/User_Pages/drawer/widget/DrawerItem.dart';
import 'package:myproject/All_User_Pages/google_sign_in/google_sign_in.dart';
import 'package:myproject/User_Pages/drawer/widget/DrawerHeader.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Home_Page/Home_Page.dart';
import '../User_Details/User_Details.dart';

class navigationDrawer extends StatefulWidget {
  @override
  State<navigationDrawer> createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {
  String? rating;
  String? message;

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

        await FirebaseFirestore.instance.collection("User Feedback").add({
          'Rating': rating,
          'Message': message,
          'First Name': Firstname,
          'Profile pic': ProfilePic,
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home_Page(),
          ),
        );

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

  showAlertDialog(BuildContext context) {
    ProgressDialog pr = ProgressDialog(context);

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.deepPurple),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
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

  String? MyUserID;
  String? isGoogle;
  String myorders = "";
  void getUserCredentioals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
      isGoogle = prefs.getString("isGoogle");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentioals();
  }

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance
    //     .collection("Users")
    //     .doc(MyUserID)
    //     .collection("MyOrders")
    //     .get()
    //     .then((value) {
    //   setState(() {
    //     myorders = value.size.toString();
    //   });
    // });
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),

          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.homeRoute),
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'Profile',
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.myProfileRoute),
          ),
          createDrawerBodyItem(
            icon: Icons.reorder,
            text: 'MyOrders',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.myorder_list),
          ),
          createDrawerBodyItem(
            icon: Icons.history,
            text: 'History',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.myHistory),
          ),
          createDrawerBodyItem(
              icon: Icons.feedback,
              text: 'Feedback',
              onTap: () {
                _showRatingDialog();
              }),
          Divider(),
          // createDrawerBodyItem(
          //   icon: Icons.notifications_active,
          //   text: 'Notifications',
          //   count: '0',
          //   onTap: () =>
          //       Navigator.pushReplacementNamed(context, MyRoutes.homeRoute),
          // ),
          // createDrawerBodyItem(
          //   icon: Icons.contact_phone,
          //   text: 'Contact Info',
          //   count: '0',
          //   onTap: () =>
          //       Navigator.pushReplacementNamed(context, MyRoutes.homeRoute),
          // ),
          createDrawerBodyItem(
            icon: Icons.exit_to_app,
            text: 'Logout',
            onTap: () => showAlertDialog(context),
          ),
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
