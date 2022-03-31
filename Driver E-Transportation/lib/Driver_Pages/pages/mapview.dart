// ignore_for_file: unused_local_variable, unnecessary_new, prefer_final_fields, unused_field, sized_box_for_whitespace, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_constructors, duplicate_ignore, unused_import, unrelated_type_equality_checks, avoid_print, avoid_function_literals_in_foreach_calls, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:myproject/Driver_Pages/pages/accept_request.dart';
import 'package:myproject/Driver_Pages/pages/complete_order.dart';
import 'package:myproject/Driver_Pages/pages/driver_info.dart';
import 'package:myproject/Driver_Pages/pages/request_details.dart';
import 'package:myproject/Driver_Pages/pages/request_list.dart';
import 'package:myproject/Driver_Pages/pages/vahicle_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

//String step = "0";
Timer? timer;
late double slongitude = 0, slatitude = 0, dlongitude = 0, dlatitude = 0;
int map = 0;
String? dfname;
String? dfimage;

class mapview extends StatefulWidget {
  mapview({Key? key}) : super(key: key);

  @override
  State<mapview> createState() => _mapviewState();
}

Position? currentPosition;
Position? s;
String reqno = "";

class _mapviewState extends State<mapview> {
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
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
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

    timer =
        Timer.periodic(Duration(seconds: 7), (Timer t) => getStartDirections());
  }

  getDestinationDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApikey,
      PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
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
    _checkPermission(context);
    if (map == 1) {
      startCordinate();
      getStartDirections();
    } else if (map == 2) {
      destinationCordinate();
      getDestinationDirections();
    } else {
      map = 0;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _checkPermission(BuildContext context) async {
    var permission = await Permission.location.status;
    print(permission);

    if (!permission.isGranted) {
      await Permission.location.request();
    }

    if (await Permission.location.isGranted) {
      locatePosition();
    }
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
      _markers.add(Marker(
          markerId: MarkerId('2'),
          position: LatLng(dlatitude, dlongitude),
          infoWindow: InfoWindow(title: 'Delivery Position')));
    });
  }

  void locatePosition() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(currentPosition);

    LatLng latlngPosition =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );

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
    FirebaseFirestore.instance
        .collection("Driver")
        .doc(id)
        .collection("Request")
        .where("On Trip", isEqualTo: "No")
        .where("Order Completed", isEqualTo: "No")
        .get()
        .then((value) {
      setState(() {
        reqno = value.size.toString();
      });
    });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: 20,
                    // ),
                    InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => request_list()),
                        );
                      },
                      child: AnimatedContainer(
                        duration: Duration(seconds: 2),
                        width: 300,
                        height: 50,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Text(
                              "Trip Requests",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: Text(reqno),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
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
      .collection('Driver')
      .doc(id)
      .collection("Request")
      .doc(reqid)
      .get();

  slatitude = documentSnapshot['Source lat'];
  print("Starting Latitude ===== ${slatitude}");
  slongitude = documentSnapshot['Source lang'];
  print("Starting Longitude ===== ${slongitude}");

  dlatitude = documentSnapshot['Destination lat'];
  print("Destination Latitude ===== ${dlatitude}");
  dlongitude = documentSnapshot['Destination lang'];
  print("Destination Longitude ===== ${dlongitude}");
}

Future<void> getFeedBackDeails() async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Driver').doc(id).get();

  dfname = "${documentSnapshot['First Name']} ${documentSnapshot['Last Name']}";
  print("full name ===== ${dfname}");
  dfimage = documentSnapshot["Driver Image"];
  print("Driver image ===== ${dfimage}");
}








// // // ignore_for_file: non_constant_identifier_names, prefer_const_constructors, unused_field, prefer_final_fields, unnecessary_new, prefer_const_literals_to_create_immutables, avoid_print, camel_case_types, avoid_function_literals_in_foreach_calls, avoid_init_to_null, use_key_in_widget_constructors

// // import 'dart:async';
// // import 'dart:math';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// // import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:google_api_headers/google_api_headers.dart';
// // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // import 'package:google_maps_webservice/places.dart';

// // class mapview extends StatefulWidget {
// //   @override
// //   _mapviewState createState() => _mapviewState();
// // }

