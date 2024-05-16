import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/utils/types.dart';

class Event {
  final String title;
  final int
      geofenceId; // You might want to change this to a more general location identifier if you're removing geofences
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final RecurrenceRule recurrenceRule;
  final List<int>? recurrenceDays;

  Event({
    required this.title,
    required this.geofenceId,
    required this.startTime,
    required this.endTime,
    this.isRecurring = false,
    this.recurrenceRule = RecurrenceRule.none,
    this.recurrenceDays,
  });

  // Factory constructor to create an Event from an EventModel
  factory Event.fromModel(EventModel model) {
    RecurrenceRule recurrenceRule = RecurrenceRule.none; // Default value
    if (model.recurrenceRule != null) {
      try {
        recurrenceRule = RecurrenceRule.values.byName(model.recurrenceRule!);
      } catch (e) {
        // Handle the case where recurrenceRule is not found in the enum
        print('Invalid recurrenceRule: ${model.recurrenceRule}');
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

  // Helper method to get the correct RecurrenceRule from the string value in EventModel
  RecurrenceRule _getRecurrenceRule(String? ruleName) {
    switch (ruleName) {
      case 'daily':
        return RecurrenceRule.daily;
      case 'weekly':
        return RecurrenceRule.weekly;
      case 'monthly':
        return RecurrenceRule.monthly;
      case 'custom':
        return RecurrenceRule.custom;
      default:
        return RecurrenceRule.none; // Handle null or unknown values
    }
  }
}
