import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:geo_chronicle/utils/event_creation_form.dart';
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

  Map<DateTime, List<Event>> _events = {}; // Sample events for testing

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
    _events = {}; // Load events from your data source
  }

  Future<void> _loadEvents() async {
    final isar = GeofencesDatabase.isar; // Get Isar instance
    final eventsFromDatabase = await isar.eventModels.where().findAll();

    // Create a new map for events
    Map<DateTime, List<Event>> events = {};

    for (var eventModel in eventsFromDatabase) {
      final eventDate = DateTime(
        eventModel.startTime.year,
        eventModel.startTime.month,
        eventModel.startTime.day,
      );

      // Create an Event object from the EventModel data
      final event = Event(
        title: eventModel.title,
        geofenceId: eventModel.geofenceId,
        startTime: eventModel.startTime,
        endTime: eventModel.endTime,
        isRecurring: eventModel.isRecurring,
        recurrenceRule: eventModel.recurrenceRule,
        recurrenceDays: eventModel.recurrenceDays,
      );

      // Add the event to the map
      if (events.containsKey(eventDate)) {
        events[eventDate]!.add(event);
      } else {
        events[eventDate] = [event];
      }
    }

    setState(() {
      _events = events;
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    List<Geofences> geofences = await GeofencesDatabase.readAllGeofences();

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventCreationScreen(
          selectedDate: selectedDay,
          geofences: geofences, // Pass geofences to EventCreationScreen
        ),
      ),
    );

    if (result != null && result is Event) {
      // Save the new event to the database
      await GeofencesDatabase.isar.writeTxn(() async {
        await GeofencesDatabase.isar.eventModels.put(EventModel(
          title: result.title,
          geofenceId: result.geofenceId,
          startTime: result.startTime,
          endTime: result.endTime,
          isRecurring: result.isRecurring,
          recurrenceRule: result.recurrenceRule,
          recurrenceDays: result.recurrenceDays,
        ));
      });

      setState(() {
        if (result.isRecurring) {
          switch (result.recurrenceRule) {
            case 'Daily':
              _addRecurringEventDaily(selectedDay, result);
              break;
            case 'Weekly':
              _addRecurringEventWeekly(selectedDay, result);
              break;
            case 'Monthly':
              // Add monthly recurrence logic here
              break;
            case 'Custom':
              _addRecurringEventCustom(selectedDay, result);
              break;
          }
        } else {
          _events.update(
            selectedDay,
            (existingEvents) => List.from(existingEvents)..add(result),
            ifAbsent: () => [result],
          );
        }
      });
    }
  }

  void _addRecurringEventDaily(DateTime startDate, Event event) {
    for (int i = 0; i < 7; i++) {
      DateTime date = startDate.add(Duration(days: i));
      _events.update(
        date,
        (existingEvents) => List.from(existingEvents)..add(event),
        ifAbsent: () => [event],
      );
    }
  }

  void _addRecurringEventWeekly(DateTime startDate, Event event) {
    for (int dayOfWeek in event.recurrenceDays ?? []) {
      DateTime recurringDate = _findNextDay(startDate, dayOfWeek);

      _events.update(
        recurringDate,
        (existingEvents) => List.from(existingEvents)..add(event),
        ifAbsent: () => [event],
      );
    }
  }

  DateTime _findNextDay(DateTime startDate, int dayOfWeek) {
    while (startDate.weekday != dayOfWeek) {
      startDate = startDate.add(const Duration(days: 1));
    }
    return startDate;
  }

  void _addRecurringEventCustom(DateTime startDate, Event event) {
    for (int dayOfWeek in event.recurrenceDays ?? []) {
      DateTime recurringDate = startDate;
      while (recurringDate.weekday != dayOfWeek) {
        recurringDate = recurringDate.add(const Duration(days: 1));
      }
      _events.update(
        recurringDate,
        (existingEvents) => List.from(existingEvents)..add(event),
        ifAbsent: () => [event],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: events.map((event) => _buildEventMarker()).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventMarker() {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
    );
  }
}
