import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/paymentpage.dart';

class TripCostForPackage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const TripCostForPackage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final packageCost = bookingData['price'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Summary'),
        backgroundColor: Color.fromARGB(255, 100, 65, 45),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://wallsbyme.com/cdn/shop/products/themed_48983851_print1x1_copiar-01-sw_grande.jpg?v=1611155040'), // Background image URL
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
              buildDetailRow('Guests', bookingData['guests'].toString()),
              buildDetailRow('Start Date', bookingData['startDate']),
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
              buildDetailRow(
                  'Package Cost', '\$${packageCost.toStringAsFixed(2)}'),
              const Divider(thickness: 1),
              buildDetailRow('Total Cost', '\$${packageCost.toStringAsFixed(2)}',
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
                            totalCost: packageCost,
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
                      Navigator.pop(context);
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
