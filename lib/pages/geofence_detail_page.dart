import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';

class GeoFenceDetailsPage extends StatelessWidget {
  final Geofences geoFence;

  const GeoFenceDetailsPage({super.key, required this.geoFence});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(geoFence.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Latitude: ${geoFence.latitude}'),
            Text('Longitude: ${geoFence.longitude}'),
            Text('Radius: ${geoFence.radius}'),

            // You might want a more visually appealing display of the color:
            Container(
              height: 30,
              width: 60,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            // ... Add other details you might store ...
          ],
        ),
      ),
    );
  }
}
