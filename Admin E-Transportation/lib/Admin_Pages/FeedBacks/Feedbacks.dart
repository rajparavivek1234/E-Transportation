import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/FeedBacks/Driver_Feedback.dart';
import 'package:myproject/Admin_Pages/FeedBacks/User_Feedback.dart';
import 'package:myproject/Admin_Pages/Users/Users.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';

import '../../Utils/routes.dart';

class Admin_Feedback_Screen extends StatefulWidget {
  @override
  _Admin_Feedback_ScreenState createState() => _Admin_Feedback_ScreenState();
}

class _Admin_Feedback_ScreenState extends State<Admin_Feedback_Screen> {
  List<Widget> _tabs = [
    User_Feedback(),
    Driver_Feedback(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          await Navigator.pushReplacementNamed(
              context, MyRoutes.AdminDashboard);
          return true;
        },
        child: Scaffold(
          drawer: navigationDrawerAdmin(),
          appBar: AppBar(
            title: Text("Feedbacks"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "User Feedback",
                ),
                Tab(
                  text: "Driver Feedback",
                ),
              ],
            ),
          ),
          body: Center(child: TabBarView(children: _tabs)),
        ),
      ),
    );
  }
}
