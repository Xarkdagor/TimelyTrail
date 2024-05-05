import "package:isar/isar.dart";

part 'geofences.g.dart';

@Collection()
class Geofences {
  Id id = Isar.autoIncrement;
  String name;
  double latitude;
  double longitude;
  int color;
  DateTime? entryTimestamp;
  DateTime? exitTimestamp;

  int totalTimeSpentInSeconds = 0;
  int sessionTimeSpentInSeconds = 0;
  int dailyTimeSpentInSeconds = 0;
  // Add a category field
  String? category;

  // Optional default radius
  double? radius; // Make radius optional

  Geofences({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.color,
    this.entryTimestamp,
    this.exitTimestamp,
    this.category,
    this.radius,
    required this.dailyTimeSpentInSeconds,
  });

  String getFormattedDailyDuration() {
    Duration duration = Duration(seconds: totalTimeSpentInSeconds);
    int hours = duration.inHours;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;
    return "$hours hours, $minutes minutes, $seconds seconds";
  }
}

@Collection()
class Categories {
  Id id = Isar.autoIncrement;
  String? name;
  double? standardRadius;

  Categories({required this.name, required this.standardRadius});
}

@Collection()
class DailyGeofenceRecord {
  Id id = Isar.autoIncrement;
  DateTime? date;
  int dailyTimeSpentInSeconds = 0;
  int? geofenceId;

  DailyGeofenceRecord(
      {this.date, required this.dailyTimeSpentInSeconds, this.geofenceId});
}
