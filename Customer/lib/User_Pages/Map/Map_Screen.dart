import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:myproject/User_Pages/TripDetails/tripDetails.dart';
import 'package:myproject/Utils/routes.dart';

class Map_Screen extends StatefulWidget {
  @override
  _Map_ScreenState createState() => _Map_ScreenState();
}

//Textfields value
String source = "Enter starting point";
String Destination = "Enter Destinetion";

//Origin-Destination lat lang
late double OriginLat = 0, OriginLng = 0, DestLat = 0, DestLng = 0;
String Distance = "";

class _Map_ScreenState extends State<Map_Screen> {
  //API
  String googleApikey = "AIzaSyBLcpDnnknaH_SGCVxq_lCnmQ3HDhrezfI";

  //Contrller for Google map
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(22.5052586, 73.4653031),
    zoom: 17,
  );

  //Marker
  Set<Marker> _markers = {};

  //Polyline
  final Set<Polyline> _polyline = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  late Position currentPosition;
  var geoLocator = Geolocator();

  //Show our current location
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: 17);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  //Polylines
  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApikey,
      PointLatLng(OriginLat, OriginLng),
      PointLatLng(DestLat, DestLng),
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
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  //Distance between two selected places
  double distance = 0;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //Show bottom sheet
  VoidCallback? _showPersBottomSheetCallBack = null;

  @override
  void initState() {
    super.initState();
    _showPersBottomSheetCallBack = _showPersistentBottomSheet;
  }

  void _showPersistentBottomSheet() {
    setState(() {
      _showPersBottomSheetCallBack = null;
    });
    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return new Container(
            height: 230.0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 4,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 5,
                    width: 30,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Center(
                      child: Text(
                        source,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "to",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Center(
                      child: Text(
                        Destination,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    Distance + 'Km',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetails(
                              Source: source,
                              Destination: Destination,
                              Distance: Distance),
                        ),
                      );
                    },
                    child: Container(
                      width: 330,
                      height: 40,
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
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          );
        })
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              _showPersBottomSheetCallBack = _showPersistentBottomSheet;
            });
          }
        });
  }

  //Main screen code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        title: Column(
          children: [
            //Source textfield
            InkWell(
              onTap: () async {
                Destination = "Enter Destnation";
                _markers.clear();
                var place = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: googleApikey,
                  mode: Mode.overlay,
                  types: [],
                  strictbounds: false,
                  components: [Component(Component.country, 'in')],
                  //google_map_webservice package
                  onError: (err) {
                    print(err);
                  },
                );

                if (place != null) {
                  setState(() {
                    source = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;

                  OriginLat = lat;
                  OriginLng = lang;
                  DestLat = lat;
                  DestLng = lang;

                  print(OriginLat);
                  print(OriginLng);

                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 14)));

                  setState(
                    () {
                      _markers.add(
                        Marker(
                          markerId: MarkerId('1'),
                          position: LatLng(lat, lang),
                          icon: BitmapDescriptor.defaultMarkerWithHue(90),
                          infoWindow: InfoWindow(title: 'Starting Point'),
                        ),
                      );
                      getDirections();
                    },
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        source,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),

            //Destination textfield
            InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'in')],
                    //google_map_webservice package
                    onError: (err) {
                      print(err);
                    });

                if (place != null) {
                  setState(() {
                    Destination = place.description.toString();
                  });

                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(
                    apiKey: googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry!;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;

                  DestLat = lat;
                  DestLng = lang;

                  print(DestLat);
                  print(DestLng);

                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(target: newlatlang, zoom: 17)));

                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: MarkerId('2'),
                        position: LatLng(lat, lang),
                        infoWindow: InfoWindow(title: 'Destination Point'),
                      ),
                    );
                    getDirections();
                    setState(() {
                      mapController?.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(DestLat, DestLng), zoom: 14),
                        ),
                      );
                    });
                  });
                  distance =
                      calculateDistance(OriginLat, OriginLng, DestLat, DestLng);
                  print(distance);
                  Distance = distance.toStringAsFixed(2);
                  _showPersistentBottomSheet();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width - 40,
                    child: ListTile(
                      title: Text(
                        Destination,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Icon(Icons.search),
                      dense: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Stack(
        children: [
          //Google map
          GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal, //map type
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            markers: _markers,

            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                mapController = controller;
              });

              locatePosition();
            },
          ),
        ],
      ),
    );
  }
}
