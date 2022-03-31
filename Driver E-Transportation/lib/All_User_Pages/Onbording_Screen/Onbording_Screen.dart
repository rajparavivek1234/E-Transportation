// ignore_for_file: import_of_legacy_library_into_null_safe, file_names, camel_case_types, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:introscreenonboarding/introduction.dart';
import 'package:introscreenonboarding/introscreenonboarding.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';

class Onboarding_Screen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Credentials',
      subTitle: 'Enter your personal details and trip details.',
      imageUrl: 'Assets/Images/Onbording_Screen/Onbording1.png',
    ),
    Introduction(
      title: 'Choose Locations',
      subTitle: 'Choose staring and destination location to deliver your goods',
      imageUrl: 'Assets/Images/Onbording_Screen/Onbording2.png',
    ),
    Introduction(
      title: 'Safe goods Transport',
      subTitle:
          'Delivery your goods with us and make your business and life easy.',
      imageUrl: 'Assets/Images/Login_Page/Login_Image.png',
    ),
    Introduction(
      title: '24X7',
      subTitle: 'We are always avilable to make you happy.',
      imageUrl: 'Assets/Images/Onbording_Screen/Onbording4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Initial_Page(),
          ), //MaterialPageRoute
        );
      },
    );
  }
}
