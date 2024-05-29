import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:geo_chronicle/utils/event_creation_form.dart';
import 'package:geo_chronicle/utils/types.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Event>> _events = {};
  List<Geofences> geofences = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadGeofences(); // Load geofences on startup
  }

  Future<void> _loadGeofences() async {
    final fetchedGeofences = await GeofencesDatabase.readAllGeofences();
    setState(() {
      geofences = fetchedGeofences;
    });
  }

  Future<Map<DateTime, List<Event>>> _loadEvents() async {
    final isar = GeofencesDatabase.isar;
    final eventsFromDatabase = await isar.eventModels.where().findAll();
    return _groupEventsByDay(eventsFromDatabase
        .map((eventModel) => Event.fromModel(eventModel))
        .toList());
  }

  Map<DateTime, List<Event>> _groupEventsByDay(List<Event> events) {
    Map<DateTime, List<Event>> groupedEvents = {};
    DateTime today = DateTime.now().toUtc().subtract(const Duration(days: 1));

    for (final event in events) {
      if (event.isRecurring) {
        DateTime eventStartDate = event.startTime.toUtc();
        while (eventStartDate
            .isBefore(_focusedDay.add(const Duration(days: 365)))) {
          if (_shouldAddEventOnDate(eventStartDate, event) &&
              !eventStartDate.isBefore(today)) {
            groupedEvents.update(
              DateTime.utc(eventStartDate.year, eventStartDate.month,
                  eventStartDate.day),
              (existingEvents) => List.from(existingEvents)..add(event),
              ifAbsent: () => [event],
            );
          }
          eventStartDate =
              _getNextRecurrenceDate(eventStartDate, event.recurrenceRule);
        }
      } else {
        final eventDate = DateTime.utc(
            event.startTime.year, event.startTime.month, event.startTime.day);
        if (eventDate.month == _focusedDay.month &&
            eventDate.year == _focusedDay.year) {
          groupedEvents.update(
            eventDate,
            (existingEvents) => List.from(existingEvents)..add(event),
            ifAbsent: () => [event],
          );
        }
      }
    }
    return groupedEvents;
  }

  DateTime _getNextRecurrenceDate(DateTime date, RecurrenceRule rule) {
    switch (rule) {
      case RecurrenceRule.daily:
        return date.add(const Duration(days: 1));
      case RecurrenceRule.weekly:
        return date.add(const Duration(days: 7));
      default:
        return date.add(const Duration(days: 1));
    }
  }

  bool _shouldAddEventOnDate(DateTime date, Event event) {
    if (!event.isRecurring) return false;
    switch (event.recurrenceRule) {
      case RecurrenceRule.daily:
        return true;
      case RecurrenceRule.weekly:
        return event.recurrenceDays!.contains(date.weekday);
      case RecurrenceRule.monthly:
        return event.startTime.day == date.day;
      case RecurrenceRule.custom:
        return (event.recurrenceDays ?? []).contains(date.weekday);
      default:
        return false;
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _createNewEvent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreationScreen(
          selectedDate: _focusedDay,
          geofences: geofences,
        ),
      ),
    );
    if (result != null && result is Event) {
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewEvent,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<Map<DateTime, List<Event>>>(
        future: _loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            _events = snapshot.data ?? {};
            return Column(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  eventLoader: _getEventsForDay,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: const CalendarStyle(
                    outsideDaysVisible: false,
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return _buildEventMarker(events.length);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: _selectedDay != null
                      ? _buildEventList(_selectedDay!)
                      : const Center(child: Text('No events for this day')),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildEventList(DateTime day) {
    List<Event> events = _getEventsForDay(day);
    events.sort((a, b) => a.startTime.compareTo(b.startTime));

    return events.isEmpty
        ? const Center(child: Text('No events for this day'))
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final tileColor = _getTileColor(index);

              return InkWell(
                  // Wrap ListTile in Dismissible for swipe-to-delete
                  child: Dismissible(
                key: UniqueKey(), // Unique key for Dismissible
                onDismissed: (direction) {
                  // Show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm Delete"),
                        content: const Text(
                            "Are you sure you want to delete this event?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false); // Don't delete
                              setState(() {
                                events.insert(
                                    index, event); // Reinsert the event
                              });
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true); // Confirm delete
                              // Delete the event
                              _deleteEvent(event.id);
                              setState(() {
                                events.removeAt(index); // Remove from the list
                              });
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: tileColor,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        event.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Start: ${DateFormat.jm().format(event.startTime)}'),
                            Text(
                                'End: ${DateFormat.jm().format(event.endTime)}'),
                          ],
                        ),
                      ),
                      trailing:
                          event.isRecurring ? const Icon(Icons.repeat) : null,
                    ),
                  ),
                ),
              ));
            },
          );
  }

  void _deleteEvent(int eventId) async {
    try {
      await GeofencesDatabase.deleteEvent(eventId); // Await the deletion

      // Show a SnackBar confirming deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully!')),
      );

      // Await the loading of events
      _events = await _loadEvents();

      // Rebuild the UI after the events are loaded
      setState(() {});
    } catch (e) {
      // Handle potential errors
      log('Error deleting event: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete event.')),
      );
    }
  }

  Color _getTileColor(int index) {
    List<Color> tileColors = [
      Colors.blue[100]!,
      Colors.teal[100]!,
      Colors.green[100]!,
      Colors.amber[100]!,
      // Add more colors as needed
    ];

    return tileColors[index % tileColors.length];
  }

  Widget _buildEventMarker(int eventCount) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(255, 120, 217, 88),
      ),
      child: Center(
        child: Text(
          '$eventCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 6,
          ),
        ),
      ),
    );
  }
}
