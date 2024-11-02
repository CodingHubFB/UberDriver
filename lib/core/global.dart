import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber_driver/core/Models/User_Model.dart';

User? currentFirebaseUser;

UserModel? userModelCurrentInfo;

StreamSubscription<Position>? streamSubscriptionPosition;