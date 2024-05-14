// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/geofencing_page.dart';
import 'package:geo_chronicle/pages/locations_page.dart';
import 'package:geo_chronicle/utils/bottom_nav_bar.dart';
import 'package:intl/intl.dart';

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
    HomePageContent(),

    const GeofencingPage(),
    const LocationsPage(),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 75),
          child: Text("GeoChronicle"),
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
            ],
          ),
        ),
      ),
    );
  }
}

// Replace this with your actual home page content widget
class HomePageContent extends StatelessWidget {
  HomePageContent({super.key});
  List<Color> tileColors = [
    Colors.blue[100]!,
    Colors.teal[100]!,
    Colors.green[100]!,
    Colors.amber[100]!,
    // ... more colors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Geofences>>(
      future: _fetchGeofences(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final geofence = snapshot.data![index];
              final tileColor =
                  tileColors[index % tileColors.length]; // Cycling colors
              return Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 15, bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: tileColor, // Apply color here
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        geofence.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        // For "First Entry" with icon
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 20), // Clock icon
                          const SizedBox(width: 8),
                          Text(
                              'Entry: ${geofence.entryTimestamp != null ? DateFormat('dd-MM-yyyy HH:mm:ss').format(geofence.entryTimestamp!) : 'Not Entered Yet'}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      if (geofence.exitTimestamp != null)
                        Row(
                          // For "Last Exit" with icon
                          children: [
                            const Icon(Icons.exit_to_app_rounded,
                                size: 20), // Exit icon
                            const SizedBox(width: 8),
                            Text(
                                'Exit: ${DateFormat('dd-MM-yyyy   HH:mm:ss').format(geofence.exitTimestamp!)}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      const SizedBox(height: 8),
                      Row(
                        // For "Total Time Today" with icon
                        children: [
                          const Icon(Icons.watch_later_rounded,
                              size: 18), // Time icon
                          const SizedBox(width: 8),
                          Text(
                            geofence.getFormattedDailyDuration(),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Geofences>> _fetchGeofences() async {
    return await GeofencesDatabase.readAllGeofences();
  }
}