// // //Textfields value
// // String source = "Enter starting point";
// // String Destination = "Enter Destinetion";
// // String Distance = "";

// // class _mapviewState extends State<mapview> {
// //   //API
// //   String googleApikey = "AIzaSyBLcpDnnknaH_SGCVxq_lCnmQ3HDhrezfI";

// //   //Contrller for Google map
// //   GoogleMapController? mapController;
// //   CameraPosition? cameraPosition;
// //   LatLng startLocation = LatLng(27.6602292, 85.308027);
// //   static final CameraPosition _kGooglePlex = CameraPosition(
// //     target: LatLng(22.5052586, 73.4653031),
// //     zoom: 17,
// //   );

// //   //Marker
// //   Set<Marker> _markers = {};

// //   //Polyline
// //   final Set<Polyline> _polyline = {};
// //   PolylinePoints polylinePoints = PolylinePoints();
// //   Map<PolylineId, Polyline> polylines = {};

// //   final _scaffoldKey = new GlobalKey<ScaffoldState>();

// //   //Origin-Destination lat lang
// //   late double OriginLat = 0, OriginLng = 0, DestLat = 0, DestLng = 0;

// //   Completer<GoogleMapController> _controllerGoogleMap = Completer();
// //   late GoogleMapController newGoogleMapController;
// //   GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

// //   late Position currentPosition;
// //   var geoLocator = Geolocator();

// //   //Show our current location
// //   void locatePosition() async {
// //     Position position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.high);
// //     currentPosition = position;

// //     LatLng latlngPosition = LatLng(position.latitude, position.longitude);

// //     CameraPosition cameraPosition =
// //         new CameraPosition(target: latlngPosition, zoom: 17);

// //     newGoogleMapController
// //         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
// //   }

// //   //Polylines
// //   getDirections() async {
// //     List<LatLng> polylineCoordinates = [];

// //     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
// //       googleApikey,
// //       PointLatLng(OriginLat, OriginLng),
// //       PointLatLng(DestLat, DestLng),
// //       //travelMode: TravelMode.driving,
// //     );

// //     if (result.points.isNotEmpty) {
// //       result.points.forEach((PointLatLng point) {
// //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
// //       });
// //     } else {
// //       print(result.errorMessage);
// //     }
// //     addPolyLine(polylineCoordinates);
// //   }

// //   addPolyLine(List<LatLng> polylineCoordinates) {
// //     PolylineId id = PolylineId("poly");
// //     Polyline polyline = Polyline(
// //       polylineId: id,
// //       color: Colors.deepPurpleAccent,
// //       points: polylineCoordinates,
// //       width: 8,
// //     );
// //     polylines[id] = polyline;
// //     setState(() {});
// //   }

// //   //Distance between two selected places
// //   double distance = 0;
// //   double calculateDistance(lat1, lon1, lat2, lon2) {
// //     var p = 0.017453292519943295;
// //     var a = 0.5 -
// //         cos((lat2 - lat1) * p) / 2 +
// //         cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
// //     return 12742 * asin(sqrt(a));
// //   }

// //   //Show bottom sheet
// //   VoidCallback? _showPersBottomSheetCallBack = null;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _showPersBottomSheetCallBack = _showPersistentBottomSheet;
// //   }

