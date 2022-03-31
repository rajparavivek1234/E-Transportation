// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, duplicate_ignore, override_on_non_overriding_member, camel_case_types, must_be_immutable, avoid_print, sized_box_for_whitespace, unnecessary_brace_in_string_interps, avoid_unnecessary_containers

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/d_update_document.dart';
import 'package:myproject/Driver_Pages/pages/dando_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:myproject/Utils/routes.dart';

import 'package:path/path.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myproject/Driver_Pages/api/firebase_api.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';

import 'package:myproject/Driver_Pages/widget/button_widget.dart';

class upload_document extends StatefulWidget {
  String? myentryid1;
  upload_document({Key? key, this.myentryid1}) : super(key: key);

  @override
  State<upload_document> createState() => _upload_documentState();
}

class _upload_documentState extends State<upload_document> {
  @override
  UploadTask? task;
  File? file;
  String? urlDownload;
  bool image_pick = true;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    uploadFile();
  }

  var User;
  @override
  Widget build(BuildContext context) {
    print(widget.myentryid1);
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "$document",
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            SizedBox(height: 15),
            ButtonWidget(
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
            ButtonWidget(
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
            Container(
              height: 30,
              child: task != null ? buildUploadStatus(task!) : Container(),
            ),
            SizedBox(height: 340),
            InkWell(
              onTap: () async {
                if (image_pick) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please upload your ${document}"),
                      backgroundColor: Colors.black,
                    ),
                  );
                } else {
                  await FirebaseFirestore.instance
                      .collection('Driver')
                      .doc(id)
                      .update({
                    '$document': urlDownload,
                  });
                  if (document == "Aadhar Card") {
                    a1 = 1;
                  } else if (document == "Licence") {
                    b1 = 1;
                  } else if (document == "Address Proof") {
                    c1 = 1;
                  } else if (document == "Owner Adharcard") {
                    d1 = 1;
                  } else if (document == "Owner Address Proof") {
                    e1 = 1;
                  }
                  if (page == 1) {
                    Navigator.pop(context, MyRoutes.driver_documentRoute);
                  } else if (page == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => d_update_document()));
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
    final destination = 'Driver/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
    //var DOC;
    //await DOC.add({
    //'docurl': urlDownload,
    //}).then((value) => print('User Added'));
    //return urlDownload;
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
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return Container();
          }
        },
      );
}










// // ignore_for_file: must_be_immutable, camel_case_types, prefer_final_fields, non_constant_identifier_names, unused_field, prefer_const_constructors, override_on_non_overriding_member, prefer_typing_uninitialized_variables, avoid_print, unused_import

// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:testing/api/firebase_api.dart';
// import 'package:testing/pages/driver_document.dart';
// import 'package:testing/utils/routes.dart';
// import 'package:testing/widget/button_widget.dart';

// class upload_document extends StatefulWidget {
//   String? myentryid1;
//   upload_document({Key? key, this.myentryid1}) : super(key: key);

//   @override
//   State<upload_document> createState() => _upload_documentState();
// }

// class _upload_documentState extends State<upload_document> {
//   @override
//   UploadTask? task;
//   File? file;
//   String? urlDownload;

//   @override
//   void initState() {
//     // ignore: todo
//     // TODO: implement initState
//     super.initState();
//     uploadFile();
//   }

//   var User;
//   @override
//   Widget build(BuildContext context) {
//     print(widget.myentryid1);
//     final fileName = file != null ? basename(file!.path) : 'No File Selected';
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           automaticallyImplyLeading: true,
//           elevation: 1,
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context, false),
//           )),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(32),
//         child: Column(
//           children: [
//             SizedBox(height: 15),
//             ButtonWidget(
//               text: 'Select File',
//               icon: Icons.attach_file,
//               onClicked: selectFile,
//             ),
//             SizedBox(height: 13),
//             Text(
//               fileName,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             SizedBox(height: 60),
//             ButtonWidget(
//               text: 'Upload File',
//               icon: Icons.cloud_upload_outlined,
//               onClicked: () async {
//                 uploadFile();
//               },
//             ),
//             SizedBox(height: 32),
//             task != null ? buildUploadStatus(task!) : Container(),
//             SizedBox(height: 330),
//             InkWell(
//               onTap: () async {
//                 // Navigator.push(context,
//                 //     MaterialPageRoute(builder: (context) => driver_document()));

//                 await FirebaseFirestore.instance
//                     .collection('Not Owner')
//                     .doc(widget.myentryid1)
//                     .update({
//                   '$document': urlDownload,
//                 });
//                 Navigator.pop(context, MyRoutes.driver_documentRoute);
//               },
//               child: AnimatedContainer(
//                 duration: Duration(seconds: 2),
//                 width: 330,
//                 height: 50,
//                 alignment: Alignment.center,
//                 child: Text(
//                   "Submit",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 decoration: BoxDecoration(
//                     color: Colors.deepPurple,
//                     borderRadius: BorderRadius.circular(25)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future selectFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: false);

//     if (result == null) return;
//     final path = result.files.single.path!;

//     setState(() => file = File(path));
//   }

//   Future uploadFile() async {
//     if (file == null) return;
//     final fileName = basename(file!.path);
//     final destination = 'driver_docuent/$fileName';

//     task = FirebaseApi.uploadFile(destination, file!);
//     setState(() {});

//     if (task == null) return;

//     final snapshot = await task!.whenComplete(() {});
//     urlDownload = await snapshot.ref.getDownloadURL();

//     print('Download-Link: $urlDownload');
//     //var DOC;
//     //await DOC.add({
//     //'docurl': urlDownload,
//     //}).then((value) => print('User Added'));
//     //return urlDownload;
//   }

//   Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
//         stream: task.snapshotEvents,
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             final snap = snapshot.data!;
//             final progress = snap.bytesTransferred / snap.totalBytes;
//             final percentage = (progress * 100).toStringAsFixed(2);

//             return Text(
//               '$percentage %',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             );
//           } else {
//             return Container();
//           }
//         },
//       );
// }
