class Event {
  final String title;
  final int geofenceId;
  final DateTime startTime;
  final DateTime endTime;
  final bool isRecurring;
  final String? recurrenceRule; // 'daily', 'weekly', 'monthly', etc.
  final List<int>? recurrenceDays; // For weekly recurrence: 1=Mon, 2=Tue, etc.

  Event({
    required this.title,
    required this.geofenceId,
    required this.startTime,
    required this.endTime,
    this.isRecurring = false,
    this.recurrenceRule,
    this.recurrenceDays,
  });
}
