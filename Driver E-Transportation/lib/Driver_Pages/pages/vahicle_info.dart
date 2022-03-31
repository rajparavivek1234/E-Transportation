// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable, deprecated_member_use, unused_import, body_might_complete_normally_nullable, prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myproject/Driver_Pages/pages/dando_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_document.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_owner_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class vahicle_info extends StatefulWidget {
  String? myentryid1;
  vahicle_info({Key? key, this.myentryid1}) : super(key: key);
  @override
  _vahicle_infoState createState() => _vahicle_infoState();
}

//String? vtid;
String? vid;
String? id;
String? t;
String? y;
String? n;
String? vurl;
String? price;

class _vahicle_infoState extends State<vahicle_info> {
  File? _image;
  bool image_pick = true;
  String? myentryid1;
  bool _isLoading = false;
  File? pickedImage;
  int _value = 1;
  bool showPassword = false;
  File? imageFile;
  DateTime _date = DateTime.now();

  TextEditingController _VahicleNocontroller = TextEditingController();

  var firebaseInstance;
  final _formKey = GlobalKey<FormState>();

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: Container(
            color: Colors.white,
            height: 210,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Pic Image From",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("CAMERA"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.image),
                      label: const Text("GALLERY"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("CANCEL"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future cropImage(filePath) async {
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ));

    setState(() {
      imageFile = croppedFile;
    });
    if (imageFile != null) {
      image_pick = false;
    }
    print(imageFile);
  }

  Future pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) return;
      final tempImage = File(photo.path);

      cropImage(photo.path);

      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  //Future<void> uploadPic() async {

