// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

Widget createDrawerBodyItem(
    {required IconData icon,
    required String text,
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
          Text(text),
        ],
      ),
    ),
    onTap: onTap,
  );
}
