import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:driver_appz/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:driver_appz/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';

String mapKey = "AIzaSyCOrdEWX9T2ggF4n_u0z02pE6zyT2GlJZs";


User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";

double starCounter = 0.0;

String rideType = "";
