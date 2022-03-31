import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/AdminLogin/AdminLogin.dart';
import 'package:myproject/Admin_Pages/drawer/widget/DrawerItem.dart';
import 'package:myproject/Admin_Pages/drawer/widget/DrawerHeader.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawerAdmin extends StatefulWidget {
  @override
  State<navigationDrawerAdmin> createState() => _navigationDrawerAdminState();
}

String? AdminDrawerEmail;

class _navigationDrawerAdminState extends State<navigationDrawerAdmin> {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        pr.show();
        prefs.remove("Login");
        prefs.remove("is_Open");
        pr.hide().whenComplete(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Admin_Login_Page(),
            ),
          );
        });
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

  void getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AdminDrawerEmail = prefs.getString("Email");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmail();
  }

  String users = "0";
  String drivers = "0";
  String accepeddrivers = "0";
  String rejecteddrivers = "0";
  String tripsontheway = "0";
  String feedbacks = "0";
  String widrawrequest = "";
  String f1 = "";
  String f2 = "";

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('Users').get().then(((value) {
      setState(() {
        users = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "1")
        .get()
        .then(((value) {
      setState(() {
        drivers = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "2")
        .get()
        .then(((value) {
      setState(() {
        accepeddrivers = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver')
        .where("Approved", isEqualTo: "3")
        .get()
        .then(((value) {
      setState(() {
        rejecteddrivers = value.size.toString();
      });
    }));
    // FirebaseFirestore.instance.collection('User Feedback').get().then(((value) {
    //   feedbacks = value.size.toString();
    // }));
    FirebaseFirestore.instance.collection('User Feedback').get().then(((value) {
      setState(() {
        f1 = value.size.toString();
      });
    }));
    FirebaseFirestore.instance
        .collection('Driver Feedback')
        .get()
        .then(((value) {
      setState(() {
        f2 = value.size.toString();
      });
    }));

    setState(() {
      int x = int.tryParse(f1) ?? 0;
      int y = int.tryParse(f2) ?? 0;
      int z = x + y;
      String c = z.toString();
      feedbacks = z.toString();
    });
    FirebaseFirestore.instance
        .collection('Driver')
        .where("On Trip", isEqualTo: "Yes")
        .get()
        .then(((value) {
      tripsontheway = value.size.toString();
    }));
    FirebaseFirestore.instance
        .collection('Payment Request')
        .where("Status", isEqualTo: "0")
        .get()
        .then(((value) {
      setState(() {
        widrawrequest = value.size.toString();
      });
    }));
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(),
          createDrawerBodyItem(
            icon: Icons.home,
            text: 'Dashboard',
            count: users,
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.AdminDashboard),
          ),
          createDrawerBodyItem(
            icon: Icons.account_circle,
            text: 'Users',
            count: users,
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.Users),
          ),
          createDrawerBodyItem(
            icon: Icons.account_box,
            text: 'Drivers Applications',
            count: drivers,
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.Drivers),
          ),
          createDrawerBodyItem(
            icon: Icons.check_box,
            text: 'Approved Drivers',
            count: accepeddrivers,
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.AcceptedDrivers),
          ),
          createDrawerBodyItem(
            icon: Icons.close_sharp,
            text: 'Rejected Drivers',
            count: rejecteddrivers,
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.RejectedDrivers),
          ),
          createDrawerBodyItem(
            icon: Icons.car_rental_sharp,
            text: 'Trips on the way',
            count: tripsontheway,
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.TripsOnTheWay),
          ),
          createDrawerBodyItem(
            icon: Icons.card_giftcard,
            text: 'Widraw Request',
            count: widrawrequest,
            onTap: () =>
                Navigator.pushReplacementNamed(context, MyRoutes.widrawrequest),
          ),
          createDrawerBodyItem(
            icon: Icons.history,
            text: 'History',
            count: users,
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.MyAdminHistory),
          ),
          Divider(),
          createDrawerBodyItem(
            icon: Icons.star,
            text: 'Feedbacks',
            count: feedbacks,
            onTap: () => Navigator.pushReplacementNamed(
                context, MyRoutes.FeedbackScreen),
          ),
          createDrawerBodyItem(
            icon: Icons.exit_to_app,
            text: 'Logout',
            count: users,
            onTap: () => showAlertDialog(context),
          ),
          SizedBox(
            height: 180,
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
