import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class Mlf extends StatelessWidget {
  const Mlf({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Travel Destination Prediction',
      home: TravelForm(),
    );
  }
}

class TravelForm extends StatefulWidget {
  const TravelForm({super.key});

  @override
  State<TravelForm> createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final TextEditingController accommodationCostController =
      TextEditingController();
  final TextEditingController transportationCostController =
      TextEditingController();

  String? selectedCityType;
  String? selectedTourismType;
  String? selectedContinent;
  String? selectedWeather;

  String predictionResult = '';

  final Map<String, int> cityTypeMap = {
    'Urban': 1,
    'Historical': 2,
    'Coastal': 3,
    'Mountainous': 4,
  };

  final Map<String, int> tourismTypeMap = {
    'Cultural': 1,
    'Adventure': 2,
    'Leisure': 3,
    'Wildlife': 4,
  };

  final Map<String, int> continentMap = {
    'Asia': 1,
    'Europe': 2,
    'Africa': 3,
    'North America': 4,
    'South America': 5,
  };

  final Map<String, int> weatherMap = {
    'Tropical': 1,
    'Arid': 2,
    'Temperate': 3,
    'Cold': 4,
  };

  Future<void> getPrediction() async {
    if (selectedCityType == null ||
        selectedTourismType == null ||
        selectedContinent == null ||
        selectedWeather == null ||
        accommodationCostController.text.isEmpty ||
        transportationCostController.text.isEmpty) {
      setState(() {
        predictionResult = 'Please fill out all fields!';
      });
      return;
    }

    try {
      final accommodationCost =
          double.tryParse(accommodationCostController.text);
      final transportationCost =
          double.tryParse(transportationCostController.text);

      if (accommodationCost == null || transportationCost == null) {
        setState(() {
          predictionResult = 'Please enter valid numeric values!';
        });
        return;
      }

      final cityType = cityTypeMap[selectedCityType!];
      final tourismType = tourismTypeMap[selectedTourismType!];
      final continent = continentMap[selectedContinent!];
      final weather = weatherMap[selectedWeather!];

      final requestBody = {
        'City Type': cityType,
        'Tourism Type': tourismType,
        'Continent': continent,
        'Weather': weather,
        'Accommodation Cost': accommodationCost,
        'Transportation Cost': transportationCost,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          predictionResult =
              'Predicted City: ${responseData['Predicted City']}';
        });
      } else {
        setState(() {
          predictionResult = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        predictionResult = 'Error: Unable to connect to the server';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE8CBA7), // Lightest brown
            Color(0xFFD7B59E), // Lighter brown
            Color(0xFF6A4E23), // Dark brown
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          title: const Text('Travel Destination Prediction'),
          centerTitle: true,
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove AppBar shadow
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // City Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedCityType,
                  decoration: const InputDecoration(
                    labelText: 'City Type',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: cityTypeMap.keys
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCityType = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Tourism Type Dropdown
                DropdownButtonFormField<String>(
                  value: selectedTourismType,
                  decoration: const InputDecoration(
                    labelText: 'Tourism Type',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: tourismTypeMap.keys
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedTourismType = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Continent Dropdown
                DropdownButtonFormField<String>(
                  value: selectedContinent,
                  decoration: const InputDecoration(
                    labelText: 'Continent',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: continentMap.keys
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedContinent = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Weather Dropdown
                DropdownButtonFormField<String>(
                  value: selectedWeather,
                  decoration: const InputDecoration(
                    labelText: 'Weather',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: weatherMap.keys
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedWeather = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Accommodation Cost Input
                TextField(
                  controller: accommodationCostController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Enter Accommodation Cost',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // Transportation Cost Input
                TextField(
                  controller: transportationCostController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Enter Transportation Cost',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                // Prediction Button
                ElevatedButton(
                  onPressed: getPrediction,
                  child: const Text('Get Prediction'),
                ),

                const SizedBox(height: 20),

                // Prediction Result
                Text(
                  predictionResult,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}