  // }
  String? FN;
  String? LN;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      FN = prefs.getString("Firstname");
      LN = prefs.getString("Lastname");
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Vehicle Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(children: [
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 4,
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.1),
                            offset: const Offset(5, 15),
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: imageFile != null
                            ? Image.file(
                                imageFile!,
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                'https://freesvg.org/img/abstract-user-flat-4.png',
                                width: 130,
                                height: 130,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.deepPurple,
                        ),
                        child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              imagePickerOption();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextFormField(
                  onChanged: (value) {
                    n = value;
                  },
                  controller: _VahicleNocontroller,
                  decoration: const InputDecoration(
                    labelText: "Vehicle No. ",
                    hintText: "Ex. XX-00-XX-0000",
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Vehicle No. Can't be Empty.";
                    } else if (!RegExp(
                            r"[A-Z]{2}[-]{1}[0-9]{2}[-]{1}[A-Z]{2}[-]{1}[0-9]{4}")
                        .hasMatch(value)) {
                      return "Enter Correct Vehicle No.";
                    }
                    null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  // ignore: prefer_const_literals_to_create_immutables
                  items: [
                    "ACE / Dost / PICKUP (1.5 TON)",
                    "TATA 407/ EICHER 14FT (4 TON)",
                    "EICHER 17FT (5 TON)",
                    "EICHER 19FT (7 TON)",
                    "TATA TRUCK  (10 TON)",
                    "20FT CONTAINER (6.5 TON)",
                    "32FT CONTAINER (14 TON)",
                    "32 / 40 FEET OPEN TRAILER"
                  ],
                  label: "Type Of Vehicle",
                  hint: "Select Vehicle Type",
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  validator: (value) =>
                      value == null ? "Vehicle type. Can't be Empty." : null,
                  onChanged: (value) {
                    t = value!;
                    if (t == "ACE / Dost / PICKUP (1.5 TON)") {
                      price = "30";
                    } else if (t == "TATA 407/ EICHER 14FT (4 TON)") {
                      price = "80";
                    } else if (t == "EICHER 17FT (5 TON)") {
                      price = "100";
                    } else if (t == "EICHER 19FT (7 TON)") {
                      price = "140";
                    } else if (t == "TATA TRUCK  (10 TON)") {
                      price = "200";
                    } else if (t == "20FT CONTAINER (6.5 TON)") {
                      price = "130";
                    } else if (t == "32FT CONTAINER (14 TON)") {
                      price = "280";
                    } else if (t == "32 / 40 FEET OPEN TRAILER") {
                      price = "180";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: DropdownSearch<String>(
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  // ignore: prefer_const_literals_to_create_immutables
                  items: [
                    "2021 Or After",
                    "2016 - 2020 Year",
                    "2011 - 2015 Year",
                    "2006 - 2010 Year",
                    "2005 Or Before",
                  ],
                  label: "Year Of MOdel",
                  hint: "Select Year Of Model",
                  validator: (value) =>
                      value == null ? "Year Of Model Can't be Empty." : null,
                  popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: (value) {
                    y = value!;
                  },
                ),
              ),
              SizedBox(
                height: 230,
              ),
              InkWell(
                onTap: () async {
                  ProgressDialog pr = ProgressDialog(context);
                  if (image_pick) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        // ignore: unnecessary_const
                        content: const Text("Please upload profile pic."),
                        backgroundColor: Colors.black,
                      ),
                    );
                  } else {
                    if (_formKey.currentState!.validate()) {
                      pr.show();

                      if (imageFile == null) return;
                      String fileName = basename(imageFile!.path);
                      Reference storage = FirebaseStorage.instance
                          .ref()
                          .child('vehicle info/$fileName');
                      UploadTask uploadTask = storage.putFile(imageFile!);
                      String url =
                          await (await uploadTask).ref.getDownloadURL();

                      await FirebaseFirestore.instance
                          .collection("vehicle")
                          .add({
                        'First Name': FN.toString(),
                        'Last Name': LN.toString(),
                        'Vehicle Name': t,
                        'Year of Model': y,
                        'Price': price,
                        'Vehicle No': n,
                        'Vehicle Image': url,
                        'On Trip': 'No',
                        'Approved': 'No',
                        'Driver Id': MyDriverID,
                        'Total User': "0",
                        'User Rating': "0",
                        'Avg Rating': "0",
                      }).then((value) {
                        //print(value.id);
                        myentryid1 = value.id;
                        //print(myentryid);
                      });
                      vid = myentryid1;
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString("VehicleID", vid!);

                      // await FirebaseFirestore.instance
                      //     .collection("vehicle")253612
                      //     .doc(vid)
                      //     .collection(t!)
                      //     .add({
                      //   'First Name': f,
                      //   'Last Name': l,
                      //   'Vehicle Name': t,
                      //   'Year of Model': y,
                      //   'Price': price,
                      //   'Vehicle No': n,
                      //   'Vehicle Image': url,
                      //   'On Trip': 'No',
                      // }).then((value) {
                      //   //print(value.id);
                      //   myentryid1 = value.id;
                      //   //print(myentryid);
                      // });
                      // vtid = myentryid1;

                      if (choose == 2) {
                        await FirebaseFirestore.instance
                            .collection("Driver")
                            .doc(MyDriverID)
                            .update({
                          'Year of Model': y,
                          'Vehicle Name': t,
                          'Vehicle No': n,
                          'Vehicle Image': url,
                          'Approved': '1',
                          'Price': price,
                          'Vehicle ID': vid,
                        });
                        pr.hide().whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    dando_document(myentryid1: myentryid1)),
                          );
                        });
                      } else if (choose == 1) {
                        await FirebaseFirestore.instance
                            .collection("Driver")
                            .doc(id)
                            .update({
                          'Year of Model': y,
                          'Vehicle Name': t,
                          'On Trip': 'No',
                          'Vehicle No': n,
                          'Approved': '1',
                          'Vehicle Image': url,
                          'Price': price,
                          'Vehicle ID': vid,
                        });

                        pr.hide().whenComplete(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    driver_document(myentryid1: myentryid1)),
                          );
                        });
                      }
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
            ]),
          ),
        ),
      ),
    );
  }
}






// // ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, deprecated_member_use, non_constant_identifier_names, unnecessary_this, unused_import, must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:testing/pages/dando_document.dart';
// import 'package:testing/pages/driver_document.dart';
// import 'package:testing/pages/driver_info.dart';
// import 'package:testing/pages/vahicle_document.dart';

