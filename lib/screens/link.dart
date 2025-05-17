import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class LoadDestinations extends StatefulWidget {
  const LoadDestinations({super.key});

  @override
  State<LoadDestinations> createState() => _LoadDestinationsState();
}

class _LoadDestinationsState extends State<LoadDestinations> {
  List<String> destinations = [];

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  /// Load destinations from the JSON file.
  Future<void> _loadDestinations() async {
    try {
      print('Loading destinations from JSON...');
      final String response = await rootBundle
          .loadString('assets/filedatacost/filtered_travel_dataset.json');
      final List<dynamic> data = jsonDecode(response);

      setState(() {
        destinations = data
            .map((item) => item['Destination'].toString())
            .toSet()
            .toList(); // Remove duplicates
      });

      print('Destinations loaded successfully. Total: ${destinations.length}');
    } catch (e) {
      print('Error loading destinations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Load Destinations'),
        backgroundColor: Color.fromARGB(255, 100, 65, 45),
      ),
      body: destinations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Text(
                'Destinations loaded: ${destinations.length}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
