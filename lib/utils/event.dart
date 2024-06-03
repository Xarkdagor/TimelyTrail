import 'dart:developer';

import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/utils/types.dart';
import 'package:isar/isar.dart';

class Event {
  int id; // Add an ID field
  final String title;
  final int geofenceId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final RecurrenceRule recurrenceRule;
  final List<int>? recurrenceDays;
  DateTime? entryTime; // Actual entry time (nullable)
  PunctualityStatus punctuality = PunctualityStatus.notArrived; // Default

  // Constructor
  Event({
    this.id = Isar.autoIncrement,
    required this.title,
    required this.geofenceId,
    required this.startTime,
    required this.endTime,
    this.isRecurring = false,
    this.recurrenceRule = RecurrenceRule.none,
    this.recurrenceDays,
    this.entryTime,
  }) {
    // Validate start and end times
    if (startTime.isAfter(endTime)) {
      throw ArgumentError('Start time cannot be after end time.');
    }
  }

  // Factory constructor from EventModel (existing code, no changes)
  // ...

  factory Event.fromModel(EventModel model) {
    RecurrenceRule recurrenceRule = RecurrenceRule.none; // Default value
    if (model.recurrenceRule != null) {
      try {
        recurrenceRule = RecurrenceRule.values.byName(model.recurrenceRule!);
      } catch (e) {
        // Handle the case where recurrenceRule is not found in the enum
        log('Invalid recurrenceRule: ${model.recurrenceRule}');
      }
    }
    return Event(
      title: model.title,
      geofenceId: model.geofenceId,
      startTime: model.startTime,
      endTime: model.endTime,
      isRecurring: model.isRecurring,
      recurrenceRule: recurrenceRule,
      recurrenceDays: model.recurrenceDays,
    );
  }

  // Add a method to update punctuality
  void updatePunctuality() {
    if (entryTime == null) {
      punctuality = PunctualityStatus.notArrived;
    } else if (entryTime!.isBefore(startTime)) {
      punctuality = PunctualityStatus.early;
    } else if (entryTime!.isAfter(startTime)) {
      punctuality = PunctualityStatus.late;
    } else {
      punctuality = PunctualityStatus.onTime;
    }
  }
}

// Enum for punctuality status
enum PunctualityStatus {
  early,
  onTime,
  late,
  notArrived, // For events that haven't started yet
  leftEarly, // User left before the scheduled end time
}
