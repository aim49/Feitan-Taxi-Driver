import 'package:driver_appz/AllScreens/Main%20Screen.dart';
import 'package:driver_appz/AllScreens/registrationScreen.dart';
import 'package:driver_appz/configMaps.dart';
import 'package:driver_appz/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CarInfoScreen extends StatelessWidget
{
  static const String idScreen = "carInfo";
  TextEditingController carModalTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 22.0,),
                Image.asset("images/logo.png", width: 930.0, height: 250.0,),
                Padding(
                  padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                  child: Column(
                    children: [
                      SizedBox(height: 12.0,),
                      Text("Emter Car Details", style: TextStyle(fontFamily: "Brand Bold",fontSize: 24.0),),

                      SizedBox(height: 26.0,),
                      TextField(
                        controller: carModalTextEditingController,
                        decoration: InputDecoration(
                          labelText: "Car Model",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 15.0),
                      ),


                      SizedBox(height: 10.0,),
                      TextField(
                        controller: carNumberTextEditingController,
                        decoration: InputDecoration(
                          labelText: "Car Number",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 15.0),
                      ),


                      SizedBox(height: 10.0,),
                      TextField(
                        controller: carColorTextEditingController,
                        decoration: InputDecoration(
                          labelText: "Car Color",
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0),
                        ),
                        style: TextStyle(fontSize: 15.0),
                      ),


                      SizedBox(height: 10.0,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: RaisedButton(
                            onPressed: ()
                                {
                                  if(carModalTextEditingController.text.isEmpty)
                                    {
                                      displayToastMessage("Please write the Car Model", context);
                                    }
                                  else if(carNumberTextEditingController.text.isEmpty)
                                  {
                                    displayToastMessage("Please write the Car Number", context);
                                  }
                                  else if(carColorTextEditingController.text.isEmpty)
                                  {
                                    displayToastMessage("Please write the Car Color", context);
                                  }
                                  else
                                    {
                                      saveDriverCarInfo(context);
                                    }
                                },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Next", style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.white),),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 26.0,),

                              ],
                            ),
                          ),
                        ),
                      )


                    ],
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }


  void saveDriverCarInfo(context)
  {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap =
    {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModalTextEditingController.text,
    };
    
    driversRef.child(userId).child("car_details").set(carInfoMap);

    Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
  }
}
