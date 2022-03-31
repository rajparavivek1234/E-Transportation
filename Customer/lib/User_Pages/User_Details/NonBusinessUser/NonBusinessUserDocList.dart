import 'package:flutter/material.dart';
import 'package:myproject/User_Pages/User_Details/NonBusinessUser/NonBusinessAdharcardUpload.dart';
import 'package:myproject/Utils/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NonBusinessUserDocList extends StatefulWidget {
  @override
  _NonBusinessUserDocListState createState() => _NonBusinessUserDocListState();
}

int n = 0;

class _NonBusinessUserDocListState extends State<NonBusinessUserDocList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            "Non Business User",
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: true,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 460),
                child: Container(
                  height: 75,
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NonBusinessAdharcardUpload(),
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
            SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () async {
                if (n == 1) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("isDetailsAdded", "Yes");
                  await prefs.setString("is_Open", "Yes");
                  Navigator.pushNamed(context, MyRoutes.homeRoute);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please upload your Aadhar Card"),
                      backgroundColor: Colors.black,
                    ),
                  );
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
    );
  }
}
