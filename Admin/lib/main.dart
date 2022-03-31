import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myproject/Admin_Pages/AdminLogin/AdminLogin.dart';
import 'package:myproject/Admin_Pages/CompletedTrips/CompletedTrips.dart';
import 'package:myproject/Admin_Pages/Dashboard.dart/Dashboard.dart';
import 'package:myproject/Admin_Pages/Drivers/Accpted_Rejected_driver.dart/AcceptedDriver.dart';
import 'package:myproject/Admin_Pages/Drivers/Accpted_Rejected_driver.dart/RejectedDriver.dart';
import 'package:myproject/Admin_Pages/Drivers/Drivers.dart';
import 'package:myproject/Admin_Pages/FeedBacks/Feedbacks.dart';
import 'package:myproject/Admin_Pages/TripsOnTheWay/TripsOntheWay.dart';
import 'package:myproject/Admin_Pages/Users/Users.dart';
import 'package:myproject/Admin_Pages/WidrawRequest/WidrawRequestList.dart';

import 'package:myproject/Admin_Pages/AdminLogin/Splash_Screen.dart';
import 'package:provider/provider.dart';
import 'Utils/routes.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MyApp(),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GetMaterialApp(
        title: "My app",
        themeMode: ThemeMode.light,
        theme: ThemeData(
          textTheme: GoogleFonts.questrialTextTheme(
            Theme.of(context).textTheme,
          ),
          primarySwatch: Colors.deepPurple,
        ),
        builder: EasyLoading.init(),
        darkTheme: ThemeData(primarySwatch: Colors.brown),
        routes: {
          MyRoutes.initialRoute: (context) => Splash_Screen_Admin(),

          //MyRoutes.phoneVerification: (context) => Phone_Number(),

          MyRoutes.AdminDashboard: (context) => Dashboard(),
          MyRoutes.Drivers: (context) => Drivers(),
          MyRoutes.Users: (context) => Users(),

          MyRoutes.FeedbackScreen: (context) => Admin_Feedback_Screen(),
          MyRoutes.AcceptedDrivers: (context) => Accepted_Drivers(),
          MyRoutes.RejectedDrivers: (context) => Rejected_Drivers(),
          MyRoutes.TripsOnTheWay: (context) => TripsOnTheWay(),

          MyRoutes.MyAdminHistory: (context) => CompletedTrips(),
          MyRoutes.widrawrequest: (context) => WidrawRequestList()
        },
      ),
    );
  }
}
