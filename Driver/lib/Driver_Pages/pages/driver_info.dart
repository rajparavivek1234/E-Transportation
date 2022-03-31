// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, unused_field, prefer_final_fields, prefer_typing_uninitialized_variables, avoid_print, unnecessary_const, unused_import, body_might_complete_normally_nullable, import_of_legacy_library_into_null_safe, prefer_const_constructors, duplicate_ignore

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_owner_info.dart';
import 'package:path/path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class driver_info extends StatefulWidget {
  @override
  _driver_infoState createState() => _driver_infoState();
}

String? f;
String? l;
String? d;
String? a;
String? city;
String? s;
String? url;
String? di;
String? document;
int _value = 1;
int? choose;

String? MyDriverID;

class _driver_infoState extends State<driver_info> {
  CollectionReference User = FirebaseFirestore.instance.collection('Driver');

  File? _image;

  String? myentryid1;
  bool _isLoading = false;
  File? pickedImage;
  bool image_pick = true;

  bool showPassword = false;
  File? imageFile;
  DateTime _date = DateTime.now();

  TextEditingController _FirstNamecontroller = TextEditingController();
  TextEditingController _LastNamecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _Addresscontroller = TextEditingController();
  TextEditingController _Address1controller = TextEditingController();
  TextEditingController _Citycontroller = TextEditingController();
  TextEditingController _Statecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var firebaseInstance;

  void _showDatePicker(BuildContext context) async {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        print(value!.day.toString());
        _date = value;
        _datecontroller.text = _date.day.toString() +
            "-" +
            _date.month.toString() +
            "-" +
            _date.year.toString();
      });
    });
  }

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

  String? FN;
  String? LN;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyDriverID = prefs.getString("DriverAuthID");
      id = MyDriverID;
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

  //Future<void> uploadPic() async {

  // }

  @override
  Widget build(BuildContext context) {
    print(FN);
    _FirstNamecontroller.text = FN.toString();
    _LastNamecontroller.text = LN.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Driver Details",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              children: [
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
                              onPressed: imagePickerOption),
                        ),
                      )
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
                      f = value;
                    },
                    controller: _FirstNamecontroller,
                    decoration: const InputDecoration(
                      labelText: "First Name",
                      hintText: "ex:jay",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "First Name Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z]+|\s").hasMatch(value)) {
                        return "Enter Correct First Name";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      l = value;
                    },
                    controller: _LastNamecontroller,
                    decoration: const InputDecoration(
                      labelText: "Last Name ",
                      hintText: "Ex. patel",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Last Name Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z]+|\s").hasMatch(value)) {
                        return "Enter Correct Last Name";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onTap: () => _showDatePicker(context),
                    readOnly: true,
                    controller: _datecontroller,
                    decoration: InputDecoration(
                      labelText: "DOB",
                      suffixIcon: InkWell(
                        child: const Icon(Icons.date_range),
                        onTap: () => _showDatePicker(context),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Date Of Birth Can't be Empty.";
                      } else if (!RegExp(
                              r"[0-9]{2}[-]{1}[0-9]{2}[-]{1}[0-9]{4}")
                          .hasMatch(value)) {
                        return "Enter Correct Date Of Birth";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      a = value;
                    },
                    controller: _Addresscontroller,
                    decoration: const InputDecoration(
                      labelText: "Address ",
                      hintText: "Ex. 321 , krishna so",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Address Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z,]+|\s").hasMatch(value)) {
                        return "Enter Correct Address";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      city = value;
                    },
                    controller: _Citycontroller,
                    decoration: const InputDecoration(
                      labelText: "City ",
                      hintText: "Ex. Nadiad",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "City Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
                        return "Enter Correct City";
                      }
                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    onChanged: (value) {
                      s = value;
                    },
                    controller: _Statecontroller,
                    decoration: const InputDecoration(
                      labelText: "State ",
                      hintText: "Ex. Gujrat",
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "State Can't be Empty.";
                      } else if (!RegExp(r"^[a-zA-Z]").hasMatch(value)) {
                        return "Enter Correct State";
                      }
                      null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                RadioListTile(context),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    ProgressDialog pr = ProgressDialog(context);
                    if (image_pick) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: const Text("Please upload profile pic."),
                          backgroundColor: Colors.black,
                        ),
                      );
                    } else {
                      if (_formKey.currentState!.validate()) {
                        if (_value == 2) {
                          choose = 2;
                          pr.show();
                          if (imageFile == null) return;
                          String fileName = basename(imageFile!.path);
                          Reference storage = FirebaseStorage.instance
                              .ref()
                              .child('Driver Profile/$fileName');
                          UploadTask uploadTask = storage.putFile(imageFile!);
                          String url =
                              await (await uploadTask).ref.getDownloadURL();
                          d = _datecontroller.text;
                          di = url;
                          await FirebaseFirestore.instance
                              .collection("Driver")
                              .doc(MyDriverID)
                              .update({
                            'DOB': d,
                            'Address': a,
                            'City': city,
                            'State': s,
                            'Driver Image': url,
                            'Owner Of Vehicle': 'Yes',
                            'earning': "0.0",
                            'Total Withdraw': "0.0",
                            'Total earning': "0.0",
                            'Total User': "0",
                            'User Rating': "0",
                            'Avg Rating': "0",
                          });
                          pr.hide().whenComplete(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    vahicle_owner_info(myentryid1: myentryid1),
                              ),
                            );
                          });
                        } else if (_value == 1) {
                          choose = 1;
                          pr.show();
                          if (imageFile == null) return;
                          String fileName = basename(imageFile!.path);
                          Reference storage = FirebaseStorage.instance
                              .ref()
                              .child('Driver Profile/$fileName');
                          UploadTask uploadTask = storage.putFile(imageFile!);
                          String url =
                              await (await uploadTask).ref.getDownloadURL();
                          d = _datecontroller.text;
                          di = url;
                          await FirebaseFirestore.instance
                              .collection("Driver")
                              .doc(MyDriverID)
                              .update({
                            'DOB': d,
                            'Address': a,
                            'City': city,
                            'State': s,
                            'Driver Image': url,
                            'Owner Of Vehicle': 'Yes',
                            'earning': "0.0",
                            'Total Withdraw': "0.0",
                            'Total earning': "0.0",
                            'Total User': "0",
                            'User Rating': "0",
                            'Avg Rating': "0",
                          });

                          pr.hide().whenComplete(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    vahicle_info(myentryid1: myentryid1),
                              ),
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
                    // ignore: prefer_const_constructors
                    child: Text(
                      "Submit",
                      // ignore: prefer_const_constructors
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
                // ignore: prefer_const_constructors
                SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget RadioListTile(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'You Have Your Own Vehicle:',
              style: TextStyle(fontSize: 17),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text('Yes'),
            leading: Radio(
              value: 1,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = 1;
                });
                print(_value);
              },
              activeColor: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: const Text('No'),
            leading: Radio(
              value: 2,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = 2;
                });
                print(_value);
              },
              activeColor: Colors.deepPurple,
            ),
          ),
        ]);
  }
}
