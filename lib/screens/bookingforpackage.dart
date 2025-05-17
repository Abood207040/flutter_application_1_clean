import 'package:flutter_application_1/design%20patterns/booking_factory.dart';


import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/ripcostforpakage.dart';

class BookingScreenForPackage extends StatefulWidget {
  final String packageName;
  final double packageCost;

  const BookingScreenForPackage({
    super.key,
    required this.packageName,
    required this.packageCost,
  });

  @override
  State<BookingScreenForPackage> createState() =>
      _BookingScreenForPackageState();
}

class _BookingScreenForPackageState extends State<BookingScreenForPackage> {
  void _handleBookingWithFactory() {
    List<String> selectedServices = [];
      bool includeBreakfast = false;
  bool includeTransport = false;
    if (includeBreakfast) selectedServices.add("Breakfast");
    if (includeTransport) selectedServices.add("Transport");

    Booking booking = BookingFactory.create(
      "package",
      widget.packageName,
      selectedServices,
    );

    booking.confirm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✔ ' + booking.getSummary())),
    );
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  List<Map<String, TextEditingController>> guestDetails = [];
  int numberOfGuests = 0;

  void _updateGuestDetails() {
    guestDetails = List.generate(
      numberOfGuests,
      (index) => {
        'name': TextEditingController(),
        'id': TextEditingController(),
        'email': TextEditingController(),
      },
    );
  }

  void _submitBooking() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        idController.text.isEmpty ||
        startDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    if (idController.text.length < 14) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID must be at least 14 digits')),
      );
      return;
    }

    final bookingData = {
      'name': nameController.text,
      'email': emailController.text,
      'id': idController.text,
      'destination': widget.packageName,
      'duration': 1,
      'guests': numberOfGuests,
      'startDate': startDateController.text,
      'price': widget.packageCost,
      'guestDetails': guestDetails.map((guest) {
        return {
          'name': guest['name']!.text,
          'id': guest['id']!.text,
          'email': guest['email']!.text,
        };
      }).toList(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripCostForPackage(bookingData: bookingData),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
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
        backgroundColor: Colors.transparent, // Transparent background
        appBar: AppBar(
          title: const Text('Booking Details'),
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove shadow
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildInputField('Name', 'Enter your name', nameController),
              buildInputField('Email', 'Enter your email', emailController),
              buildInputField(
                  'ID', 'Enter your ID (at least 14 digits)', idController),
              buildReadOnlyField('Destination', widget.packageName),
              buildReadOnlyField(
                  'Price', '\$${widget.packageCost.toStringAsFixed(2)}'),
              buildInputField(
                'Number of Guests',
                'Enter number of guests',
                guestsController,
                isNumber: true,
                onChange: (value) {
                  setState(() {
                    numberOfGuests = int.tryParse(value) ?? 0;
                    _updateGuestDetails();
                  });
                },
              ),
              if (guestDetails.isNotEmpty) ...[
                const Text(
                  'Guest Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ...guestDetails.map((guest) {
                  return Column(
                    children: [
                      buildInputField(
                          'Guest Name', 'Enter guest name', guest['name']!),
                      buildInputField(
                          'Guest ID', 'Enter guest ID', guest['id']!,
                          isNumber: true),
                      buildInputField(
                          'Guest Email', 'Enter guest email', guest['email']!),
                      const Divider(),
                    ],
                  );
                }),
              ],
              GestureDetector(
                onTap: _pickStartDate,
                child: AbsorbPointer(
                  child: buildInputField('Start Date', 'Select your start date',
                      startDateController),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor:
                        const Color(0xFF6A4E23), // Matching the gradient
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Submit Booking',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    String label,
    String placeholder,
    TextEditingController controller, {
    bool isNumber = false,
    Function(String)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: onChange,
      ),
    );
  }

  Widget buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: value),
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
