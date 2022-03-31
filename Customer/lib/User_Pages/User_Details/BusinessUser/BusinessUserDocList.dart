import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/User_Details/BusinessUser/BusinessAdharcardUpload.dart';
import 'package:myproject/User_Pages/User_Details/BusinessUser/BusinessCertificateUpload.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessUserDocList extends StatefulWidget {
  @override
  _BusinessUserDocListState createState() => _BusinessUserDocListState();
}

int a = 0;
int c = 0;

class _BusinessUserDocListState extends State<BusinessUserDocList> {
  String? MyUserID;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  @override
  String? b;

  TextEditingController _BusinessNamecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            "Business User",
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: true,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    b = value;
                  },
                  controller: _BusinessNamecontroller,
                  decoration: InputDecoration(
                    labelText: "Business Name",
                    hintText: "ex:J PACK PVT.LTD",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Business Name can't be empty.";
                    }
                    return null;
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: Container(
                    height: 75,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessAdharcardUpload(),
                          ),
                        );
                      },
                      color: Theme.of(context).accentColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables

                        children: <Widget>[
                          Column(
                            children: [
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                'Aadhar Card',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 330),
                  child: Container(
                    height: 75,
                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessCertificateUpload(),
                          ),
                        );
                      },
                      color: Theme.of(context).accentColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables

                        children: <Widget>[
                          Column(
                            children: [
                              SizedBox(
                                height: 18,
                              ),
                              Text(
                                'Your Business Document',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  print(a);
                  print(c);
                  if (_formKey.currentState!.validate()) {
                    if (a == 1 && c == 1) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString("isDetailsAdded", "Yes");
                      await prefs.setString("is_Open", "Yes");
                      Navigator.pushNamed(context, MyRoutes.homeRoute);
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(MyUserID)
                          .update({
                        'Business name': b,
                      });
                    } else if (a == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please upload your Aadhar Card"),
                          backgroundColor: Colors.black,
                        ),
                      );
                    } else if (c == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please upload your Business Document"),
                          backgroundColor: Colors.black,
                        ),
                      );
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(seconds: 2),
                  width: 330,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
