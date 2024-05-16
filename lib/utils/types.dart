// types.dart

// Enum for recurrence rules
enum RecurrenceRule {
  none,
  daily,
  weekly,
  monthly,
  custom,
}

extension RecurrenceRuleExtension on RecurrenceRule {
  // Helper method to get the enum value by its name
  String get name {
    return toString().split('.').last;
  }

  // Helper method to get the enum value by its name
  RecurrenceRule? byName(String name) {
    return RecurrenceRule.values.firstWhereOrNull(
      (element) => element.name == name,
    );
  }
}

extension IterableExtension<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
