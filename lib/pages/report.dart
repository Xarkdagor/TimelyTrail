import 'package:flutter/material.dart';
import 'package:geo_chronicle/database/geofences_database.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserReport extends StatefulWidget {
  const UserReport({super.key});

  @override
  State<UserReport> createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  DateTimeRange? _selectedDateRange;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _generateAndSaveReport() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get the selected date range (if any)
      DateTime? startDate = _selectedDateRange?.start;
      DateTime? endDate = _selectedDateRange?.end;

      // Generate the report and upload to Google Sheets
      await GeofencesDatabase.generateDetailedReportAndUploadToGoogleSheets(
        startDate: startDate,
        endDate: endDate,
      );

      // Show a success message with a link to the spreadsheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report uploaded to Google Sheets!'),
          action: SnackBarAction(
            label: 'View Report',
            onPressed: () async {
              const url =
                  'https://docs.google.com/spreadsheets/d/1K2gOhn-pEANJBUW__KjFPWbw9if1swzTugYhjl_frQM/edit#gid=0'; // Replace with your sheet ID
              if (await canLaunchUrlString(url)) {
                await launchUrlString(url);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error generating or sharing report: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedRange != null) {
      setState(() {
        _selectedDateRange = pickedRange;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_selectedDateRange != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Selected Date Range: ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.start)} - ${DateFormat('yyyy-MM-dd').format(_selectedDateRange!.end)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () => _selectDateRange(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Select Date Range'),
                  ),
                  const SizedBox(height: 20),
                  if (_isLoading) const CircularProgressIndicator(),
                  if (!_isLoading)
                    ElevatedButton(
                      onPressed: _generateAndSaveReport,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Generate Report"),
                    ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
