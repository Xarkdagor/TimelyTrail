import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class GeofencesDatabase {
  static late Isar isar;

  // Initialization
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [GeofencesSchema, CategoriesSchema, EventModelSchema],
        directory: dir.path);

    await ensureCategoriesExist();
  }

  static Future<void> dispose() async {
    // Check if the instance exists
    await isar.close();
  }

  static Future<void> addPredefinedGeofences() async {
    List<Geofences> predefinedGeofences = [
      Geofences(
        name: "Home",
        latitude: 28.6382947, // Replace with actual coordinates
        longitude: 77.2091844,
        color: Colors.red.value,
        dailyTimeSpentInSeconds: 0,
        category: "Department",
      ),
      Geofences(
        name: "Work",
        latitude: 28.6139391,
        longitude: 77.2090212,
        color: Colors.green.value,
        dailyTimeSpentInSeconds: 0,
        category: "Food",
      ),
      Geofences(
        name: "Gym",
        latitude: 28.612912,
        longitude: 77.209023,
        color: Colors.blue.value,
        dailyTimeSpentInSeconds: 0,
        category: null,
        radius: 30, // Add radius if it's a required field
      ),
    ];

    try {
      await isar.writeTxn(() async {
        for (var geofence in predefinedGeofences) {
          // Check if a geofence with the same name already exists
          if ((await isar.geofences
                  .filter()
                  .nameEqualTo(geofence.name)
                  .findFirst()) ==
              null) {
            await isar.geofences.put(geofence); // Put if not exists
          }
        }
      });
    } catch (e) {
      // Handle errors, e.g., by logging or displaying a message
      print('Error adding predefined geofences: $e');
    }
  }

  static Future<void> ensureCategoriesExist() async {
    // Check if the categories collection is empty
    bool categoriesExist = await isar.categories.where().count() > 0;

    if (!categoriesExist) {
      await isar.writeTxn(() async {
        await isar.categories
            .put(Categories(name: "Lecture Hall", standardRadius: 25.0));

        await isar.categories
            .put(Categories(name: "Department", standardRadius: 40.0));
        // ... add more categories ...
      });
    }
  }

  // For color generation
  Color _generateRandomColor() {
    return Color.fromARGB(
      255, // Alpha (full opacity)
      math.Random().nextInt(255),
      math.Random().nextInt(255),
      math.Random().nextInt(255),
    );
  }

  // Create Geofence
  Future<int> createGeofence(Geofences geoFence) async {
    log('Inside GeofencesDatabase.createGeofence()');
    return await isar.writeTxn(() async {
      // Generate a random color
      Color randomColor = _generateRandomColor();

      // Convert color to int before storing
      geoFence.color = randomColor.value;
      geoFence.entryTimestamp = null;
      geoFence.exitTimestamp = null;
      geoFence.totalTimeSpentInSeconds = 0;

      // Assign standard radius if a category is present
      if (geoFence.category != null) {
        geoFence.radius = await _getStandardRadius(geoFence.category!);
      }

      return await isar.geofences.put(geoFence);
    });
  }

  // Read Geofences (Various Options)
  static Future<List<Geofences>> readAllGeofences() async {
    return await isar.geofences.where().findAll();
  }

  static Future<Geofences?> readGeofenceById(int id) async {
    return await isar.geofences.get(id);
  }

  // Example with Filtering (Adjust as needed)
  static Future<List<Geofences>> readGeofencesByName(String name) async {
    return await isar.geofences.filter().nameEqualTo(name).findAll();
  }

  // Update geofence
  static Future<void> updateGeofence(Geofences geoFence) async {
    await isar.writeTxn(() async {
      await isar.geofences.put(geoFence);
    });
  }

  // Delete geofence
  static Future<void> deleteGeofence(int id) async {
    await isar.writeTxn(() async {
      await isar.geofences.delete(id);
    });
  }

  Future<double?> _getStandardRadius(String category) async {
    final result = await isar.categories
        .filter()
        .nameEqualTo(category)
        .standardRadiusIsNotNull() // Filter for non-null standardRadius
        .findFirst();

    return result?.standardRadius;
  }
}
