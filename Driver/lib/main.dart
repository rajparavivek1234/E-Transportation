// ignore_for_file: prefer_const_constructors, missing_required_param
// @dart=2.9
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myproject/All_User_Pages/Forgot_password/Forgot_password.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';
import 'package:myproject/All_User_Pages/Login_Page/Login_Page.dart';
import 'package:myproject/All_User_Pages/Phone_Auth/Phone_Number.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
// ignore: unused_import
import 'package:myproject/All_User_Pages/Splash_Screen/Splash_Screen.dart';
import 'package:myproject/All_User_Pages/google_sign_in/google_sign_in.dart';
import 'package:myproject/Driver_Pages/pages/MyTrips.dart';
import 'package:myproject/Driver_Pages/pages/about_us.dart';
import 'package:myproject/Driver_Pages/pages/accept_request.dart';
import 'package:myproject/Driver_Pages/pages/contact_us.dart';
import 'package:myproject/Driver_Pages/pages/d_update_document.dart';
import 'package:myproject/Driver_Pages/pages/dando_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_home.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/earning.dart';
import 'package:myproject/Driver_Pages/pages/history.dart';
import 'package:myproject/Driver_Pages/pages/home.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/profile.dart';
import 'package:myproject/Driver_Pages/pages/request_list.dart';
import 'package:myproject/Driver_Pages/pages/upload_document.dart';
import 'package:myproject/Driver_Pages/pages/v_update_document.dart';
import 'package:myproject/Driver_Pages/pages/v_upload_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_owner_info.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:provider/provider.dart';

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
          debugShowCheckedModeBanner: false,
          // home: FirebaseAuth.instance.currentUser == null
          //     ? Initial_Page()
          //     : Home_Page(),
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
            MyRoutes.initialRoute: (context) => Splash_Screen(),
            MyRoutes.initialpageRoute: (context) => Initial_Page(),
            MyRoutes.loginRoute: (context) => Login_Page(),
            MyRoutes.signUpRoute: (context) => SignUp(),
            MyRoutes.forgotPasswordRoute: (context) => Forgot_password(),
            MyRoutes.phoneVerification: (context) => Phone_Number(),
            MyRoutes.homeRoute: (context) => home(),
            MyRoutes.home_pageRoute: (context) => home_page(),
            MyRoutes.mapviewRoute: (context) => mapview(),
            MyRoutes.driver_infoRoute: (context) => driver_info(),

            MyRoutes.vahicle_infoRoute: (context) => vahicle_info(),
            MyRoutes.accept_requestRoute: (context) => accept_request(),
            MyRoutes.driver_infoRoute: (context) => driver_info(),

            MyRoutes.driver_infoRoute: (context) => driver_info(),
            MyRoutes.request_listRoute: (context) => request_list(),
            MyRoutes.driver_infoRoute: (context) => driver_info(),
            MyRoutes.driver_documentRoute: (context) => driver_document(),
            MyRoutes.vahicle_owner_infoRoute: (context) => vahicle_owner_info(),
            MyRoutes.upload_documentRoute: (context) => upload_document(),
            MyRoutes.vahicle_documentRoute: (context) => vahicle_document(),
            MyRoutes.dando_documentRoute: (context) => dando_document(),
            MyRoutes.v_upload_documentRoute: (context) => v_upload_document(),
            // MyRoutes.o_upload_documentRoute: (context) => o_upload_document(),
            MyRoutes.about_usRoute: (context) => about_us(),
            MyRoutes.contact_usRoute: (context) => contact_us(),
            MyRoutes.d_update_documentRoute: (context) => d_update_document(),
            MyRoutes.earningRoute: (context) => earning(),
            MyRoutes.historyRoute: (context) => history(),
            MyRoutes.profileRoute: (context) => profile(),
            MyRoutes.v_update_documentRoute: (context) => v_update_document(),
            MyRoutes.MyTripsRoute: (context) => MyTrips(),
          },
        ),
      );
}
