import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:myproject/User_Pages/ReceiverInfo/ReceiverInfo.dart';
import 'package:myproject/User_Pages/drawer/navigationdrawer.dart';
import 'package:myproject/Utils/routes.dart';

class TripDetails extends StatefulWidget {
  String? Source;
  String? Destination;
  String? Distance;
  TripDetails({Key? key, this.Source, this.Destination, this.Distance})
      : super(key: key);

  @override
  _TripDetailsState createState() => _TripDetailsState();
}

String goodsType = "";
String? date, time;
String? vehicleType;
String? price;

class _TripDetailsState extends State<TripDetails> {
  // create TimeOfDay variable
  TimeOfDay _timeOfDay = TimeOfDay(hour: 8, minute: 30);
  DateTime _date = DateTime.now();
  TextEditingController _datecontroller = TextEditingController();
  TextEditingController _timecontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  late DateTime dt;
  late TimeOfDay tt;
  // show time picker method
  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((val) {
      setState(() {
        print(val?.hour);
        tt = TimeOfDay.now();

        _timeOfDay = val!;
        _timecontroller.text = _timeOfDay.format(context).toString();
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        print(value);
        print(DateTime.now());

        print(value!.day.toString());
        dt = DateTime.now();
        _date = value;
        _datecontroller.text = _date.day.toString() +
            "-" +
            _date.month.toString() +
            "-" +
            _date.year.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trip Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItems: true,
                    items: [
                      "Cloths",
                      "Food",
                      "Cars",
                      "Flowers",
                      "Machine",
                      "Packages",
                      "Home Appliances",
                      "Electronics Items",
                      "Chemical Products",
                    ],
                    label: "Type of Goods",
                    hint: "Select Goods Type",
                    popupItemDisabled: (String s) => s.startsWith('I'),
                    validator: (value) =>
                        value == null ? "Goods type Can't be Empty." : null,
                    onChanged: (data) {
                      goodsType = data!;
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
                      "32 / 40 FEET OPEN TRAILER",
                    ],
                    label: "Type Of Vehicle",
                    hint: "Select Vehicle Type",
                    popupItemDisabled: (String s) => s.startsWith('I'),
                    validator: (value) =>
                        value == null ? "Vehicle type Can't be Empty." : null,
                    onChanged: (value) {
                      vehicleType = value!;
                      print(vehicleType);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: TextFormField(
                    readOnly: true,
                    onTap: _showDatePicker,
                    controller: _datecontroller,
                    decoration: InputDecoration(
                      labelText: "Date",
                      suffixIcon: InkWell(
                        child: Icon(Icons.date_range),
                        onTap: _showDatePicker,
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Date can't be empty.";
                      }

                      null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextFormField(
                    onTap: _showTimePicker,
                    readOnly: true,
                    controller: _timecontroller,
                    decoration: InputDecoration(
                      labelText: "Time",
                      suffixIcon: InkWell(
                        child: Icon(Icons.watch_later_rounded),
                        onTap: _showTimePicker,
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Time can't be empty.";
                      }
                      null;
                    },
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                InkWell(
                  onTap: () async {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        time = _timecontroller.text;
                        date = _datecontroller.text;
                      });
                      if (_date.day >= dt.day &&
                          _date.month >= dt.month &&
                          _date.year >= dt.year) {
                        if (_timeOfDay.hour >= tt.hour &&
                            _timeOfDay.minute >= tt.minute) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReceiverInfo(
                                  Source: widget.Source,
                                  Destination: widget.Destination,
                                  Distance: widget.Distance),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Enter Current Time OR After"),
                              backgroundColor: Colors.black,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Enter Date Of Today OR After"),
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
                      "Next",
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
      ),
    );
  }
}
