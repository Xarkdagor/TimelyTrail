import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences.dart';
import 'package:geo_chronicle/database/geofences_database.dart';

class GeoFenceInputDialog extends StatefulWidget {
  const GeoFenceInputDialog({super.key});

  @override
  _GeoFenceInputDialogState createState() => _GeoFenceInputDialogState();
}

class _GeoFenceInputDialogState extends State<GeoFenceInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _radiusController = TextEditingController();

  bool _isLoading = false;

  Color _generateRandomColor() {
    return Color.fromARGB(
      255, // Alpha (full opacity)
      math.Random().nextInt(255),
      math.Random().nextInt(255),
      math.Random().nextInt(255),
    );
  }

  String? selectedCategory; // Store the selected category

  final List<String> _categories = [
    "Lecture Hall",
    "Department",
    "Food",
    // ... Add more categories
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.purple[50],
      title: const Text('Create Geofence',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NameTextFormField(
                  controller: _nameController,
                ),
                const SizedBox(height: 10),
                LatitudeTextFormField(controller: _latitudeController),
                const SizedBox(height: 10),
                LongitudeTextFormField(controller: _longitudeController),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  // Changed to String?
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: selectedCategory,
                  hint: const Text("Select Category (Optional)"),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                ),
                const SizedBox(height: 10),
                if (selectedCategory == null)
                  RadiusTextFormField(controller: _radiusController)
                else
                  const SizedBox.shrink(), // Hide if a category is selected
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _isLoading
              ? null
              : () async {
                  if (!_formKey.currentState!.validate()) {
                    return; // Early exit if validation fails
                  }

                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    double latitude = double.parse(_latitudeController.text);
                    double longitude = double.parse(_longitudeController.text);
                    double? radius;

                    if (selectedCategory == null) {
                      radius = double.parse(_radiusController.text);
                    }

                    var newGeoFence = Geofences(
                      name: _nameController.text,
                      latitude: latitude,
                      longitude: longitude,
                      radius:
                          radius, // Could be null if the category is selected
                      color: _generateRandomColor().value,
                      entryTimestamp: null,
                      exitTimestamp: null,
                      category: selectedCategory,
                    );

                    await GeofencesDatabase().createGeofence(newGeoFence);

                    _nameController.clear();
                    _latitudeController.clear();
                    _longitudeController.clear();
                    _radiusController.clear();
                    selectedCategory = null; // Reset category selection

                    Navigator.of(context).pop(); // Close the dialog
                  } catch (error) {
                    log('Error creating Geofence: $error');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error creating geofence')),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}

class NameTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const NameTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Name',
        prefixIcon: const Icon(Icons.label),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
    );
  }
}

class LatitudeTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const LatitudeTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
          decimal: true, signed: true), // Numeric keyboard
      decoration: InputDecoration(
        labelText: 'Latitude',
        prefixIcon: const Icon(Icons.map),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a latitude';
        }
        final double? parsedValue = double.tryParse(value);
        if (parsedValue == null || parsedValue < -90 || parsedValue > 90) {
          return 'Latitude must be between -90 and 90';
        }
        return null;
      },
    );
  }
}

class LongitudeTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const LongitudeTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: InputDecoration(
        labelText: 'Longitude',
        prefixIcon: const Icon(Icons.map_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a longitude';
        }
        final double? parsedValue = double.tryParse(value);
        if (parsedValue == null || parsedValue < -180 || parsedValue > 180) {
          return 'Longitude must be between -180 and 180';
        }
        return null;
      },
    );
  }
}

class RadiusTextFormField extends StatelessWidget {
  final TextEditingController controller;

  const RadiusTextFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Radius (meters)',
        prefixIcon: const Icon(Icons.circle),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a radius';
        }
        final double? parsedValue = double.tryParse(value);
        if (parsedValue == null || parsedValue <= 0) {
          return 'Radius must be greater than 0';
        }
        return null;
      },
    );
  }
}
