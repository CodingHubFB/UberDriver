import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uber_driver/Screens/Splash_Screen.dart';
import 'package:uber_driver/core/Models/User_Model.dart';
import 'package:uber_driver/core/global.dart';
import 'package:uber_driver/core/map_key.dart';
import 'package:uicons/uicons.dart';
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer<GoogleMapController>();
      
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  CameraPosition? cameraPosition;

  LocationPermission? _locationPermission;

  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }
 
  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  String humanReadableAddress = '';
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  String userName = '';
  String emailAddress = '';
  bool openNavigationDrawer = true;
  

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;
    LatLng latlngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    cameraPosition = CameraPosition(target: latlngPosition, zoom: 14);
    newGoogleMapController?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition!));
    var req = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${driverCurrentPosition!.latitude},${driverCurrentPosition!.longitude}&key=$mapKey1'));
    var res = jsonDecode(req.body);
    humanReadableAddress = res["results"][0]['formatted_address'];
    setState(() {});
    setState(() {
      userName = userModelCurrentInfo!.name!;
      emailAddress = userModelCurrentInfo!.email!;
    });
  }

  void readCurrentOnlineUserInfo() async {
    currentFirebaseUser = FirebaseAuth.instance.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(FirebaseAuth.instance.currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      } 
    });
  }

  driverIsOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = pos;
    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      currentFirebaseUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude
    );
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    ref.set("idle");
    ref.onValue.listen((e) {});
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentFirebaseUser!.uid).child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    Future.delayed(Duration(milliseconds: 2000), () {
      // SystemChannels.platform.invokeMethod("SystemNavigator.pop");
      // SystemNavigator.pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
    });
  }

  updateDriversLocationAtRealTime() {
      streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position) {
        driverCurrentPosition = position;
        if (isDriverActive == true) {
          Geofire.setLocation(
            currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude
          );
        }

        LatLng latlng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

        newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latlng));
      });
    }
  
  @override
  void initState() {
    readCurrentOnlineUserInfo();
    checkIfLocationPermissionAllowed();
    super.initState();
  }

  GoogleMapController? newGoogleMapController;

  blackThemeGoogleMaps() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              blackThemeGoogleMaps();
              locateUserPosition();
            },
          ),

          statusText != "Now Online" ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.maxFinite,
            color: Colors.black87,
          ) : Container(),
          Positioned(
            top: statusText != "Now Online" ? MediaQuery.of(context).size.height * 0.46 : 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isDriverActive != true) {
                      driverIsOnlineNow();
                      updateDriversLocationAtRealTime();
                      setState(() {
                        statusText = "Now Online";
                        isDriverActive = true;
                        buttonColor = Colors.transparent;
                      });
                      FlutterToastr.show("You Are Online Now.", context);
                    } else {
                      driverIsOfflineNow();
                      setState(() {
                        statusText = "Now Offline";
                        isDriverActive = false;
                        buttonColor = Colors.grey;
                      });
                      FlutterToastr.show("You Are Offline Now.", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: statusText != "Now Online" ? Text(statusText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),) : Icon(UIcons.regularRounded.phone_call, color: Colors.white,))
              ],
            ),
          ),
        ]
      )
    );
  }
}