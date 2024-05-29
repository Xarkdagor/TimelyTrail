import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/datagrid.dart';
import 'package:intl/intl.dart';

class EventCreationScreen extends StatefulWidget {
  final DateTime selectedDate;
  final List<Geofences> geofences;

  const EventCreationScreen({
    super.key,
    required this.selectedDate,
    required this.geofences,
  });

  @override
  EventCreationScreenState createState() => EventCreationScreenState();
}

class EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  TimeOfDay _selectedStartTime = TimeOfDay.now();
  TimeOfDay _selectedEndTime = TimeOfDay.now();
  bool _isRecurring = false;
  String? _selectedRecurrenceRule;
  final List<int> _selectedRecurrenceDays = [];
  Geofences? _selectedGeofence;

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm(); // Use 'jm' for AM/PM format
    return format.format(dt);
  }

  List<Geofences> _geofences = [];

  @override
  void initState() {
    super.initState();
    _fetchGeofences();
    _selectedStartTime = TimeOfDay.fromDateTime(widget.selectedDate);
    _selectedEndTime = TimeOfDay.fromDateTime(
        widget.selectedDate.add(const Duration(hours: 1)));
  }

  Future<void> _fetchGeofences() async {
    _geofences = await GeofencesDatabase.readAllGeofences();
    setState(() {}); // Rebuild the UI with the fetched geofences
  }

  @override
  void dispose() {
    _titleController.dispose();
    _startTimeController.dispose(); // Dispose controllers
    _endTimeController.dispose();
    super.dispose();
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      final eventModel = EventModel(
        title: _titleController.text,
        geofenceId: _selectedGeofence!.id,
        startTime: DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          _selectedStartTime.hour,
          _selectedStartTime.minute,
        ),
        endTime: DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          _selectedEndTime.hour,
          _selectedEndTime.minute,
        ),
        isRecurring: _isRecurring,
        // Change the RecurrenceRule from String to enum type
        recurrenceRule: _selectedRecurrenceRule?.toLowerCase(),
        recurrenceDays:
            _selectedRecurrenceDays.isNotEmpty ? _selectedRecurrenceDays : null,
      );

      // Save the EventModel to Isar database
      await GeofencesDatabase.isar.writeTxn(() async {
        await GeofencesDatabase.isar.eventModels.put(eventModel);
      });

      Navigator.pop(context, eventModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title TextFormField
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Geofence Dropdown
                DropdownButtonFormField<Geofences>(
                  value: _selectedGeofence,
                  onChanged: (Geofences? newValue) {
                    setState(() {
                      _selectedGeofence = newValue!;
                    });
                  },
                  items: _geofences.map((Geofences geofence) {
                    return DropdownMenuItem<Geofences>(
                      value: geofence,
                      child: Text(geofence.name),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                    fillColor: Color.fromARGB(255, 212, 208, 208),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a geofence';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Start Time Picker
                TextFormField(
                  readOnly: true,
                  controller: _startTimeController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          'Start Time (${_formatTimeOfDay(_selectedStartTime)})'),
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedStartTime,
                    );
                    if (pickedTime != null &&
                        pickedTime != _selectedStartTime) {
                      setState(() {
                        _selectedStartTime = pickedTime;
                        _startTimeController.text =
                            _formatTimeOfDay(pickedTime);
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // End Time Picker
                TextFormField(
                  readOnly: true,
                  controller: _endTimeController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          'End Time (${_formatTimeOfDay(_selectedEndTime)})'),
                  onTap: () async {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedEndTime,
                    );
                    if (pickedTime != null && pickedTime != _selectedEndTime) {
                      setState(() {
                        _selectedEndTime = pickedTime;
                        _endTimeController.text = _formatTimeOfDay(pickedTime);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an end time';
                    }
                    if (_selectedEndTime.hour < _selectedStartTime.hour ||
                        (_selectedEndTime.hour == _selectedStartTime.hour &&
                            _selectedEndTime.minute <=
                                _selectedStartTime.minute)) {
                      return 'End time cannot be before or same as start time';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                // Recurring Event Switch
                SwitchListTile(
                  title: const Text("Recurring Event"),
                  value: _isRecurring,
                  onChanged: (newValue) {
                    setState(() {
                      _isRecurring = newValue;
                    });
                  },
                ),

                // Recurrence Options (Visible only if _isRecurring is true)
                if (_isRecurring)
                  Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedRecurrenceRule,
                        onChanged: (newValue) =>
                            setState(() => _selectedRecurrenceRule = newValue),
                        items: ['Daily', 'Weekly', 'Monthly', 'Custom']
                            .map((rule) => DropdownMenuItem(
                                value: rule, child: Text(rule)))
                            .toList(),
                        decoration:
                            const InputDecoration(labelText: 'Recurrence Rule'),
                      ),
                      if (_selectedRecurrenceRule == 'weekly')
                        Wrap(
                          spacing: 8.0,
                          children: List.generate(7, (index) {
                            return Checkbox(
                              value:
                                  _selectedRecurrenceDays.contains(index + 1),
                              onChanged: (checked) {
                                setState(() {
                                  if (checked == true) {
                                    _selectedRecurrenceDays.add(index + 1);
                                  } else {
                                    _selectedRecurrenceDays.remove(index + 1);
                                  }
                                });
                              },
                            );
                          }),
                        ),
                      if (_selectedRecurrenceRule == 'Custom')
                        Wrap(
                          spacing: 8.0,
                          children: List.generate(7, (index) {
                            final dayOfWeek = DateFormat('EEE')
                                .format(DateTime(2023, 1, index + 1));
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(dayOfWeek),
                                const SizedBox(width: 8.0),
                                Checkbox(
                                  value: _selectedRecurrenceDays
                                      .contains(index + 1),
                                  onChanged: (checked) {
                                    setState(() {
                                      if (checked == true) {
                                        _selectedRecurrenceDays.add(index + 1);
                                      } else {
                                        _selectedRecurrenceDays
                                            .remove(index + 1);
                                      }
                                    });
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                    ],
                  ),
                const SizedBox(
                  height: 40,
                ),

                // Save Button
                Center(
                  child: ElevatedButton(
                    onPressed: _saveEvent,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 66, 93, 201),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5), // padding
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Save Event",
                        style: TextStyle(
                          fontSize: 14, // text size
                          fontWeight: FontWeight.bold, // text weight
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.grey[500],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Text(
                          " OR ",
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1.0,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SpreadSheet())),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 66, 93, 201),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5), // padding
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "View/Edit Schedule",
                        style: TextStyle(
                          fontSize: 16, // text size
                          fontWeight: FontWeight.bold, // text weight
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
