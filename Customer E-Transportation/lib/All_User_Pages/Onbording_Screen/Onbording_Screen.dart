import 'package:flutter/material.dart';
import 'package:introscreenonboarding/introduction.dart';
import 'package:introscreenonboarding/introscreenonboarding.dart';
import 'package:myproject/All_User_Pages/Initial_Page/Initial_Page.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Onboarding_Screen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Credentials',
      subTitle: 'Enter your personal details and trip details.',
      imageUrl: 'Assets/Images/Onbording_Screen/Onbording1.png',
    ),
    Introduction(
      title: 'Choose Locations',
      subTitle: 'Choose the location to deliver your goods',
      imageUrl: 'Assets/Images/Onbording_Screen/Onbording2.png',
    ),
    Introduction(
      title: 'Safe goods Transport',
      subTitle: 'Make your business and life easy.',
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

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:myproject/Utils/routes.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// class Onboarding_Screen extends StatefulWidget {
//   const Onboarding_Screen({Key? key}) : super(key: key);

//   @override
//   State<Onboarding_Screen> createState() => _Onboarding_ScreenState();
// }

// class _Onboarding_ScreenState extends State<Onboarding_Screen> {
//   final controller = PageController();
//   bool onLastPage = false;
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(),
//         child: PageView(
//           controller: controller,
//           onPageChanged: (index) {
//             setState(() {
//               onLastPage = index == 3;
//             });
//           },
//           children: [
//             Column(
//               children: [
//                 Container(
//                   height: 500,
//                   decoration: BoxDecoration(
//                     // borderRadius: BorderRadius.only(
//                     //   bottomLeft: Radius.circular(40),
//                     //   bottomRight: Radius.circular(40),
//                     // ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.8),
//                         spreadRadius: 2,
//                         blurRadius: 6,
//                         offset: Offset(0, 2), // changes position of shadow
//                       ),
//                     ],
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         "https://i.pinimg.com/564x/d3/73/0d/d3730d1e12d29eeb1f02a9ab1e09f578.jpg",
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25,
//                 ),
//                 Container(
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           "Crenditial",
//                           style: GoogleFonts.elMessiri(
//                             fontSize: 35,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           "Choose location to deliver your goods",
//                           style: GoogleFonts.elMessiri(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   decoration: (BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.8),
//                           spreadRadius: 2,
//                           blurRadius: 6,
//                           offset: Offset(0, 2), // changes position of shadow
//                         ),
//                       ],
//                       border: Border.all(width: 3, color: Colors.deepPurple),
//                       borderRadius: BorderRadius.circular(40))),
//                   height: 150,
//                   width: MediaQuery.of(context).size.width / 1.05,
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 Container(
//                   height: 550,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         "https://i.pinimg.com/564x/7f/19/36/7f1936b7c0bbbb872bda1d9e1922c1cc.jpg",
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 220,
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 Container(
//                   height: 550,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         "https://i.pinimg.com/564x/17/72/08/177208c9a5559cc99f2d86b0deb919d0.jpg",
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 220,
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 Container(
//                   height: 550,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         "https://i.pinimg.com/564x/7a/f1/66/7af16687c6c6c21243422279c6e61390.jpg",
//                       ),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   height: 220,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: onLastPage
//           ? Container(
//               height: 70,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       controller.previousPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOutSine,
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 12),
//                       child: Container(
//                         height: 45,
//                         width: 75,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Icon(
//                               Icons.arrow_back_ios,
//                               color: Colors.deepPurple,
//                             ),
//                             Text(
//                               "Back",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                           ],
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.8),
//                               spreadRadius: 2,
//                               blurRadius: 6,
//                               offset:
//                                   Offset(0, 2), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SmoothPageIndicator(
//                     controller: controller,
//                     count: 4,
//                     effect: ScrollingDotsEffect(
//                       activeStrokeWidth: 3,
//                       activeDotScale: 1.7,
//                       maxVisibleDots: 5,
//                       radius: 4,
//                       spacing: 12,
//                       dotHeight: 10,
//                       dotWidth: 10,
//                       activeDotColor: Colors.deepPurple,
//                     ),
//                     onDotClicked: (index) {
//                       controller.jumpToPage(index);
//                     },
//                   ),
//                   InkWell(
//                     onTap: () {
//                       controller.nextPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOutSine,
//                       );
//                       Navigator.pushNamed(context, MyRoutes.initialpageRoute);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 12),
//                       child: Container(
//                         height: 45,
//                         width: 75,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Text(
//                               "Done",
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.w300,
//                               ),
//                             ),
//                             Icon(
//                               Icons.arrow_forward_ios,
//                               color: Colors.deepPurple,
//                             ),
//                           ],
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.8),
//                               spreadRadius: 2,
//                               blurRadius: 6,
//                               offset:
//                                   Offset(0, 2), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Container(
//               height: 70,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       controller.previousPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOutSine,
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20),
//                       child: Container(
//                         height: 45,
//                         width: 45,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 6),
//                           child: Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.deepPurple,
//                           ),
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.8),
//                               spreadRadius: 2,
//                               blurRadius: 6,
//                               offset:
//                                   Offset(0, 2), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SmoothPageIndicator(
//                     controller: controller,
//                     count: 4,
//                     effect: ScrollingDotsEffect(
//                       activeStrokeWidth: 3,
//                       activeDotScale: 1.7,
//                       maxVisibleDots: 5,
//                       radius: 4,
//                       spacing: 12,
//                       dotHeight: 10,
//                       dotWidth: 10,
//                       activeDotColor: Colors.deepPurple,
//                     ),
//                     onDotClicked: (index) {
//                       controller.jumpToPage(index);
//                     },
//                   ),
//                   InkWell(
//                     onTap: () {
//                       controller.nextPage(
//                         duration: Duration(milliseconds: 500),
//                         curve: Curves.easeInOutSine,
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 20),
//                       child: Container(
//                         height: 45,
//                         width: 45,
//                         child: Icon(
//                           Icons.arrow_forward_ios,
//                           color: Colors.deepPurple,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.8),
//                               spreadRadius: 2,
//                               blurRadius: 6,
//                               offset:
//                                   Offset(0, 2), // changes position of shadow
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }
