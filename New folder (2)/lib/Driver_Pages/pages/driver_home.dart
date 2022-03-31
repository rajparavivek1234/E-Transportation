// ignore_for_file: use_key_in_widget_constructors, camel_case_types, deprecated_member_use, prefer_const_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/mapview.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class home_page extends StatefulWidget {
  @override
  _home_pageState createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: mapview());
  }
}
