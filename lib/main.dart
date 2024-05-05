import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:geo_chronicle/pages/starting_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //
  await GeofencesDatabase.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartingPage(),
    );
  }
}
