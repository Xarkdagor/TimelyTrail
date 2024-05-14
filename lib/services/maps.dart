import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:math' as math;

import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart'; // Import your database file
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Maps extends StatefulWidget {
  final Function(String)? updateCoordinates;

  const Maps({super.key, this.updateCoordinates});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchGeofencesFromDatabase();

    _loadTimerState();
    if (widget.updateCoordinates != null) {
      _updateCoordinatesCallback = widget.updateCoordinates!;
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _loadTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    final geofenceId = prefs.getInt('activeGeofenceId');
    final entryTimestampString = prefs.getString('entryTimestamp');
    final elapsedTimeSeconds = prefs.getInt('elapsedTime') ?? 0;

    if (geofenceId != null && entryTimestampString != null) {
      // Get the Geofence from your database
      final geofence = await GeofencesDatabase.readGeofenceById(geofenceId);

      if (geofence != null) {
        // Restore state
        geofence.entryTimestamp = DateTime.parse(entryTimestampString);
        _elapsedTime = elapsedTimeSeconds;
        _startTimer();
      }
    }
  }

  Timer? _timer; // The timer for time tracking
  bool _isTimerActive = false;
  int _elapsedTime = 0;
  final Queue<Location> _locationHistory = Queue(); // Store last 5 locations
  GoogleMapController? _mapController;
  Location? _currentLocation;
  StreamSubscription<Location>? _locationSubscription;
  final Set<Marker> _markers = {};
  List<Geofences> _geofences = [];
  bool _showGeofences = false;
  late Function(String) _updateCoordinatesCallback;

  void _zoomToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
            LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
            18.0),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    // Check permissions
    var locationPermission = await Permission.location.request();
    if (locationPermission != PermissionStatus.granted) {
      // Handle permission denied scenario (display an error message, etc.)
      return;
    }

    int readingsCount = 0;
    double currentThreshold = 60.0; // Start with initialThreshold

    _locationSubscription =
        FlLocation.getLocationStream().listen((locationData) {
      log('Location Accuracy: ${locationData.accuracy}');

      if (locationData.accuracy <= currentThreshold) {
        setState(() {
          _currentLocation = locationData;
          _updateMarkers();
          if (_currentLocation != null) {
            // Add this check
            _checkGeoFence(_currentLocation);
          }
        });

        readingsCount++;

        // Dynamically adjust the threshold
        if (readingsCount >= 5 && locationData.accuracy <= 30.0) {
          currentThreshold = 30.0; // Switch to targetThreshold
        }
        _updateCoordinatesCallback(
            "Lat: ${locationData.latitude}, Long: ${locationData.longitude}");
      }
    });
  }

  void _updateMarkers() {
    if (_currentLocation != null) {
      _locationHistory.add(_currentLocation!);
      if (_locationHistory.length >= 5) {
        _locationHistory.removeFirst(); // Keep only the recent ones
      }

      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    }
  }

  // Import for date formatting
