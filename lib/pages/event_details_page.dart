import 'package:flutter/material.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        // To allow scrolling if content overflows
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                // Use a Card for a visually distinct container
                elevation: 2.0, // Add some elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Title:', event.title),
                      _buildDetailRow(
                          'Location (ID):', event.geofenceId.toString()),
                      _buildDetailRow('Start Time:',
                          DateFormat.jm().format(event.startTime)),
                      _buildDetailRow(
                          'End Time:', DateFormat.jm().format(event.endTime)),
                      _buildDetailRow(
                          'Recurring:', event.isRecurring ? 'Yes' : 'No'),
                      if (event.isRecurring)
                        _buildDetailRow('Recurrence Rule:',
                            event.recurrenceRule.toString()),
                      if (event.recurrenceDays != null)
                        _buildDetailRow('Recurrence Days:',
                            event.recurrenceDays!.join(', ')),
                      _buildDetailRow(
                          'Entry Time:', _formatEntryTime(event.entryTime)),
                      _buildDetailRowWithIcon(
                          'Punctuality:',
                          _getPunctualityString(event),
                          _getPunctualityIcon(
                              event) // Add icon based on punctuality
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatEntryTime(DateTime? entryTime) {
    if (entryTime == null) {
      return 'Not Entered Yet';
    } else {
      return DateFormat.jm().format(entryTime);
    }
  }

  String _getPunctualityString(Event event) {
    switch (event.punctuality) {
      case PunctualityStatus.early:
        return 'Early';
      case PunctualityStatus.onTime:
        return 'On Time';
      case PunctualityStatus.late:
        return 'Late';
      case PunctualityStatus.notArrived:
        return 'Not Arrived Yet';
    }
  }
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ', // Add space after label for better readability
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(child: Text(value)), // Use Expanded to wrap text
      ],
    ),
  );
}

// Helper function to build a row with an icon for punctuality
Widget _buildDetailRowWithIcon(String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(icon), // Display the punctuality icon
        const SizedBox(width: 8), // Add spacing between icon and text
        Expanded(child: Text(value)),
      ],
    ),
  );
}

IconData _getPunctualityIcon(Event event) {
  switch (event.punctuality) {
    case PunctualityStatus.early:
      return Icons.check_circle_outline; // Checkmark icon
    case PunctualityStatus.onTime:
      return Icons.timer; // Timer icon
    case PunctualityStatus.late:
      return Icons.warning_amber_outlined; // Warning icon
    default:
      return Icons.access_time; // Default clock icon
  }
}
