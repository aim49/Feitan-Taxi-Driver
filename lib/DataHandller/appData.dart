import 'package:driver_appz/Models/history.dart';
import 'package:flutter/cupertino.dart';
import 'package:driver_appz/Models/address.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier
{
  String earnings = "0";
  int countTrips = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistoryDataList = [];
  void updateEarnings(String updatedEarnings)
  {
    earnings = updatedEarnings;
    notifyListeners();
  }

  void updateTripsCounter(int tripCounter)
  {
    countTrips = tripCounter;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys)
  {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistoryData(History eachHistory)
  {
   tripHistoryDataList.add(eachHistory);
    notifyListeners();
  }
}