// for important function
  void _checkGeoFence(Location? locationData) {
    if (locationData == null) return;

    // Find the closest geofence (adjust the logic if needed)
    double? closestDistance;
    Geofences? closestGeofence;

    for (var geofence in _geofences) {
      final distance = haversineDistance(
          LatLng(locationData.latitude, locationData.longitude),
          LatLng(geofence.latitude, geofence.longitude));
      if (closestDistance == null || distance < closestDistance) {
        closestDistance = distance;
        closestGeofence = geofence;
      }
    }

    // State Tracking
    int? currentGeofenceId; // To track which geofence we're in
    // Timer Management
    Timer? activeTimer; // To store the active timer
    // Perform actions based on the closest geofence
    if (closestDistance != null &&
        closestGeofence != null && // Add this null check
        closestDistance < (closestGeofence.radius ?? 0.0)) {
      // User is inside a geofence.
      if (currentGeofenceId != closestGeofence.id ||
          closestGeofence.entryTimestamp == null) {
        // New geofence or no entryTimestamp

        closestGeofence.entryTimestamp = DateTime.now(); // Record entry time

        // Start the timer (if not already running)
        activeTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
          closestGeofence!.totalTimeSpentInSeconds++;
        });

        // Debugging: Print statement (conditionally)
        if (closestGeofence.entryTimestamp != null) {
          String formattedEntryTime = DateFormat('dd-MM-yyyy HH:mm:ss')
              .format(closestGeofence.entryTimestamp!);
          log('Entered Geofence "${closestGeofence.name}" at $formattedEntryTime');
        }

        // Display notification (optional)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("You've entered the ${closestGeofence.name}")));
      }
      currentGeofenceId = closestGeofence.id;
      if (!_isTimerActive) {
        _startTimer();
      }
      closestGeofence.sessionTimeSpentInSeconds++;
      _saveTimerState(closestGeofence); // Update session time
    } else {
      // User was inside and has exited or is outside the range
      try {
        activeTimer!.cancel();
        activeTimer = null; // Reset
      } catch (error) {
        // Handle the potential error if activeTimer is null
        // log("Error during timer cancellation: $error");
      } // Directly cancel the timer

      closestGeofence!.exitTimestamp = DateTime.now();

      // Debugging: Print statement (conditionally)
      if (closestGeofence.exitTimestamp != null) {
        String formattedExitTime = DateFormat('dd-MM-yyyy HH:mm:ss')
            .format(closestGeofence.exitTimestamp!);
        log('Exited Geofence "${closestGeofence.name}" at $formattedExitTime');
      }

      // Notification (optional)
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You've exited the ${closestGeofence.name}")));

      closestGeofence.totalTimeSpentInSeconds += closestGeofence
          .sessionTimeSpentInSeconds; // Add session time to total
      closestGeofence.sessionTimeSpentInSeconds = 0; // Reset session time

      GeofencesDatabase.updateGeofence(closestGeofence); // Update in database

      currentGeofenceId = null;
      if (_isTimerActive) {
        _stopTimer();
      }
      _clearTimerState();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime++;
      });
    });
    setState(() {
      _isTimerActive = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null; // Reset
    setState(() {
      _elapsedTime = 0;
      _isTimerActive = false;
    });
  }

  void _saveTimerState(Geofences geofence) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('activeGeofenceId', geofence.id);
    prefs.setString(
        'entryTimestamp', geofence.entryTimestamp!.toIso8601String());
    prefs.setInt('elapsedTime', _elapsedTime);
  }

  void _clearTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('activeGeofenceId');
    prefs.remove('entryTimestamp');
    prefs.remove('elapsedTime');
  }

  double haversineDistance(LatLng player1, LatLng player2) {
    double lat1 = player1.latitude;
    double lon1 = player1.longitude;
    double lat2 = player2.latitude;
    double lon2 = player2.longitude;

    var R = 6371e3; // metres
    var phi1 = (lat1 * math.pi) / 180; // Corrected lowercase "pi"
    var phi2 = (lat2 * math.pi) / 180;
    var deltaPhi = ((lat2 - lat1) * math.pi) / 180;
    var deltaLambda = ((lon2 - lon1) * math.pi) / 180;

    var a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);

    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c;
  }

  void _fetchGeofencesFromDatabase() async {
    List<Geofences> fetchedData = await GeofencesDatabase.readAllGeofences();
    setState(() {
      _geofences = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      _currentLocation!.latitude,
                      _currentLocation!.longitude,
                    ),
                    zoom: 18, // Adjust the initial zoom level as needed
                  ),
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  circles: _showGeofences ? _createGeoFenceCircles() : {},
                ),
          Positioned(
            bottom: 30,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showGeofences = !_showGeofences;
                });
              },
              child: Icon(
                  _showGeofences ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 10,
            child: FloatingActionButton(
              onPressed: () => _zoomToCurrentLocation(), // Call a function
              child: const Icon(Icons.my_location),
            ),
          ),
          if (_isTimerActive)
            Positioned(
              top: 10,
              right: 10, // You can adjust positioning
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.white,
                child: Text("Time Spent: $_elapsedTime seconds"),
              ),
            ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _updateMarkers();
    _createGeoFenceCircles(); // Add the circle
  }

  Color _colorFromInt(int value) {
    return Color(value);
  }

  Set<Circle> _createGeoFenceCircles() {
    return _geofences
        .map((geofence) => Circle(
              circleId: CircleId(geofence.id.toString()),
              center: LatLng(geofence.latitude, geofence.longitude),
              radius: geofence.radius ?? 0.0,
              fillColor: _colorFromInt(geofence.color).withOpacity(0.4),
              strokeColor: _colorFromInt(geofence.color),
              strokeWidth: 7,
            ))
        .toSet();
  }
}
