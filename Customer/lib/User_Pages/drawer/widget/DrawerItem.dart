import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    {required IconData icon,
    required String text,
    //required String count,
    required GestureTapCallback onTap}) {
  return ListTile(
    title: Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(text)
        ],
      ),
    ),
    onTap: onTap,
  );
}

// import 'package:flutter/material.dart';

// Widget createDrawerBodyItem(
//     {required IconData icon,
//     required String text,
//     required String count,
//     required GestureTapCallback onTap}) {
//   return ListTile(
//     title: Padding(
//       padding: const EdgeInsets.only(left: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: <Widget>[
//               Icon(icon),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(text),
//             ],
//           ),
//           text == "Home" ||
//                   text == "Logout" ||
//                   text == "History" ||
//                   text == "Feedback" ||
//                   count == "0"
//               ? Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     height: 20,
//                     width: 20,
//                   ),
//                 )
//               : Align(
//                   alignment: Alignment.centerRight,
//                   child: Container(
//                     height: 25,
//                     width: 25,
//                     child: Center(child: Text(count)),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 6,
//                           offset: Offset(0, 2), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     ),
//     onTap: onTap,
//   );
// }
