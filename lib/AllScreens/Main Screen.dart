import 'package:driver_appz/tabsPages/ProfileTabePage.dart';
import 'package:driver_appz/tabsPages/earningTabPage.dart';
import 'package:driver_appz/tabsPages/homeTabPage.dart';
import 'package:driver_appz/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget
{
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin
{

  TabController tabController;
  int selectedIndex = 0;

  void onItemClicked(int index)
  {
    setState(() {
      selectedIndex = index;
      tabController.index = selectedIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          HomeTabPage(),
          EarningTabPage(),
          RatingTabPage(),
          ProfileTabPage(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: "Earnings",
          ),


          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Ratings",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),


        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.yellow,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,


      ),
    );
  }
}
