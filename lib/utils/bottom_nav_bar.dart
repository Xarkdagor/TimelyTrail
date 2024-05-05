// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;

  BottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GNav(
          onTabChange: (value) => onTabChange!(value),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          activeColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          tabBorderRadius: 18,
          tabBackgroundColor: const Color.fromARGB(255, 31, 30, 30),
          tabActiveBorder:
              Border.all(color: const Color.fromARGB(255, 5, 5, 5)),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.map,
              text: "Geofencing",
            ),
            GButton(
              icon: Icons.location_searching,
              text: "Locations",
            )
          ]),
    );
  }
}