// //   void _showPersistentBottomSheet() {
// //     setState(() {
// //       _showPersBottomSheetCallBack = null;
// //     });
// //     _scaffoldKey.currentState!
// //         .showBottomSheet((context) {
// //           return new Container(
// //             height: 230.0,
// //             decoration: BoxDecoration(
// //               color: Colors.green,
// //               borderRadius: BorderRadius.only(
// //                 topLeft: Radius.circular(30),
// //                 topRight: Radius.circular(30),
// //               ),
// //               boxShadow: [
// //                 BoxShadow(
// //                   color: Colors.black,
// //                   spreadRadius: 4,
// //                   blurRadius: 10,
// //                 ),
// //               ],
// //             ),
// //             child: Center(
// //               child: Column(
// //                 children: [
// //                   SizedBox(
// //                     height: 10,
// //                   ),
// //                   Container(
// //                     height: 5,
// //                     width: 30,
// //                     color: Colors.black,
// //                   ),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                   Text(
// //                     source,
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   Text(
// //                     "to",
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   Text(
// //                     Destination,
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     height: 20,
// //                   ),
// //                   Text(
// //                     Distance,
// //                     style: TextStyle(
// //                       color: Colors.white,
// //                       fontSize: 20,
// //                     ),
// //                   ),
// //                   SizedBox(
// //                     height: 25,
// //                   ),
// //                   InkWell(
// //                     onTap: () async {

// //                     },
// //                     child: Container(
// //                       width: 330,
// //                       height: 40,
// //                       alignment: Alignment.center,
// //                       child: Text(
// //                         "Next",
// //                         style: TextStyle(
// //                           fontSize: 18,
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       decoration: BoxDecoration(
// //                           color: Colors.deepPurple,
// //                           borderRadius: BorderRadius.circular(10)),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           );
// //         })
// //         .closed
// //         .whenComplete(() {
// //           if (mounted) {
// //             setState(() {
// //               _showPersBottomSheetCallBack = _showPersistentBottomSheet;
// //             });
// //           }
// //         });
// //   }

// //   //Main screen code
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         toolbarHeight: 140,
// //         title: Column(
// //           children: [
// //             //Source textfield
// //             InkWell(
// //               onTap: () async {
// //                 Destination = "Enter Destnation";
// //                 _markers.clear();
// //                 var place = await PlacesAutocomplete.show(
// //                   context: context,
// //                   apiKey: googleApikey,
// //                   mode: Mode.overlay,
// //                   types: [],
// //                   strictbounds: false,
// //                   components: [Component(Component.country, 'in')],
// //                   //google_map_webservice package
// //                   onError: (err) {
// //                     print(err);
// //                   },
// //                 );

// //                 if (place != null) {
// //                   setState(() {
// //                     source = place.description.toString();
// //                   });

// //                   //form google_maps_webservice package
// //                   final plist = GoogleMapsPlaces(
// //                     apiKey: googleApikey,
// //                     apiHeaders: await GoogleApiHeaders().getHeaders(),
// //                     //from google_api_headers package
// //                   );
// //                   String placeid = place.placeId ?? "0";
// //                   final detail = await plist.getDetailsByPlaceId(placeid);
// //                   final geometry = detail.result.geometry!;
// //                   final lat = geometry.location.lat;
// //                   final lang = geometry.location.lng;

// //                   OriginLat = lat;
// //                   OriginLng = lang;
// //                   DestLat = lat;
// //                   DestLng = lang;

// //                   print(OriginLat);
// //                   print(OriginLng);

// //                   var newlatlang = LatLng(lat, lang);

// //                   //move map camera to selected place with animation
// //                   mapController?.animateCamera(CameraUpdate.newCameraPosition(
// //                       CameraPosition(target: newlatlang, zoom: 14)));

// //                   setState(
// //                     () {
// //                       _markers.add(
// //                         Marker(
// //                           markerId: MarkerId('1'),
// //                           position: LatLng(lat, lang),
// //                           icon: BitmapDescriptor.defaultMarkerWithHue(90),
// //                         ),
// //                       );
// //                       getDirections();
// //                     },
// //                   );
// //                 }
// //               },
// //               child: Padding(
// //                 padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
// //                 child: Card(
// //                   child: Container(
// //                     padding: EdgeInsets.all(0),
// //                     width: MediaQuery.of(context).size.width - 40,
// //                     child: ListTile(
// //                       title: Text(
// //                         source,
// //                         style: TextStyle(fontSize: 18),
// //                       ),
// //                       trailing: Icon(Icons.search),
// //                       dense: true,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),

// //             //Destination textfield
// //             InkWell(
// //               onTap: () async {
// //                 var place = await PlacesAutocomplete.show(
// //                     context: context,
// //                     apiKey: googleApikey,
// //                     mode: Mode.overlay,
// //                     types: [],
// //                     strictbounds: false,
// //                     components: [Component(Component.country, 'in')],
// //                     //google_map_webservice package
// //                     onError: (err) {
// //                       print(err);
// //                     });

// //                 if (place != null) {
// //                   setState(() {
// //                     Destination = place.description.toString();
// //                   });

// //                   //form google_maps_webservice package
// //                   final plist = GoogleMapsPlaces(
// //                     apiKey: googleApikey,
// //                     apiHeaders: await GoogleApiHeaders().getHeaders(),
// //                     //from google_api_headers package
// //                   );
// //                   String placeid = place.placeId ?? "0";
// //                   final detail = await plist.getDetailsByPlaceId(placeid);
// //                   final geometry = detail.result.geometry!;
// //                   final lat = geometry.location.lat;
// //                   final lang = geometry.location.lng;

// //                   DestLat = lat;
// //                   DestLng = lang;

// //                   print(DestLat);
// //                   print(DestLng);

// //                   var newlatlang = LatLng(lat, lang);

// //                   //move map camera to selected place with animation
// //                   mapController?.animateCamera(CameraUpdate.newCameraPosition(
// //                       CameraPosition(target: newlatlang, zoom: 17)));

// //                   setState(() {
// //                     _markers.add(
// //                       Marker(
// //                         markerId: MarkerId('2'),
// //                         position: LatLng(lat, lang),
// //                       ),
// //                     );
// //                     getDirections();
// //                     setState(() {
// //                       mapController?.animateCamera(
// //                         CameraUpdate.newCameraPosition(
// //                           CameraPosition(
// //                               target: LatLng(DestLat, DestLng), zoom: 14),
// //                         ),
// //                       );
// //                     });
// //                   });
// //                   distance =
// //                       calculateDistance(OriginLat, OriginLng, DestLat, DestLng);
// //                   print(distance);
// //                   Distance = distance.toStringAsFixed(2);
// //                   _showPersistentBottomSheet();
// //                 }
// //               },
// //               child: Padding(
// //                 padding: EdgeInsets.only(left: 15, right: 15),
// //                 child: Card(
// //                   child: Container(
// //                     padding: EdgeInsets.all(0),
// //                     width: MediaQuery.of(context).size.width - 40,
// //                     child: ListTile(
// //                       title: Text(
// //                         Destination,
// //                         style: TextStyle(fontSize: 18),
// //                       ),
// //                       trailing: Icon(Icons.search),
// //                       dense: true,
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //         backgroundColor: Colors.deepPurpleAccent,
// //       ),
// //       body: Stack(
// //         children: [
// //           //Google map
// //           GoogleMap(
// //             //Map widget from google_maps_flutter package
// //             zoomGesturesEnabled: true, //enable Zoom in, out on map
// //             initialCameraPosition: _kGooglePlex,
// //             mapType: MapType.normal, //map type
// //             myLocationButtonEnabled: true,
// //             myLocationEnabled: true,
// //             compassEnabled: true,
// //             markers: _markers,

// //             polylines: Set<Polyline>.of(polylines.values),
// //             onMapCreated: (GoogleMapController controller) async {
// //               _controllerGoogleMap.complete(controller);
// //               newGoogleMapController = controller;
// //               setState(() {
// //                 mapController = controller;
// //               });

// //               locatePosition();
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // // // ignore_for_file: use_key_in_widget_constructors, camel_case_types

// // // import 'package:flutter/material.dart';

// // // import 'package:google_maps_flutter/google_maps_flutter.dart';
// // // import 'package:myproject/Driver_Pages/pages/directions_model.dart';
// // // import 'package:myproject/Driver_Pages/pages/directions_repository.dart';

// // // class mapview extends StatefulWidget {
// // //   @override
// // //   _mapviewState createState() => _mapviewState();
// // // }

// // // class _mapviewState extends State<mapview> {
// // //   static const _initialCameraPosition = CameraPosition(
// // //     target: LatLng(37.773972, -122.431297),
// // //     zoom: 11.5,
// // //   );

// // //   GoogleMapController? _googleMapController;
// // //   Marker? _origin;
// // //   Marker? _destination;
// // //   Directions? _info;

// // //   @override
// // //   void dispose() {
// // //     _googleMapController?.dispose();
// // //     super.dispose();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         centerTitle: false,
// // //         title: const Text('Google Maps'),
// // //         actions: [
// // //           if (_origin != null)
// // //             TextButton(
// // //               onPressed: () => _googleMapController?.animateCamera(
// // //                 CameraUpdate.newCameraPosition(
// // //                   CameraPosition(
// // //                     target: _origin!.position,
// // //                     zoom: 14.5,
// // //                     tilt: 50.0,
// // //                   ),
// // //                 ),
// // //               ),
// // //               style: TextButton.styleFrom(
// // //                 primary: Colors.green,
// // //                 textStyle: const TextStyle(fontWeight: FontWeight.w600),
// // //               ),
// // //               child: const Text('ORIGIN'),
// // //             ),
// // //           if (_destination != null)
// // //             TextButton(
// // //               onPressed: () => _googleMapController?.animateCamera(
// // //                 CameraUpdate.newCameraPosition(
// // //                   CameraPosition(
// // //                     target: _destination!.position,
// // //                     zoom: 14.5,
// // //                     tilt: 50.0,
// // //                   ),
// // //                 ),
// // //               ),
// // //               style: TextButton.styleFrom(
// // //                 primary: Colors.blue,
// // //                 textStyle: const TextStyle(fontWeight: FontWeight.w600),
// // //               ),
// // //               child: const Text('DEST'),
// // //             )
// // //         ],
// // //       ),
// // //       body: Stack(
// // //         alignment: Alignment.center,
// // //         children: [
// // //           GoogleMap(
// // //             myLocationButtonEnabled: false,
// // //             zoomControlsEnabled: false,
// // //             initialCameraPosition: _initialCameraPosition,
// // //             onMapCreated: (controller) => _googleMapController = controller,
// // //             markers: {
// // //               if (_origin != null) _origin,
// // //               if (_destination != null) _destination
// // //             },
// // //             polylines: {
// // //               if (_info != null)
// // //                 Polyline(
// // //                   polylineId: const PolylineId('overview_polyline'),
// // //                   color: Colors.red,
// // //                   width: 5,
// // //                   points: _info!.polylinePoints
// // //                       .map((e) => LatLng(e.latitude, e.longitude))
// // //                       .toList(),
// // //                 ),
// // //             },
// // //             onLongPress: _addMarker,
// // //           ),
// // //           if (_info != null)
// // //             Positioned(
// // //               top: 20.0,
// // //               child: Container(
// // //                 padding: const EdgeInsets.symmetric(
// // //                   vertical: 6.0,
// // //                   horizontal: 12.0,
// // //                 ),
// // //                 decoration: BoxDecoration(
// // //                   color: Colors.yellowAccent,
// // //                   borderRadius: BorderRadius.circular(20.0),
// // //                   boxShadow: const [
// // //                     BoxShadow(
// // //                       color: Colors.black26,
// // //                       offset: Offset(0, 2),
// // //                       blurRadius: 6.0,
// // //                     )
// // //                   ],
// // //                 ),
// // //                 child: Text(
// // //                   '${_info!.totalDistance}, ${_info!.totalDuration}',
// // //                   style: const TextStyle(
// // //                     fontSize: 18.0,
// // //                     fontWeight: FontWeight.w600,
// // //                   ),
// // //                 ),
// // //               ),
// // //             ),
// // //         ],
// // //       ),
// // //       floatingActionButton: FloatingActionButton(
// // //         backgroundColor: Theme.of(context).primaryColor,
// // //         foregroundColor: Colors.black,
// // //         onPressed: () => _googleMapController!.animateCamera(
// // //           _info != null
// // //               ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
// // //               : CameraUpdate.newCameraPosition(_initialCameraPosition),
// // //         ),
// // //         child: const Icon(Icons.center_focus_strong),
// // //       ),
// // //     );
// // //   }

// // //   void _addMarker(LatLng pos) async {
// // //     if (_origin == null || (_origin != null && _destination != null)) {
// // //       // Origin is not set OR Origin/Destination are both set
// // //       // Set origin
// // //       setState(() {
// // //         _origin = Marker(
// // //           markerId: const MarkerId('origin'),
// // //           infoWindow: const InfoWindow(title: 'Origin'),
// // //           icon:
// // //               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
// // //           position: pos,
// // //         );
// // //         // Reset destination
// // //         _destination = null;

// // //         // Reset info
// // //         _info = null;
// // //       });
// // //     } else {
// // //       // Origin is already set
// // //       // Set destination
// // //       setState(() {
// // //         _destination = Marker(
// // //           markerId: const MarkerId('destination'),
// // //           infoWindow: const InfoWindow(title: 'Destination'),
// // //           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
// // //           position: pos,
// // //         );
// // //       });

// // //       // Get directions
// // //       final directions = await DirectionsRepository()
// // //           .getDirections(origin: _origin!.position, destination: pos);
// // //       setState(() => _info = directions);
// // //     }
// // //   }
// // // }

// // ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, duplicate_ignore, camel_case_types, prefer_const_constructors_in_immutables, avoid_print, unused_field, unused_local_variable, prefer_final_fields

// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class mapview extends StatefulWidget {
//   mapview({Key? key}) : super(key: key);

//   @override
//   State<mapview> createState() => _mapviewState();
// }

// class _mapviewState extends State<mapview> {
//   Set<Marker> markers = {};
//   GoogleMapController? mapController;
//   Position? _currentPosition;
//   String _currentAddress = "";
//   String _startAddress = "";
//   CameraPosition _initialLocation =
//       CameraPosition(target: LatLng(37.773972, -122.431297), zoom: 11.5);

//   Marker startMarker = Marker(
//     markerId: MarkerId('Start'),
//     position: LatLng(22.457812, 27.125489),
//     infoWindow: InfoWindow(
//       title: 'Start',
//     ),
//     icon: BitmapDescriptor.defaultMarker,
//   );

//   Marker destinationMarker = Marker(
//     markerId: MarkerId('Destination'),
//     position: LatLng(23.125478, 27.145896),
//     infoWindow: InfoWindow(
//       title: 'Destination',
//     ),
//     icon: BitmapDescriptor.defaultMarker,
//   );

//   final startAddressController = TextEditingController();

//   _getCurrentLocation() async {
//     await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
//         .then((Position position) async {
//       setState(() {
//         // Store the position in the variable
//         _currentPosition = position;

//         print('CURRENT POS: $_currentPosition');

//         // For moving the camera to current location
//         mapController?.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(position.latitude, position.longitude),
//               zoom: 18.0,
//             ),
//           ),
//         );
//       });
//       //await _getAddress();
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();

//     markers.add(startMarker);
//     markers.add(destinationMarker);
//   }

//   @override
//   void dispose() {
//     mapController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return Container(
//       height: height,
//       width: width,
//       child: Scaffold(
//         body: Stack(
//           children: <Widget>[
//             GoogleMap(
//               markers: Set<Marker>.from(markers),
//               initialCameraPosition: _initialLocation,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: false,
//               mapType: MapType.normal,
//               zoomGesturesEnabled: true,
//               zoomControlsEnabled: false,
//               onMapCreated: (GoogleMapController controller) {
//                 mapController = controller;
//               },
//             ),
//             Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ClipOval(
//                       child: Material(
//                         color: Colors.blue.shade100, // button color
//                         child: InkWell(
//                           splashColor: Colors.blue, // inkwell color
//                           child: SizedBox(
//                             width: 30,
//                             height: 30,
//                             child: Icon(Icons.add_rounded),
//                           ),
//                           onTap: () {
//                             mapController?.animateCamera(
//                               CameraUpdate.zoomIn(),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ClipOval(
//                       child: Material(
//                         color: Colors.blue.shade100, // button color
//                         child: InkWell(
//                           splashColor: Colors.blue, // inkwell color
//                           child: SizedBox(
//                             width: 30,
//                             height: 30,
//                             child: Center(child: Icon(Icons.remove)),
//                           ),
//                           onTap: () {
//                             mapController?.animateCamera(
//                               CameraUpdate.zoomOut(),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     ClipOval(
//                       child: Material(
//                         color: Colors.blue.shade100, // button color
//                         child: InkWell(
//                           splashColor: Colors.blue, // inkwell color
//                           // ignore: prefer_const_constructors
//                           child: SizedBox(
//                             width: 56,
//                             height: 56,
//                             child: Icon(Icons.my_location),
//                           ),
//                           onTap: () {
//                             mapController?.animateCamera(
//                               CameraUpdate.newCameraPosition(
//                                 CameraPosition(
//                                   target: LatLng(
//                                     // Will be fetching in the next step
//                                     _currentPosition!.latitude,
//                                     _currentPosition!.longitude,
//                                   ),
//                                   zoom: 18.0,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 7.5,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }