import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class GeofencesDatabase {
  static late Isar isar;

  // Initialization
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      GeofencesSchema,
      CategoriesSchema,
      EventModelSchema,
      DailyReportSchema
    ], directory: dir.path);

    await ensureCategoriesExist();
  }

  static Future<void> dispose() async {
    // Check if the instance exists
    await isar.close();
  }

  static Future<void> addPredefinedGeofences() async {
    List<Geofences> predefinedGeofences = [
      Geofences(
        name: "Gym",
        latitude: 28.6382947, // Replace with actual coordinates
        longitude: 77.2091844,
        color: Colors.red.value,

        category: "Department",
      ),
      Geofences(
        name: "Library",
        latitude: 28.6139391,
        longitude: 77.2090212,
        color: Colors.green.value,
        category: "Food",
      ),
      Geofences(
        name: "Sports Complex",
        latitude: 28.612912,
        longitude: 77.209023,
        color: Colors.blue.value,

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
      log('Error adding predefined geofences: $e');
    }
  }

  // to delete event
  static Future<void> deleteEvent(int eventId) async {
    await isar.writeTxn(() async {
      await isar.eventModels.delete(eventId);
    });
  }

  // Method to get all events for a geofence
  static Future<List<Event>> getEventsForGeofence(int geofenceId) async {
    return await isar.eventModels
        .filter()
        .geofenceIdEqualTo(geofenceId)
        .findAll()
        .then((eventModels) =>
            eventModels.map((e) => Event.fromModel(e)).toList());
  }

  // Method to update an event's punctuality
  // Method to update an event's punctuality
  static Future<void> updateEventPunctuality(
      int eventId, DateTime? entryTime) async {
    return await isar.writeTxn(() async {
      final eventModel = await isar.eventModels.get(eventId);
      if (eventModel != null) {
        final event = Event.fromModel(eventModel);
        event.entryTime = entryTime;
        event.updatePunctuality();

        // Update the eventModel in the database (without the id parameter)
        await isar.eventModels.put(EventModel(
          title: event.title,
          geofenceId: event.geofenceId,
          startTime: event.startTime,
          endTime: event.endTime,
          isRecurring: event.isRecurring,
          recurrenceRule: event.recurrenceRule.toString(),
          recurrenceDays: event.recurrenceDays,
        ));
      }
    });
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

  static Future<void> generateDetailedReportAndUploadToGoogleSheets(
      {DateTime? startDate, DateTime? endDate}) async {
    List<List<dynamic>> rows = [
      [
        'Date',
        'Day of Week',
        'Geofence Name',
        'Event Title',
        'Start Time',
        'End Time',
        'Entry Time',
        'Exit Time',
        'Punctuality',
        'Lateness (minutes)',
        'Time Spent (minutes)'
      ],
    ];

    // Fetch the daily reports based on the date range (if provided)
    final dailyReports =
        await GeofencesDatabase.isar.dailyReports // Access isar here
            .filter()
            .dateGreaterThan(startDate ?? DateTime.utc(2020, 1, 1))
            .dateLessThan(endDate ?? DateTime.now())
            .findAll();

    // Loop through each daily report
    for (final dailyReport in dailyReports) {
      final dateString = DateFormat('yyyy-MM-dd').format(dailyReport.date);
      final dayOfWeek = DateFormat('EEEE').format(dailyReport.date);

      for (final event in dailyReport.events) {
        final scheduledStartTime = event.scheduledStartTime != null
            ? DateFormat('HH:mm:ss').format(event.scheduledStartTime!)
            : 'N/A'; // Handle null startTime
        final scheduledEndTime = event.scheduledEndTime != null
            ? DateFormat('HH:mm:ss').format(event.scheduledEndTime!)
            : 'N/A';
        final entryTime = event.entryTime != null
            ? DateFormat('HH:mm:ss').format(event.entryTime!)
            : 'Not Entered';
        final exitTime = event.exitTime != null
            ? DateFormat('HH:mm:ss').format(event.exitTime!)
            : 'Not Exited';

        rows.add([
          dateString,
          dayOfWeek,
          dailyReport.geofenceName,
          event.eventName,
          scheduledStartTime,
          scheduledEndTime,
          entryTime,
          exitTime,
          event.punctuality,
          event.lateness ?? 0,
          event.timeSpent ?? 0,
        ]);
      }
    }
    try {
      // 1. Auth entication (load credentials securely)
      const creds = r'''
{
  "type": "service_account",
  "project_id": "flutter-gsheets-425211",
  "private_key_id": "eb0574ea30c89550cdb6d283f8cf868c89949ecc",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD0PCfR6BpfZxr7\ntP6n3khDCMxFsavo+OVPM9TJYEHQLe/kXTMmJCHCwStHQvd6Yqd0AFG266MC2jjm\nvqFrJDE011P3XgcLsseAnMIwweNMBe1/i4xpG61329cIiLfe5Coa4QbwoeVo0ar5\n9Am3e5BWcxvl8JtGyiTLBa/v4Q318JpWWDcTWkRfW7jzemjYtQ7ufpp6kokAGo3T\n8b7hvhqeLWQOQNEDo8qi9fFs5X/DuCA5fCORSoVmj45hWbUYKBYEIjYDAtJoKkJ/\n4DbFmsrXK5srE/TXEEhp+D7n1U9wAljziOMC+TKsD2dO1ONEq1ujSkLyfznAllhk\nKQqQn6KXAgMBAAECggEACpAxfrQls9ufQKS24ObNxEx0nU0ObOCa9l59BQqrPghG\nmF9pj2w/o488QnREhOAQcwVyg1FUtxJeJKi5DYu+rxTjFk9USa69TzQ4d+hi3s5g\n08Pi2kburUDuX3meTj8bDRePd8fgxrROy0nBQ9TNzNdkrQDHjnu+tKM11U+sDWd5\nfCaOvu7cdo61U+yjdhih/mz4QYKRhTf+Aorup7SvQhswyKaXpk/1LqL7YxsJjT6m\nablWrgdFEoLrOq6ZdQ3URho6PC7vgQQ+uwAE37TKRG1vCzham7gZyKsGTi5mHhBP\nUOqMAdxMXGo2GmzD4XYyD+deTyWIalXVXNaC03XfaQKBgQD68qIx8etRS464CLlx\nI7hvBwjOhKL/BvguW5tsAgnYggcqeVt0kSAQYxckxp6xmKhnPGdQl5dTKPgpNT4z\njpxicDYUNgHVeGJKzODPwx4yWcUWtqnsDYNG8SfqPxqqoHDxxHypQTa+GSNPsPyH\nrin8bHAmzfSY/E4kY/lPKbnLjwKBgQD5Juy3MF75FzehtlQaL7epEN+KQf9XamOa\n/CiECc5FvdGzBoY7Q8/GHhPQB0hTlZIUQ5hgsVyTCJ87HwbyU+rdWuNLtyHNB0kv\n5gx24ouXKR4hxVip/owaMbUaV3i7QfWehuRnPT0hGlgbtrGhPvuFlui4y0dWUDQu\nKO4l4wTUeQKBgQCBDlcrqGaEoH79Vj9IWD55mvyEeOH6lfL8pFAB8+psVjKpPVAz\nWo9K3isA1sS2QPQaY44efFduhRta1e7vROBYH60wJ7Y5uneSUFstfgMBkfkx/S7W\nHvzsdwk4BswIBAsRyyLxSICGsxbd3P+CJ6egEYR78F9ibh8hx+hnNeY/MQKBgBNM\nJIF7yZ9ZYQGxcYolr//0QpweyHwozVYvuaOgbs2QCjHni3YDppAdvEMcjUmMCChx\no9e5ZQYuYMbffFZAkaxbYcd3g7KxocWH9+ctXMp0cNUEx/1Cre9JclF7/OnkDfYd\nVIt6fsWVmMVsvQ1UJ38NVTEa7YeN5ry8htWAY9thAoGAd+zAdcNyvMjSYfaNZH2a\nSJ8wyynbk9Vlo2hxaXJHo6CMwzpKd7eN7vk4Gao/4Az5S3iQ5de8RFFG132i6Y6F\nSLkbYs4uGQi23aQA1d58QIVAHQ+XetaPEFNUpHydZHi3PptAoCJZS/dPxXwnFAQn\nzDncCFzPXMTL+UGolFsaFeE=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@flutter-gsheets-425211.iam.gserviceaccount.com",
  "client_id": "101631881973913122037",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheets-425211.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';
      final gsheets = GSheets(creds);
      final ss = await gsheets
          .spreadsheet('1K2gOhn-pEANJBUW__KjFPWbw9if1swzTugYhjl_frQM');
      final sheet = ss.worksheetByTitle('Sheet1');

      // 2. Clear and Update Data
      if (sheet != null) {
        // Use the correct method to clear
        await sheet.clear();
        await sheet.values.appendRow(rows[0]); // Append header separately
        await sheet.values
            .appendRows(rows.sublist(1)); // Append the rest of the data
      }

      // Optional: Display a success message
      // (You'll need to pass a BuildContext to this function or use another way to display the message)
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report uploaded to Google Sheets!')));
    } catch (e) {
      // Handle errors (show a SnackBar or dialog)
      log('Error uploading report to Google Sheets: $e');
      // ...
    }
  }

  static Future<void> addDummyDataToDatabase() async {
    try {
      await isar.writeTxn(() async {
        await isar.dailyReports.putAll([
          dummyDailyReport1,
          dummyDailyReport2,
          dummyDailyReport3,
          dummyDailyReport4
        ]);
      });
    } catch (e) {
      // Handle errors, e.g., by logging or displaying a message
      log('Error adding dummy data: $e');
    }
  }

  // dummy data
  static final dummyDailyReport1 = DailyReport(
    geofenceName: "Gym",
    date: DateTime(2024, 5, 30),
    events: [
      EventReport(
        eventName: "Workout",
        scheduledStartTime: DateTime(2024, 5, 30, 6, 00),
        scheduledEndTime: DateTime(2024, 5, 30, 7, 30),
        entryTime: DateTime(2024, 5, 30, 6, 10),
        exitTime: DateTime(2024, 5, 30, 7, 30),
        punctuality: PunctualityStatus.late.name,
        timeSpent: 50,
        lateness: 10,
      ),
    ],
  );

  static final dummyDailyReport2 = DailyReport(
    geofenceName: "Room",
    date: DateTime(2024, 5, 31),
    events: [
      EventReport(
          eventName: "Study",
          scheduledStartTime: DateTime(2024, 5, 31, 6, 30),
          scheduledEndTime: DateTime(2024, 5, 31, 7, 38),
          entryTime: DateTime(2024, 5, 31, 6, 40),
          exitTime: DateTime(2024, 5, 31, 7, 30),
          punctuality: PunctualityStatus.leftEarly.name,
          timeSpent: 50,
          lateness: 10),
    ],
  );
  static final dummyDailyReport4 = DailyReport(
    geofenceName: "Sports Complex",
    date: DateTime(2024, 6, 2),
    events: [
      EventReport(
          eventName: "Running",
          scheduledStartTime: DateTime(2024, 6, 2, 5, 30),
          scheduledEndTime: DateTime(2024, 6, 2, 6, 00),
          entryTime: DateTime(2024, 6, 2, 5, 30),
          exitTime: DateTime(2024, 6, 2, 6, 00),
          punctuality: PunctualityStatus.onTime.name,
          timeSpent: 30,
          lateness: 0),
    ],
  );

  static final dummyDailyReport3 = DailyReport(
    geofenceName: "Room",
    date: DateTime(2024, 6, 1),
    events: [
      EventReport(
        eventName: "Meeting",
        scheduledStartTime: DateTime(2024, 6, 1, 10, 45),
        scheduledEndTime: DateTime(2024, 6, 1, 12, 30),
        entryTime: DateTime(2024, 6, 1, 10, 45),
        exitTime: DateTime(2024, 6, 1, 12, 30),
        punctuality: PunctualityStatus.early.name,
        timeSpent: 90,
        lateness: 0,
      ),
      EventReport(
        eventName: "Reading",
        scheduledStartTime: DateTime(2024, 6, 1, 15, 0),
        scheduledEndTime: DateTime(2024, 6, 1, 16, 10),
        entryTime: DateTime(2024, 6, 1, 15, 20),
        exitTime: DateTime(2024, 6, 1, 16, 10),
        punctuality: PunctualityStatus.late.name,
        timeSpent: 50,
        lateness: 20,
      ),
    ],
  );
}
