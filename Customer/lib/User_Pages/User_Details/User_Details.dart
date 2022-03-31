import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:myproject/All_User_Pages/SignUp/SignUp.dart';
import 'package:myproject/User_Pages/User_Details/BusinessUser/BusinessUserDocList.dart';
import 'package:myproject/User_Pages/User_Details/NonBusinessUser/NonBusinessUserDocList.dart';
import 'package:path/path.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_Details extends StatefulWidget {
  //String? codeDigits;
  //String? Phonenumber;
  // User_Details({Key? key, required this.codeDigits, required this.Phonenumber})
  //     : super(key: key);
  @override
  _User_DetailsState createState() => _User_DetailsState();
}

String? Firstname;
String? Lastname;
String? ProfilePic;
String? MobNo;
String? uid;
String? type;

class _User_DetailsState extends State<User_Details> {
  CollectionReference User = FirebaseFirestore.instance.collection('User');
  String? t;
  String? r;
  String? u;
  String? url;
  String? myentryid;
  File? pickedImage;
  int _value = 1;
  bool image_pick = true;
  File? imageFile;
  DateTime _date = DateTime.now();

  TextEditingController _FirstNamecontroller = TextEditingController();

  TextEditingController _LastNamecontroller = TextEditingController();
  TextEditingController _datecontroller = TextEditingController();
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
            height: 200,
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
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: filePath,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9,
        ],
        androidUiSettings: AndroidUiSettings(
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
    print(pickedImage);
  }

  //Future<void> uploadPic() async {

  // }
  String? MyUserID;
  String? FN;
  String? LN;
  void getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      MyUserID = prefs.getString("UserAuthID");
      FN = prefs.getString("Firstname");
      LN = prefs.getString("Lastname");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserCredentials();
  }

  @override
  Widget build(BuildContext context) {
    print(FN);
    print(LN);
    print("ID:${MyUserID}");
    _FirstNamecontroller.text = FN.toString();
    _LastNamecontroller.text = LN.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Details",
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            }),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            SizedBox(
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
                          offset: Offset(5, 15),
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
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          imagePickerOption();
                          print("Image picker option");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  t = value;
                },
                readOnly: true,
                controller: _FirstNamecontroller,
                decoration: InputDecoration(
                  labelText: "First Name",
                  hintText: "ex:jay",
                ),
                validator: (value) {
                  Firstname = value;
                  if (value == null || value.isEmpty) {
                    return "First can't be empty.";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: TextFormField(
                onChanged: (value) {
                  r = value;
                },
                readOnly: true,
                controller: _LastNamecontroller,
                decoration: InputDecoration(
                  labelText: "Last Name ",
                  hintText: "Ex.Patel",
                ),
                validator: (value) {
                  Lastname = value;
                  if (value == null || value.isEmpty) {
                    return "Last Name can't be empty.";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: TextFormField(
                onTap: () => _showDatePicker(context),
                readOnly: true,
                controller: _datecontroller,
                decoration: InputDecoration(
                  labelText: "DOB",
                  suffixIcon: InkWell(
                    child: Icon(Icons.date_range),
                    onTap: () => _showDatePicker(context),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "DOB can't be empty.";
                  }
                  return null;
                },
              ),
            ),
            RadioListTile(context),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () async {
                ProgressDialog pr = ProgressDialog(context);
                print(MyUserID);
                if (_value == 1) {
                  if (image_pick) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload the profile pic."),
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
                          .child('User Profile/$fileName');
                      UploadTask uploadTask = storage.putFile(imageFile!);
                      String url =
                          await (await uploadTask).ref.getDownloadURL();
                      ProfilePic = url;
                      u = _datecontroller.text;

                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(MyUserID)
                          .update({
                        'Type': type,
                        'DOB': u,
                        'url': url,
                      });
                      pr.hide().whenComplete(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusinessUserDocList(),
                          ),
                        );
                      });
                    }
                  }
                } else if (_value == 2) {
                  print("MY${MyUserID}");
                  if (image_pick) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please upload the profile pic."),
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
                          .child('User Profile/$fileName');
                      UploadTask uploadTask = storage.putFile(imageFile!);
                      String url =
                          await (await uploadTask).ref.getDownloadURL();
                      ProfilePic = url;
                      u = _datecontroller.text;

                      await FirebaseFirestore.instance
                          .collection("Users")
                          .doc(MyUserID)
                          .update({
                        'Type': type,
                        'DOB': u,
                        'url': url,
                      });
                      pr.hide().whenComplete(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NonBusinessUserDocList(),
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
    );
  }

  Widget RadioListTile(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Select Your Type:',
              style: TextStyle(fontSize: 17),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            title: const Text('Business'),
            leading: Radio(
              value: 1,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = 1;
                  type = "Business";
                });
                print(_value);
              },
              activeColor: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: const Text('Non Business'),
            leading: Radio(
              value: 2,
              groupValue: _value,
              onChanged: (value) {
                setState(() {
                  _value = 2;
                  type = "NonBusiness";
                });
                print(_value);
              },
              activeColor: Colors.deepPurple,
            ),
          ),
        ]);
  }
}
