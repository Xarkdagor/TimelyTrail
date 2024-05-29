import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/event_details_page.dart';
import 'package:geo_chronicle/utils/event.dart';
import 'package:isar/isar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _ChartData {
  _ChartData(this.x, this.y, [this.color]);
  final String x;
  final double y;
  final Color? color;
}

class _HomePageContentState extends State<HomePageContent> {
  List<Geofences> geofences = [];
  Map<String, int> timeSpentPerGeofence = {};
  Map<String, double> averagePunctualityPerGeofence = {};
  Map<String, List<Event>> geofenceEventsMap = {};

  @override
  void initState() {
    super.initState();
    _loadGeofencesAndData();
  }

  Future<void> _loadGeofencesAndData() async {
    try {
      geofences = await GeofencesDatabase.readAllGeofences();

      final isar = GeofencesDatabase.isar;
      final eventsFromDatabase = await isar.eventModels.where().findAll();
      final events = eventsFromDatabase
          .map((eventModel) => Event.fromModel(eventModel))
          .toList();

      for (var geofence in geofences) {
        final geofenceEvents =
            events.where((event) => event.geofenceId == geofence.id).toList();
        geofenceEventsMap[geofence.name] = geofenceEvents;

        int totalSeconds = 0;
        int punctualEvents = 0;
        for (var event in geofenceEvents) {
          totalSeconds += event.endTime.difference(event.startTime).inSeconds;
          if (event.punctuality == PunctualityStatus.onTime ||
              event.punctuality == PunctualityStatus.early) {
            punctualEvents++;
          }
        }
        timeSpentPerGeofence[geofence.name] = totalSeconds ~/ 60;

        double averagePunctuality = geofenceEvents.isNotEmpty
            ? (punctualEvents / geofenceEvents.length) * 100
            : 0;
        averagePunctualityPerGeofence[geofence.name] = averagePunctuality;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() {});
    }
  }

  List<_ChartData> getTimeSpentChartData() {
    return timeSpentPerGeofence.entries.map((entry) {
      return _ChartData(entry.key, entry.value.toDouble());
    }).toList();
  }

  List<_ChartData> getPunctualityChartData() {
    return averagePunctualityPerGeofence.entries.map((entry) {
      return _ChartData(entry.key, entry.value);
    }).toList();
  }

  // New Pie Chart for Average Punctuality
  Widget _buildAveragePunctualityChart() {
    List<_ChartData> data = [
      _ChartData('On Time / Early', _calculateTotalPunctuality()),
      _ChartData('Late', 100 - _calculateTotalPunctuality()),
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              "Overall Punctuality",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16.0),
          SfCircularChart(
            legend: const Legend(
                isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
            series: <CircularSeries>[
              // Renders the pie chart
              PieSeries<_ChartData, String>(
                dataSource: data,
                pointColorMapper: (_ChartData data, _) => data.color,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
        ],
      ),
    );
  }

  double _calculateTotalPunctuality() {
    if (averagePunctualityPerGeofence.isEmpty) return 0.0;
    int totalEvents = 0;
    double totalPunctuality = 0.0;
    averagePunctualityPerGeofence.forEach((geofence, punctuality) {
      final eventsForGeofence = geofenceEventsMap[geofence] ?? [];
      totalEvents += eventsForGeofence.length;
      totalPunctuality += punctuality * eventsForGeofence.length;
    });
    return totalEvents > 0 ? totalPunctuality / totalEvents : 0.0;
  }

  Widget _buildPunctualityGraph() {
    final sortedEntries = averagePunctualityPerGeofence.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return SfCartesianChart(
      title: const ChartTitle(
          text: 'Punctuality Graph',
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 10,
        title: AxisTitle(text: 'Percentage on Time'),
      ),
      series: <CartesianSeries<dynamic, dynamic>>[
        ColumnSeries<MapEntry<String, double>, String>(
          dataSource: sortedEntries,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildTimeSpentChart() {
    List<_ChartData> data = timeSpentPerGeofence.entries
        .map((entry) => _ChartData(
            entry.key,
            entry.value.toDouble(),
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0))) // Use math.Random here
        .toList();

    return SfCircularChart(
      title: const ChartTitle(),
      legend: const Legend(
          isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      series: <CircularSeries>[
        PieSeries<_ChartData, String>(
          dataSource: data,
          pointColorMapper: (_ChartData data, _) => data.color,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y,
          dataLabelMapper: (_ChartData data, _) =>
              '${data.x} \n${data.y.toInt()} mins', // Show geofence name and minutes
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildTimeSpentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, bottom: 8.0),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Time Spent",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 160,
            child: timeSpentPerGeofence.isEmpty
                ? const Center(child: Text("No geofences found."))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: timeSpentPerGeofence.length,
                    itemBuilder: (context, index) {
                      final sortedEntries = timeSpentPerGeofence.entries
                          .toList()
                        ..sort((a, b) => b.value.compareTo(a.value));
                      final geofenceName = sortedEntries[index].key;
                      final timeSpent = sortedEntries[index].value;
                      final punctuality =
                          averagePunctualityPerGeofence[geofenceName] ?? 0.0;
                      final color = tileColors[index % tileColors.length];
                      final geofenceEvents =
                          geofenceEventsMap[geofenceName] ?? [];

                      return _buildLocationTimeCard(context, geofenceName,
                          timeSpent, punctuality, color, geofenceEvents);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Color> tileColors = [
    Colors.blue[100]!,
    Colors.teal[100]!,
    Colors.green[100]!,
    Colors.amber[100]!,
  ];

  Widget _buildLocationTimeCard(
    BuildContext context,
    String geofenceName,
    int timeSpent,
    double punctuality,
    Color tileColor,
    List<Event> geofenceEvents,
  ) {
    return InkWell(
      onTap: () async {
        try {
          final events = await GeofencesDatabase.getEventsForGeofence(
              geofences.firstWhere((geo) => geo.name == geofenceName).id);
          if (events.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsPage(event: events.first),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No events found for this geofence')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading events: $e')),
          );
        }
      },
      child: Card(
        color: tileColor,
        elevation: 2.0,
        margin: const EdgeInsets.all(8.0),
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                geofenceName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('${timeSpent.toString()} minutes'),
              const SizedBox(height: 4),
              Text(
                'Punctuality: ${punctuality.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: punctuality >= 80.0
                      ? Colors.green[300]
                      : punctuality >= 50.0
                          ? Colors.orange[300]
                          : Colors.red[300],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Geofences>> _fetchGeofences() async {
    return await GeofencesDatabase.readAllGeofences();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Geofences>>(
      future: _fetchGeofences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildTimeSpentSection(),
                _buildTimeSpentChart(),
                _buildAveragePunctualityChart(),
                _buildPunctualityGraph(),
              ],
            ),
          );
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }
}
