// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: geofences.map((geofence) {
            final tileColor =
                tileColors[geofences.indexOf(geofence) % tileColors.length];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(12),
                ),
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
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
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
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
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
                    // Add Punctuality Percentage for each geofence
                    Row(
                      children: [
                        const Icon(Icons.school_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Punctuality: ${punctualityPercentagePerGeofence[geofence.name]?.toStringAsFixed(2) ?? '0.00'}%',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
