// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_chronicle/pages/geofencing_page.dart';
import 'package:geo_chronicle/pages/home_page_content.dart';
import 'package:geo_chronicle/pages/locations_page.dart';
import 'package:geo_chronicle/pages/report.dart';
import 'package:geo_chronicle/pages/schedule_page.dart';
import 'package:geo_chronicle/utils/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0; // Using a more descriptive name

  void navigateBottomBar(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  final List<Widget> _pages = [
    // Home page content (replace with your actual widget)
    const HomePageContent(),
    const SchedulePage(),
    const GeofencingPage(),
    const LocationsPage(),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 75),
          child: Text("TimelyTrail"),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onTabChange: (index) => navigateBottomBar(index),
      ),
      body: _pages[_currentPageIndex],

      //Drawer

      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 31, 30, 30),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              // logo

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SvgPicture.asset(
                  "assets/another_earth.svg",
                  color: const Color.fromARGB(255, 178, 179, 178),
                  height: 100,
                ),
              ),

              const Padding(
                padding: EdgeInsets.all(18.0),
                child: ListTile(
                  leading: Icon(
                    Icons.home,
                    size: 35,
                  ),
                  title: Text("Home"),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListTile(
                  leading: IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserReport())),
                    icon: const Icon(Icons.notes_outlined),
                  ),
                  title: const Text("Report"),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
