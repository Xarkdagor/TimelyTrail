import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:geo_chronicle/utils/event_creation_form.dart';
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
    for (final event in events) {
      final date = DateTime.utc(
          event.startTime.year, event.startTime.month, event.startTime.day);
      groupedEvents.update(
        date,
        (existingEvents) => List.from(existingEvents)..add(event),
        ifAbsent: () => [event],
      );
    }
    return groupedEvents;
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Function to navigate to EventCreationScreen when FAB is pressed
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
      _loadEvents(); // Reload events after creating a new one
    }
  }

  // Function to update selectedDay and focusedDay
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
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

  // Function to navigate to EventCreationScreen when FAB is pressed

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

  List<Color> tileColors = [
    Colors.blue[100]!,
    Colors.teal[100]!,
    Colors.green[100]!,
    Colors.amber[100]!,
    // ... more colors as needed
  ];

  Widget _buildEventList(DateTime day) {
    List<Event> events = _getEventsForDay(day);
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        final tileColor = tileColors[index % tileColors.length];
        return Padding(
          padding: const EdgeInsets.only(top: 6, left: 6, right: 15),
          child: Card(
            color: tileColor, // Apply the tile color to the Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10.0), // Adjust the value to change the border radius
            ),
            child: ListTile(
              title: Text(event.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Start Time: ${DateFormat.jm().format(event.startTime)}'),
                  Text('End Time: ${DateFormat.jm().format(event.endTime)}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventMarker(int eventCount) {
    return Container(
      width: 8.0,
      height: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.3),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: Center(
        child: Text(
          '$eventCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
          ),
        ),
      ),
    );
  }
}
