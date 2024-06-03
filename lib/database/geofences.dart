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
class EventModel {
  Id id = Isar.autoIncrement;
  String title;
  int geofenceId;
  DateTime startTime;
  DateTime endTime;
  bool isRecurring;
  String? recurrenceRule;
  List<int>? recurrenceDays;

  EventModel({
    required this.title,
    this.geofenceId =
        -1, // Default to -1 (or any other invalid ID) if no geofence
    required this.startTime,
    required this.endTime,
    this.isRecurring = false,
    this.recurrenceRule,
    this.recurrenceDays,
  });
}

@Collection()
class DailyReport {
  Id id = Isar.autoIncrement;
  String geofenceName;
  DateTime date;
  List<EventReport> events = [];

  DailyReport({
    required this.geofenceName,
    required this.date,
    this.events = const [],
  });
}

@Embedded() // This class will be embedded inside DailyReport
class EventReport {
  String eventName;
  DateTime? scheduledStartTime;
  DateTime? entryTime;
  DateTime? exitTime;
  String punctuality;
  int? timeSpent;
  int? lateness;
  DateTime? scheduledEndTime; // Add scheduledEndTime here

  EventReport({
    this.eventName = '',
    this.scheduledStartTime,
    this.entryTime,
    this.exitTime,
    this.punctuality = '',
    this.timeSpent = 0,
    this.lateness = 0,
    this.scheduledEndTime, // Add it to the constructor as well
  });
}
