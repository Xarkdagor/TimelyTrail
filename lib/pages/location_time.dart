// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/event_details_page.dart';
import 'package:intl/intl.dart';

class LocationTime extends StatelessWidget {
  final List<Geofences> geofences;
  final Map<String, double> punctualityPercentagePerGeofence;

  LocationTime({
    super.key,
    required this.geofences,
    required this.punctualityPercentagePerGeofence,
  });

  List<Color> tileColors = [
    Colors.blue[100]!,
    Colors.teal[100]!,
    Colors.green[100]!,
    Colors.amber[100]!,
    // ... more colors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Time"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: geofences.isEmpty
            ? const Center(child: Text("No locations visited yet."))
            : ListView.builder(
                itemCount: geofences.length,
                itemBuilder: (context, index) {
                  final geofence = geofences[index];
                  final tileColor = tileColors[index % tileColors.length];
                  final punctuality =
                      punctualityPercentagePerGeofence[geofence.name] ?? 0.0;

                  return InkWell(
                    onTap: () async {
                      try {
                        final events =
                            await GeofencesDatabase.getEventsForGeofence(
                                geofence.id);
                        if (events.isNotEmpty) {
                          // Navigate to the EventDetailsPage with the first event
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailsPage(event: events.first),
                            ),
                          );
                        } else {
                          // Handle case where there are no events for this geofence
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('No events found for this geofence')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error loading events: $e')),
                        );
                      }
                    },
                    child: Card(
                      color: tileColor,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(geofence.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pass the correct argument types to _buildTimeRow
                            _buildTimeRow(
                                "Entry Time:", geofence.entryTimestamp),
                            _buildTimeRow("Exit Time:", geofence.exitTimestamp),
                            _buildTimeRow(
                                "Total Time:",
                                geofence
                                    .totalTimeSpentInSeconds), // Pass int for totalTimeSpentInSeconds
                            _buildPunctualityRow(punctuality),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  // Helper function to format time
  Widget _buildTimeRow(String label, dynamic timeValue) {
    // Use dynamic for flexibility
    String timeString;
    if (timeValue is DateTime) {
      timeString = DateFormat('dd MMM yyyy, HH:mm:ss').format(timeValue);
    } else if (timeValue is int) {
      timeString = '${timeValue ~/ 60} mins'; // Convert seconds to minutes
    } else {
      timeString = "N/A";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text("$label $timeString"),
    );
  }

// Helper function to format time

// Helper function to format punctuality
  Widget _buildPunctualityRow(double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text("Punctuality: ${percentage.toStringAsFixed(2)}%"),
    );
  }
}
