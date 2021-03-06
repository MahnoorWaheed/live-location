import 'dart:async';
import 'dart:math' show sin, cos, sqrt, atan2;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vector_math/vector_math.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
  
     
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 

 

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
late GoogleMapController newGoogleMapController;

GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
 
late Position currentPosition;
var geoLocator = Geolocator();
double bottomPaddingOfMap = 0;
// double earthRadius = 6371000; 
// // var currentLocation = myLocation;
// //Using pLat and pLng as dummy location
// double pLat = 22.8965265;   double pLng = 76.2545445; 




void locatePosition() async
{
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  currentPosition = position;

  LatLng latLatPosition = LatLng(position.latitude, position.longitude);
 

  print(latLatPosition);

  CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom: 14);
  newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

   GetAddressFromLatLng(position);
  // //  dynamic coordinates = new Coordinates(position.latitude, position.longitude);


  //  double distanceInMeters = Geolocator.distanceBetween(33.73, 73.09, 34.02, 71.58);

  //  print("helllloooooo worlddd : $distanceInMeters");
}

static final CameraPosition _kGooglePlex = CameraPosition(
  target:  LatLng(34.025917, 71.560135),
  zoom: 14.4746,
);


Future<void> GetAddressFromLatLng(Position position) async{

  List<Placemark> placemark = await placemarkFromCoordinates(position.latitude,position.longitude);
  print(placemark);

  List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

  Placemark place = placemark[2];

  // Address = '${place.Street}';

  print("helloooo worldd address : ${place.street}");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition : _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){
            _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 265.0;
              });
 locatePosition();

             },
           ),
        ],
      ),
    );
  }
}
