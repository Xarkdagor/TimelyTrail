import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/location_time.dart';
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
  Map<String, double> punctualityPercentagePerGeofence = {};

  @override
  void initState() {
    super.initState();
    _loadGeofencesAndTimeSpent();
  }

  Future<void> _loadGeofencesAndTimeSpent() async {
    geofences = await GeofencesDatabase.readAllGeofences();

    // Load events for punctuality calculations
    final isar = GeofencesDatabase.isar;
    final eventsFromDatabase = await isar.eventModels.where().findAll();
    final events = eventsFromDatabase
        .map((eventModel) => Event.fromModel(eventModel))
        .toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (var geofence in geofences) {
      // Calculate time spent
      final geofenceEvents =
          events.where((event) => event.geofenceId == geofence.id).toList();
      int totalSeconds = 0;
      for (var event in geofenceEvents) {
        totalSeconds += event.endTime.difference(event.startTime).inSeconds;
      }
      timeSpentPerGeofence[geofence.name] = totalSeconds ~/ 60;

      // Calculate punctuality percentage
      final onTimeEvents = geofenceEvents
          .where((event) => event.startTime.isAfter(today))
          .toList();
      double punctualityPercentage = onTimeEvents.isNotEmpty
          ? (onTimeEvents.length / geofenceEvents.length) * 100
          : 0;
      punctualityPercentagePerGeofence[geofence.name] = punctualityPercentage;
    }

    setState(() {}); // Update the UI after loading data
  }

  List<_ChartData> getTimeSpentChartData() {
    return timeSpentPerGeofence.entries.map((entry) {
      return _ChartData(entry.key, entry.value.toDouble());
    }).toList();
  }

  List<_ChartData> getPunctualityChartData() {
    return punctualityPercentagePerGeofence.entries.map((entry) {
      return _ChartData(entry.key, entry.value);
    }).toList();
  }

  Widget _buildTimeSpentChart() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationTime(
              geofences: geofences,
              punctualityPercentagePerGeofence:
                  punctualityPercentagePerGeofence),
        ),
      ),
      child: SfCircularChart(
        title: const ChartTitle(text: 'Time Spent Chart'),
        series: <CircularSeries>[
          PieSeries<_ChartData, String>(
            dataSource: getTimeSpentChartData(),
            xValueMapper: (_ChartData data, _) => data.x,
            yValueMapper: (_ChartData data, _) => data.y,
            dataLabelMapper: (_ChartData data, _) =>
                '${data.x}: ${data.y.toString()} mins',
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildPunctualityGraph() {
    final sortedEntries = punctualityPercentagePerGeofence.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return SfCartesianChart(
      title: const ChartTitle(text: 'Punctuality Chart'),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        maximum: 100,
        interval: 10,
        title: AxisTitle(text: 'Percentage on Time'),
      ),
      series: <CartesianSeries<dynamic, dynamic>>[
        // Changed to <CartesianSeries<dynamic, dynamic>>
        ColumnSeries<MapEntry<String, double>, String>(
          // Adjusted series type
          dataSource: sortedEntries,
          xValueMapper: (entry, _) => entry.key,
          yValueMapper: (entry, _) => entry.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  Widget _buildTimeSpentSection() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Time Spent:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeSpentPerGeofence.length,
            itemBuilder: (context, index) {
              String geofenceName = timeSpentPerGeofence.keys.elementAt(index);
              int timeSpent = timeSpentPerGeofence[geofenceName]!;
              return ListTile(
                title: Text(geofenceName),
                trailing: Text('${timeSpent.toString()} minutes'),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtherDetailsSection() {
    return const Text("Other Details Section"); // Placeholder
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
                _buildTimeSpentChart(),
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
