import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:myproject/Admin_Pages/TripsOnTheWay/OnTripDetails.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

//String step = "0";
Timer? timer;
late double slongitude = 0,
    slatitude = 0,
    dlongitude = 0,
    dlatitude = 0,
    driverCurLat = 0,
    driverCurLong = 0;
int map = 0;

class Tracking extends StatefulWidget {
  Tracking({Key? key}) : super(key: key);

  @override
  State<Tracking> createState() => _TrackingState();
}

Position? currentPosition;
Position? s;

class _TrackingState extends State<Tracking> {
  PermissionStatus? _permissionStatus;
  String source = "";

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  var geolocator = Geolocator();
  Set<Marker> _markers = {};

  String googleApikey = "AIzaSyBLcpDnnknaH_SGCVxq_lCnmQ3HDhrezfI";

  final Set<Polyline> _polyline = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  getStartDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApikey,
      PointLatLng(driverCurLat, driverCurLong),
      PointLatLng(slatitude, slongitude),
      //travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);

    timer = Timer.periodic(
      Duration(seconds: 7),
      (Timer t) => getStartDirections(),
    );
  }

  getDestinationDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApikey,
      PointLatLng(slatitude, slongitude),
      PointLatLng(dlatitude, dlongitude),
      //travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);

    timer = Timer.periodic(
        Duration(seconds: 7), (Timer t) => getDestinationDirections());
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  //double bottompeddingofmap = 0.0;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState

    super.initState();

    startCordinate();
    getStartDirections();

    destinationCordinate();
    getDestinationDirections();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> startCordinate() async {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('1'),
          position: LatLng(slatitude, slongitude),
          infoWindow: InfoWindow(title: 'Starting Position')));
    });
  }

  Future<void> destinationCordinate() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('2'),
          position: LatLng(dlatitude, dlongitude),
          infoWindow: InfoWindow(
            title: 'Delivery Position',
          ),
        ),
      );
    });
  }

  void locatePosition() async {
    LatLng latlngPosition = LatLng(driverCurLat, driverCurLong);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('3'),
          position: LatLng(driverCurLat, driverCurLong),
          icon: BitmapDescriptor.defaultMarkerWithHue(90),
          infoWindow: InfoWindow(title: 'Driver Position'),
        ),
      );
    });

    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

    await getDriverLocdeails();

    timer =
        Timer.periodic(Duration(seconds: 10), (Timer t) => locatePosition());
  }

// ignore: prefer_const_constructors
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(21.5052586, 73.4653031),
    zoom: 17,
  );

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMap(
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                locatePosition();
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.add_rounded),
                          ),
                          onTap: () {
                            newGoogleMapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: Center(child: Icon(Icons.remove)),
                          ),
                          onTap: () {
                            newGoogleMapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          // ignore: prefer_const_constructors
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.my_location),
                          ),
                          onTap: () {
                            newGoogleMapController.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                  target: LatLng(
                                    // Will be fetching in the next step
                                    currentPosition!.latitude,
                                    currentPosition!.longitude,
                                  ),
                                  zoom: 18.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7.5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> getmapdeails() async {
  //CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('vehicle')
      .doc(vehicleId)
      .get();

  slatitude = documentSnapshot['sLatitude'];
  print("Starting Latitude ===== ${slatitude}");
  slongitude = documentSnapshot['sLongitude'];
  print("Starting Longitude ===== ${slongitude}");

  dlatitude = documentSnapshot['dLatitude'];
  print("Destination Latitude ===== ${dlatitude}");
  dlongitude = documentSnapshot['dLongitude'];
  print("Destination Longitude ===== ${dlongitude}");
}

Future<void> getDriverLocdeails() async {
  //CollectionReference users = FirebaseFirestore.instance.collection('Driver');
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('vehicle')
      .doc(vehicleId)
      .get();

  driverCurLat = documentSnapshot['Driver Latitude'];
  print("Driver Latitude ===== ${driverCurLat}");
  driverCurLong = documentSnapshot['Driver Longitude'];
  print("Driver Longitude ===== ${driverCurLong}");
}
