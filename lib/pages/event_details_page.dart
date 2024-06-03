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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Card
              Card(
                elevation: 2.0,
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
                    ],
                  ),
                ),
              ),

              // Punctuality Card
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: _getPunctualityColor(
                    event), // Set card color based on punctuality
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildDetailRowWithIcon(
                    'Punctuality:',
                    _getPunctualityString(event),
                    _getPunctualityIcon(event),
                  ),
                ),
              ),

              // Entry/Exit Time Card (only if entered)
              if (event.entryTime != null)
                Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                            'Entry Time:',
                            _formatEntryTime(event
                                .entryTime)), // Use _formatEntryTime() to format the time
                        if (event.punctuality != PunctualityStatus.notArrived)
                          _buildDetailRow(
                              'Lateness:',
                              _calculateLateness(
                                      event.entryTime!, event.startTime)
                                  .toString()),
                      ],
                    ),
                  ),
                )
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
      case PunctualityStatus.leftEarly:
        return 'Left Early';
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

Duration _calculateLateness(DateTime entryTime, DateTime startTime) {
  if (entryTime.isAfter(startTime)) {
    return entryTime.difference(startTime);
  } else {
    return Duration.zero; // Not late
  }
}

//Function for getting color according to punctuality
Color _getPunctualityColor(Event event) {
  switch (event.punctuality) {
    case PunctualityStatus.early:
      return Colors.green[100]!;
    case PunctualityStatus.onTime:
      return Colors.yellow[100]!;
    case PunctualityStatus.late:
      return Colors.red[100]!;
    case PunctualityStatus.leftEarly:
      return Colors.orange[100]!;
    default:
      return Colors.grey[200]!; // Default color for 'Not Arrived Yet'
  }
}