// class vahicle_info extends StatefulWidget {
//   String? myentryid1;
//   vahicle_info({Key? key, this.myentryid1}) : super(key: key);
//   @override
//   _vahicle_infoState createState() => _vahicle_infoState();
// }

// class _vahicle_infoState extends State<vahicle_info> {
//   bool showPassword = false;

//   List vahicle_type = ["truck", "truck1", "truck2", "truck3"];
//   List age_of_vahicle = ["1 to 5", "6 to 10", "11 or above"];
//   List vahicle_condition = ["up to date", "good", "medium"];

//   String vahicle_type_id = "-Select type of Vahicle-";
//   String age_of_vahicle_id = "-Select Age of Vahicle-";
//   String vahicle_condition_id = "-Select Condition of Vahicle-";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.only(
//           left: 16,
//           top: 15,
//           right: 16,
//         ),
//         child: GestureDetector(
//           onTap: () {
//             FocusScope.of(context).unfocus();
//           },
//           child: ListView(
//             children: [
//               Text(
//                 "Edit Vahicle Details",
//                 style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Center(
//                 child: Stack(
//                   children: [
//                     Container(
//                       width: 130,
//                       height: 130,
//                       decoration: BoxDecoration(
//                           border: Border.all(
//                               width: 4,
//                               color: Theme.of(context).scaffoldBackgroundColor),
//                           boxShadow: [
//                             BoxShadow(
//                                 spreadRadius: 2,
//                                 blurRadius: 10,
//                                 color: Colors.black.withOpacity(0.1),
//                                 offset: Offset(0, 10))
//                           ],
//                           shape: BoxShape.circle,
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                 "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
//                               ))),
//                     ),
//                     Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           height: 40,
//                           width: 40,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               width: 4,
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                             ),
//                             color: Colors.deepPurple,
//                           ),
//                           child: Icon(
//                             Icons.edit,
//                             color: Colors.white,
//                           ),
//                         )),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Text(
//                 "Vahicle Picture",
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Center(),
//               buildTextField("Vahicle Type", "Ex. jay", false),
//               buildTextField("Age of Vahicle", "Ex. patel", false),
//               buildTextField("Vahicle Number ", "Ex. AB-AB-0123", false),
//               buildTextField("Vahicle condition", "", false),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   OutlineButton(
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     onPressed: () {
//                       if (1 == 1) {
//                         //groupvalue
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => driver_document(
//                                       myentryid1: widget.myentryid1,
//                                     )));
//                       } else {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => dando_document(
//                                       myentryid1: widget.myentryid1,
//                                     )));
//                       }
//                     },
//                     child: Text("BACK",
//                         style: TextStyle(
//                             fontSize: 14,
//                             letterSpacing: 2.2,
//                             color: Colors.black)),
//                   ),
//                   RaisedButton(
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 vahicle_document(myentryid1: widget.myentryid1),
//                           ));
//                     },
//                     color: Colors.deepPurple,
//                     padding: EdgeInsets.symmetric(horizontal: 50),
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20)),
//                     child: Text(
//                       "NEXT",
//                       style: TextStyle(
//                           fontSize: 14,
//                           letterSpacing: 2.2,
//                           color: Colors.white),
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildTextField(
//       String labelText, String placeholder, bool isPasswordTextField) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 35.0),
//       child: TextField(
//         obscureText: isPasswordTextField ? showPassword : false,
//         decoration: InputDecoration(
//             suffixIcon: isPasswordTextField
//                 ? IconButton(
//                     onPressed: () {
//                       setState(() {
//                         showPassword = !showPassword;
//                       });
//                     },
//                     icon: Icon(
//                       Icons.remove_red_eye,
//                       color: Colors.grey,
//                     ),
//                   )
//                 : null,
//             contentPadding: EdgeInsets.only(bottom: 3),
//             labelText: labelText,
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             hintText: placeholder,
//             hintStyle: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             )),
//       ),
//     );
//   }
// }
