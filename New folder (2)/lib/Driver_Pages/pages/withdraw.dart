// ignore_for_file: prefer_const_constructors, camel_case_types, prefer_const_constructors_in_immutables, non_constant_identifier_names, body_might_complete_normally_nullable, prefer_final_fields, unnecessary_const, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myproject/Driver_Pages/pages/earning.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';

class withdraw extends StatefulWidget {
  withdraw({Key? key}) : super(key: key);

  @override
  State<withdraw> createState() => _withdrawState();
}

String withdrawal_amount = "0";

class _withdrawState extends State<withdraw> {
  CollectionReference users = FirebaseFirestore.instance.collection('Driver');

  TextEditingController _WithdrawalAmountcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Withdraw",
        ),
        // ignore: unnecessary_const

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => earning()));
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: users.doc(id).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Material(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Balance : ",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${data['earning']}",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        onChanged: (value) {
                          withdrawal_amount = value;
                        },
                        controller: _WithdrawalAmountcontroller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red, //this has no effect
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: "Ammount",
                          hintText: "Enter widraw Ammounr",
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Withdrawal Amount Can't be Empty.";
                          }
                          Null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () async {
                        double temp1 = double.parse(withdrawal_amount);
                        double temp2 = double.parse(data['earning']);
                        if (temp1 > temp2) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: const Text("Please Enater Valid Amount"),
                              backgroundColor: Colors.black,
                            ),
                          );
                        } else {
                          await FirebaseFirestore.instance
                              .collection('Payment Request')
                              .add({
                            'Driver ID': id,
                            'Withdraw Ammount': withdrawal_amount,
                            'driver name':
                                "${data['First Name']} ${data['Last Name']}",
                            'Driver Image': data["Driver Image"],
                            'Status': "0",
                            //'Step': step,
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => earning()),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        width: 330,
                        height: 50,
                        alignment: Alignment.center,
                        child: const Text(
                          "Withdraw",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(25)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
