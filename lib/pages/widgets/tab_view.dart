import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabView extends StatefulWidget {
  TabView({Key? key}) : super(key: key);

  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: ButtonsTabBar(
        height: 75,
        buttonMargin: EdgeInsets.all(10),
        backgroundColor: Color.fromARGB(255, 18, 90, 116),
        unselectedBackgroundColor: Color.fromARGB(255, 9, 72, 94),
        unselectedLabelStyle:
            GoogleFonts.poppins(color: Color.fromARGB(197, 245, 241, 241)),
        labelStyle: GoogleFonts.poppins(
            color: Colors.white, fontWeight: FontWeight.bold),
        contentPadding: EdgeInsets.all(18),
        tabs: [
          Tab(
            // icon: Icon(Icons.directions_car),
            text: "Your playlist",
          ),
          Tab(
            // icon: Icon(Icons.directions_car),
            text: "Most played",
          ),
          Tab(
            // icon: Icon(Icons.directions_transit),
            text: "Album",
          ),
          Tab(
            text: 'Artists',
          )
          // Tab(icon: Icon(Icons.directions_bike)),
          // Tab(icon: Icon(Icons.directions_car)),
          // Tab(icon: Icon(Icons.directions_transit)),
          // Tab(icon: Icon(Icons.directions_bike)),
        ],
      ),
    );
  }
}
