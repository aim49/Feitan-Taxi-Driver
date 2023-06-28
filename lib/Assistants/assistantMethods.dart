import 'package:driver_appz/Models/history.dart';
import 'package:driver_appz/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:driver_appz/Assistants/requestAssistant.dart';
import 'package:driver_appz/DataHandller/appData.dart';
import 'package:driver_appz/Models/address.dart';
import 'package:driver_appz/Models/allUsers.dart';
import 'package:driver_appz/Models/directDetails.dart';
import 'package:driver_appz/configMaps.dart';

class AssistantMethods
{
  // static Future<String> searchCoordinateAddress(Position position, context) async
  // {
  //   String placeAddress ="";
  //   String st1, st2, st3, st4;
  //   String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
  //
  //   var response = await RequestAssistant.getRequest(url);
  //
  //   if(response != "failed")
  //     {
  //       placeAddress = response["results"][0]["formatted_address"];
  //       // st1 = response["results"][0]["address_components"][0]["long_name"];
  //       // st2 = response["results"][0]["address_components"][4]["long_name"];
  //       // st3 = response["results"][0]["address_components"][5]["long_name"];
  //       // st4 = response["results"][0]["address_components"][6]["long_name"];
  //       // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
  //
  //       Address userPickUpAddress = new Address();
  //       userPickUpAddress.longitude = position.longitude;
  //       userPickUpAddress.latitude = position.latitude;
  //       userPickUpAddress.placeName = placeAddress;
  //
  //
  //       Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
  //     }
  //
  //   return placeAddress;
  // }

  static Future<DirectionDetails> obtainPlaceDirectionsDetails(LatLng initialPosition, LatLng finalPosition) async
  {
    String directionsUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionsUrl);

    if(res == "failed")
      {
        return null;
      }

    DirectionDetails directionDetails = DirectionDetails();

   directionDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directionDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directionDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue = res["routes"][0]["legs"][0]["distance"]["value"];

    return directionDetails;
  }


  static int calculateFares(DirectionDetails directionDetails)
  {
    // this is in terms of usd
    double timeTraveledFare = (directionDetails.durationValue / 60) * 0.20;
    // its divided by 1000 for the kilometters travelled
    double distanceTraveledFare = (directionDetails.distanceValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

    //local currency 
    //1$ is equal to 100bond
    //double totalLocalAmount = totalFareAmount * 100;

    return totalFareAmount.truncate();

  }
  // static void getCurrentOnlineUserInfo() async
  // {
  //   //get their details through id
  //   firebaseUser = await FirebaseAuth.instance.currentUser;
  //   String userId = firebaseUser.uid;
  //   //get their information
  //   DatabaseReference reference =  FirebaseDatabase.instance.reference().child("users").child(userId);
  //
  //   reference.once().then((DataSnapshot dataSnapshot)
  //   {
  //     if(dataSnapshot.value != null)
  //       {
  //         userCurrentInfo = Users.fromSnapshot(dataSnapshot);
  //       }
  //   });
  // }

static void disableHomeTabLiveLocationUpdates()
{
  homeTabPageStreamSubscription.pause();
  Geofire.removeLocation(currentfirebaseUser.uid);
}


static void enableHomeTabLiveLocationUpdates()
{
  homeTabPageStreamSubscription.resume();
  Geofire.setLocation(currentfirebaseUser.uid, currentPosition.latitude, currentPosition.longitude);
}
  static void retrieveHistoryInfo(context)
  {


    //retrive and display earnings
    driversRef.child(currentfirebaseUser.uid).child("earnings").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null)
        {
          String earnings = dataSnapshot.value.toString();
          Provider.of<AppData>(context, listen: false).updateEarnings(earnings);

        }
    });

    //retrive and display trip history
    driversRef.child(currentfirebaseUser.uid).child("history").once().then((DataSnapshot dataSnapshot){
      if(dataSnapshot.value != null)
      {
        //update the total number of trip counts to provider
        Map<dynamic, dynamic> keys = dataSnapshot.value;
        int tripCounter = keys.length;
        Provider.of<AppData>(context, listen: false).updateTripsCounter(tripCounter);

        //update trip keys to provider
        List<String> tripHistoryKeys = [];
        keys.forEach((key, value) {
          tripHistoryKeys.add(key);
        });
        Provider.of<AppData>(context, listen: false).updateTripKeys(tripHistoryKeys);
        obtainTripRequestHistoryData(context);
      }
    });
  }

  static void obtainTripRequestHistoryData(context)
  {
    var keys = Provider.of<AppData>(context, listen: false).tripHistoryKeys;

    for(String key in keys)
      {
        newRequestRef.child(key).once().then((DataSnapshot snapshot) {
          if(snapshot.value != null)
            {
              var history = History.fromSnapShot(snapshot);
              Provider.of<AppData>(context, listen: false).updateTripHistoryData(history);
            }
        });
      }
  }

  static String formatTripDate(String date)
  {
    DateTime dateTime = DateTime.parse(date);
    String formmattedDate = "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";
    return formmattedDate;
  }
}