import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/locations_page.dart';
import 'package:geo_chronicle/services/maps.dart';
import 'package:geo_chronicle/utils/geofence_input_dialog.dart';
import 'package:isar/isar.dart';

class GeofencingPage extends StatefulWidget {
  const GeofencingPage({super.key});

  @override
  State<GeofencingPage> createState() => _GeofencingPageState();
}

class _GeofencingPageState extends State<GeofencingPage> {
  String _currentCoordinates = "Coordinates will appear here";

  void updateCoordinates(String coords) {
    // Split the coordinates into latitude and longitude
    List<String> parts = coords.split(", ");
    String latitude = parts[0].substring(4); // Remove the "Lat: " prefix
    String longitude = parts[1].substring(5); //  Remove the "Long: " prefix

    setState(() {
      _currentCoordinates = "Latitude: $latitude\nLongitude: $longitude";
    });
  }

  // Function to create geofences
  void createGeofences(BuildContext context) async {
    print('Entering createGeofences()');
    final result = await showDialog<Geofences>(
      // Updated return type
      context: context,
      builder: (context) => const GeoFenceInputDialog(),
    );

    // Check if a geo-fence was created
    if (result != null) {
      // 1. Save the geo-fence to the database
      try {
        print('Attempting to save geo-fence');
        final geofencesDatabase =
            GeofencesDatabase(); // Instantiate GeofencesDatabase
        await geofencesDatabase
            .createGeofence(result); // Call createGeofence using the instance
        log('Geo-fence saved successfully');

        // 2. Update your LocationsPage (Assuming it's called 'LocationsPage')
        _updateLocationsPage(context);
      } on IsarError catch (e) {
        log('Error saving geo-fence: $e');
        // Display an error message to the user (Snackbar, Dialog, etc.)
      }
    }
  }

  // Helper Function to Update LocationsPage
  void _updateLocationsPage(BuildContext context) {
    // If you're using a StatefulWidget for LocationsPage:
    if (Navigator.of(context).canPop()) {
      // Assuming LocationsPage is in your navigation stack:
      Navigator.of(context).pop(); // Pop the dialog
      // Trigger a refresh on LocationsPage if needed
    } else {
      // Assuming LocationsPage is NOT in the navigation stack yet:
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LocationsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 2),
              ),
              height: 440,
              child: Maps(updateCoordinates: updateCoordinates),

              // Geofencing Implementation
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: SelectableText(
                    _currentCoordinates,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () => createGeofences(context),
                  backgroundColor: const Color.fromARGB(255, 6, 46, 156),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
