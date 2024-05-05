import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart'; // Adjust the path if needed
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/geofence_detail_page.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  List<Geofences> _geoFences = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGeoFences();
  }

  Future<void> _loadGeoFences() async {
    setState(() {
      _isLoading = true; // Show a loading indicator
    });

    try {
      final geoFences = await GeofencesDatabase.readAllGeofences();

      setState(() {
        _geoFences = geoFences;
        _isLoading = false; // Loading finished
      });
    } catch (error) {
      log('Error loading geo-fences: $error');
      // Handle the error appropriately (e.g., display an error message)
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteGeofence(int index) async {
    try {
      final geofenceToDelete = _geoFences[index];
      await GeofencesDatabase.deleteGeofence(geofenceToDelete.id);

      setState(() {
        _geoFences.removeAt(index); // Remove from UI
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Geofence deleted!')));
    } catch (e) {
      // Handle deletion errors (display error message, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> tileColors = [
      Colors.blue[100]!,
      Colors.teal[100]!,
      Colors.green[100]!,
      Colors.amber[100]!,
      // ... more colors as needed
    ];
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _geoFences.length,
              itemBuilder: (context, index) {
                final tileColor = tileColors[index % tileColors.length];
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 20, bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      // ... Your ListTile code ...
                      title: Text(_geoFences[index].name),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Delete button
                          IconButton(
                            onPressed: () => deleteGeofence(index),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeoFenceDetailsPage(
                                geoFence: _geoFences[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
