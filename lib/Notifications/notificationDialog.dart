import 'package:driver_appz/Assistants/assistantMethods.dart';
import 'package:driver_appz/Models/rideDetails.dart';
import 'package:driver_appz/configMaps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:driver_appz/main.dart';
import 'package:driver_appz/AllScreens/registrationScreen.dart';
import 'package:driver_appz/AllScreens/newRideScreen.dart';
import 'package:flutter/material.dart';


class NotificationDialog extends StatelessWidget
{

  final RideDetails rideDetails;

  NotificationDialog({this.rideDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      backgroundColor: Colors.transparent,
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.all(5.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30.0,),
            Image.asset("images/taxi.png", width: 120.0,),
            SizedBox(height: 18.0,),
            Text("New Rider Request", style: TextStyle(fontFamily: "Brand Bold", fontSize: 18.0,),),
            SizedBox(height: 30.0),
            Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/pickicon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                        child:  Container(child: Text(rideDetails.pickup_address, style: TextStyle(fontSize: 10.0),)),
                      ),

                    ],
                  ),
                  SizedBox(height: 15.0,),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),
                      SizedBox(width: 20.0,),
                      Expanded(
                          child: Container(child: Text(rideDetails.dropoff_address, style: TextStyle(fontSize: 10.0),))
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0,),


                ],
              ),
            ),

            SizedBox(height: 20.0),
            Divider(height: 2.0, color: Colors.black, thickness: 2.0,),
            SizedBox(height: 8.0),

            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                    color: Colors.white,
                    textColor: Colors.red,
                    padding: EdgeInsets.all(8.0),
                    onPressed: (){
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  
                  SizedBox(width:  25.0),


                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.green)),
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: (){
                      assetsAudioPlayer.stop();
                      checkAvailabilityOfRide(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),


                ],
              ),
            ),

            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  void checkAvailabilityOfRide(context)
  {
    rideRequestRef.once().then((DataSnapshot dataSnapshot)
    {
      Navigator.pop(context);
      String theRideID = "";
      if(dataSnapshot.value != null)
        {
          theRideID = dataSnapshot.value.toString();
        }
      else
        {
          displayToastMessage("Ride not exist", context);
        }
      if(theRideID == rideDetails.ride_request_id)
        {
          rideRequestRef.set("accepted");
          AssistantMethods.disableHomeTabLiveLocationUpdates();
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewRideScreen(rideDetails: rideDetails)));
        }
      else if(theRideID == "cancelled")
      {
        displayToastMessage("Ride has been cancelled", context);
      }
      else if(theRideID == "timeout")
      {
        displayToastMessage("Ride has been timed out", context);
      }
      else
      {
        displayToastMessage("Ride not exists", context);
      }
    });
  }
}
