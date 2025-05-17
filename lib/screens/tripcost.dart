import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_application_1/screens/bookingpage.dart';
import 'package:flutter_application_1/screens/paymentpage.dart';

class TripCostPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const TripCostPage({super.key, required this.bookingData});

  Future<List<dynamic>> loadDataset() async {
    try {
      final String response = await rootBundle
          .loadString('assets/filedatacost/filtered_travel_dataset.json');
      return jsonDecode(response);
    } catch (e) {
      throw Exception('Error loading dataset: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: loadDataset(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Trip Summary'),
              backgroundColor: Color.fromARGB(255, 100, 65, 45),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final dataset = snapshot.data ?? [];
          final filteredData = dataset.where((data) {
            return data['Destination'] == bookingData['destination'] &&
                data['Accommodation type'] == bookingData['accommodation'];
          }).toList();

          if (filteredData.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Trip Summary'),
                backgroundColor: Color.fromARGB(255, 100, 65, 45),
              ),
              body: const Center(
                child: Text('No matching data found for the given inputs.'),
              ),
            );
          }

          // Extract costs and calculate total cost
          final accommodationCost =
              filteredData[0]['Accommodation cost'] * bookingData['duration'];
          final transportationCost =
              filteredData[0]['Transportation cost'] * bookingData['guests'];
          final totalCost = accommodationCost + transportationCost;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Trip Summary'),
              backgroundColor: Color.fromARGB(255, 100, 65, 45),
            ),
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://wallsbyme.com/cdn/shop/products/themed_48983851_print1x1_copiar-01-sw_grande.jpg?v=1611155040', // Background image URL
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 65, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildDetailRow('Name', bookingData['name']),
                    buildDetailRow('Destination', bookingData['destination']),
                    buildDetailRow(
                        'Duration (days)', bookingData['duration'].toString()),
                    buildDetailRow('Guests', bookingData['guests'].toString()),
                    buildDetailRow(
                        'Accommodation', bookingData['accommodation']),
                    if (bookingData['accommodation'] == 'Hotel' ||
                        bookingData['accommodation'] == 'Resort')
                      buildDetailRow(
                          'View Type', bookingData['viewType'] ?? 'N/A'),
                    buildDetailRow(
                        'Travel Class', bookingData['travelClass']),
                    buildDetailRow('Return Travel Class',
                        bookingData['returnTravelClass']),
                    const SizedBox(height: 20),
                    const Text(
                      'Cost Breakdown',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 100, 65, 45),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildDetailRow('Accommodation Cost',
                        '\$${accommodationCost.toStringAsFixed(2)}'),
                    buildDetailRow('Transportation Cost',
                        '\$${transportationCost.toStringAsFixed(2)}'),
                    const Divider(thickness: 1),
                    buildDetailRow(
                        'Total Cost', '\$${totalCost.toStringAsFixed(2)}',
                        isBold: true, color: Colors.green),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  totalCost: totalCost,
                                  bookingData: bookingData,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildDetailRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
