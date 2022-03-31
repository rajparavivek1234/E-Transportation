import 'package:flutter/material.dart';
import 'package:myproject/Admin_Pages/drawer/navigationdrawer.dart';

Widget createDrawerHeader() {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Stack(children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 4,
                        blurRadius: 20,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(5, 15),
                      )
                    ],
                  ),
                  child: ClipOval(
                    child: AdminDrawerEmail == "pateltrushil046@gmail.com"
                        ? Image.asset(
                            "Assets/Images/Admin/Admin_T.jpeg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : AdminDrawerEmail == "prajapatinehansh1@gmail.com"
                            ? Image.asset(
                                "Assets/Images/Admin/Admin_N.jpeg",
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                            : AdminDrawerEmail == "rajparavivek1234@gmail.com"
                                ? Image.asset(
                                    "Assets/Images/Admin/Admin_V.jpeg",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    "https://freesvg.org/img/abstract-user-flat-4.png",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AdminDrawerEmail == "pateltrushil046@gmail.com"
                      ? "Trushil Patel"
                      : AdminDrawerEmail == "prajapatinehansh1@gmail.com"
                          ? "Nehansh Prajapati"
                          : AdminDrawerEmail == "rajparavivek1234@gmail.com"
                              ? "Vivek Rajpara"
                              : "",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  AdminDrawerEmail == "pateltrushil046@gmail.com"
                      ? "pateltrushil046@gmail.com"
                      : AdminDrawerEmail == "prajapatinehansh1@gmail.com"
                          ? "prajapatinehansh1@gmail.com"
                          : AdminDrawerEmail == "rajparavivek1234@gmail.com"
                              ? "rajparavivek1234@gmail.com"
                              : "",
                )
              ],
            ),
          ],
        ),
      ]));
}
