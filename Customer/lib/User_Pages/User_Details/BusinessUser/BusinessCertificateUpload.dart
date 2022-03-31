import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/User_Details/API/Firebase_API.dart';
import 'package:myproject/User_Pages/User_Details/Widget/Button_Widget.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BusinessUserDocList.dart';

class BusinessCertificateUpload extends StatefulWidget {
  @override
  State<BusinessCertificateUpload> createState() =>
      _BusinessCertificateUploadState();
}

class _BusinessCertificateUploadState extends State<BusinessCertificateUpload> {
  @override
  UploadTask? task;
  File? file;
  String? urlDownload;
  bool image_pick = true;
  TextEditingController _BusinessNamecontroller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
    uploadFile();
  }

  String? MyUserID;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
    });
  }

  var User;
  @override
  Widget build(BuildContext context) {
    print(MyUserID);
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
            "Business Certificate",
          ),
          backgroundColor: Colors.deepPurple,
          automaticallyImplyLeading: true,
          elevation: 1,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            SizedBox(height: 15),
            Button_Widget(
              text: 'Select File',
              icon: Icons.attach_file,
              onClicked: selectFile,
            ),
            SizedBox(height: 13),
            Text(
              fileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 60),
            Button_Widget(
              text: 'Upload File',
              icon: Icons.cloud_upload_outlined,
              onClicked: () async {
                if (image_pick) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "No selected file, Please select the file first."),
                      backgroundColor: Colors.black,
                    ),
                  );
                } else {
                  uploadFile();
                }
              },
            ),
            SizedBox(height: 32),
            task != null ? buildUploadStatus(task!) : Container(),
            SizedBox(height: 330),
            InkWell(
              onTap: () async {
                print(MyUserID);
                if (image_pick) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text("Please upload your business certificate file."),
                      backgroundColor: Colors.black,
                    ),
                  );
                } else {
                  await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(MyUserID)
                      .update({
                    'business certificate': urlDownload,
                  });

                  c = 1;
                  Navigator.pop(context);
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
    if (file != null) {
      image_pick = false;
    }
  }

  Future uploadFile() async {
    if (file == null) return;
    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');

    return urlDownload;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Container(
              child: Text(
                '$percentage %',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container();
          }
        },
      );
}
