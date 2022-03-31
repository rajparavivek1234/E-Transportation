import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myproject/All_User_Pages/Forgot_password/Forgot_password.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/MyOrder/myorder_details.dart';
import 'package:myproject/All_User_Pages/MyOrder/myorder_list.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/Phone_Number.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/All_User_Pages/Splash_Screen/Splash_Screen.dart';
import 'package:myproject/All_User_Pages/google_sign_in/google_sign_in.dart';

import 'package:myproject/User_Pages/Feedback_Page/Feedback.dart';
import 'package:myproject/User_Pages/Map/Map_Screen.dart';
import 'package:myproject/User_Pages/Home_Page/Home_Page.dart';
import 'package:myproject/User_Pages/MyHistory/MyHistory.dart';
import 'package:myproject/User_Pages/Payment/Payment.dart';
import 'package:myproject/User_Pages/Profile/Profile.dart';
import 'package:myproject/User_Pages/ReceiverInfo/ReceiverInfo.dart';
import 'package:myproject/User_Pages/SelectVehicle/SelectVehicle.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/User_Pages/User_Details/User_Details.dart';
import 'package:myproject/User_Pages/WaitingScreen/WaitingScreen.dart';
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

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: GetMaterialApp(
          // home: FirebaseAuth.instance.currentUser == null
          //     ? Initial_Page()
          //     : Home_Page(),
          title: "My app",
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            textTheme: GoogleFonts.questrialTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.deepPurple,
          ),
          builder: EasyLoading.init(),
          darkTheme: ThemeData(primarySwatch: Colors.brown),
          routes: {
            // MyRoutes.myorder_list: (context) => myorder_list(),
            MyRoutes.initialRoute: (context) => Splash_Screen(),
            MyRoutes.initialpageRoute: (context) => Initial_Page(),
            MyRoutes.homeRoute: (context) => Home_Page(),
            MyRoutes.loginRoute: (context) => Login_Page(),
            MyRoutes.signUpRoute: (context) => SignUp(),
            MyRoutes.forgotPasswordRoute: (context) => Forgot_password(),
            //MyRoutes.phoneVerification: (context) => Phone_Number(),
            MyRoutes.myProfileRoute: (context) => profile(),
            MyRoutes.myHistory: (context) => MyHistory(),
            MyRoutes.myorder_list: (context) => myorder_list(),
            // MyRoutes.AdminDashboard: (context) => Dashboard(),
            // MyRoutes.Drivers: (context) => Drivers(),
            // MyRoutes.Users: (context) => Users(),
            MyRoutes.Map_Screen: (context) => Map_Screen(),
            MyRoutes.ReceiverInfo: (context) => ReceiverInfo(),
            MyRoutes.TripDetails: (context) => TripDetails(),
            MyRoutes.SelectVehicle: (context) => Select_Vehicle(),
            // MyRoutes.FeedbackScreen: (context) => Admin_Feedback_Screen(),
            // MyRoutes.AcceptedDrivers: (context) => Accepted_Drivers(),
            // MyRoutes.RejectedDrivers: (context) => Rejected_Drivers(),
            // MyRoutes.TripsOnTheWay: (context) => TripsOnTheWay(),
            MyRoutes.PaymentScreen: (context) => Payment(),
          },
        ),
      );
}
