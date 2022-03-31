import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myproject/User_Pages/SelectVehicle/VehicleDetails.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/User_Pages/WaitingScreen/WaitingScreen.dart';

class Select_Vehicle extends StatefulWidget {
  String? Source;
  String? Destination;
  String? Distance;

  Select_Vehicle({Key? key, this.Source, this.Destination, this.Distance})
      : super(key: key);

  @override
  State<Select_Vehicle> createState() => _Select_VehicleState();
}

class _Select_VehicleState extends State<Select_Vehicle> {
  final db = FirebaseFirestore.instance;

  String Vehicleid = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Vehicle"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('vehicle')
            .where("Approved", isEqualTo: "Yes")
            .where("Vehicle Name", isEqualTo: vehicleType)
            .where("On Trip", isEqualTo: "No")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.size == 0) {
            return new Scaffold(
              body: Center(
                child: Text("No Vehicle"),
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView(
                children: snapshot.data!.docs
                    .map(
                      (doc) => Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 8),
                        child: Card(
                          borderOnForeground: true,
                          elevation: 4,
                          child: new ListTile(
                            title: new Text(doc["First Name"] ?? "",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                )),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                                  NetworkImage(doc["Vehicle Image"]),
                              backgroundColor: Colors.transparent,
                            ),
                            onTap: () {
                              Vehicleid = doc.id;
                              print(Vehicleid);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => VehicleDetails(
                                    Vehicleid: Vehicleid,
                                    Source: widget.Source,
                                    Destination: widget.Destination,
                                    Distance: widget.Distance,
                                  ),
                                ),
                              );
                            },
                            subtitle: RatingBarIndicator(
                              rating:
                                  double.parse(doc["Avg Rating"].toString()),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
