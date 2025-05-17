import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/design%20patterns/trip_builder.dart';
import 'package:flutter_application_1/screens/tripcost.dart'; // Trip cost page

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  void _handleTripBookingWithBuilder() {
    final builder = TripBuilder()
        .setName(nameController.text)
        .setEmail(emailController.text)
        .setId(idController.text)
        .setDestination(
            destinationController.text) // FIX: use destinationController
        .setGuests(int.tryParse(guestsController.text) ?? 1)
        .setStartDate(
            DateTime.tryParse(startDateController.text) ?? DateTime.now())
        .setDuration(int.tryParse(durationController.text) ?? 1);

    final trip = builder.build();

    print(trip.summary());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✔ " + trip.summary())),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TripCostPage(
          bookingData: {
            'destination': trip.destination,
            'guests': trip.guests,
            'duration': trip.duration,
          },
        ),
      ),
    );
  }

  final List<String> cityList = [
    "London",
    "Phuket",
    "Bali",
    "New York",
    "Tokyo",
    "Paris",
    "Sydney",
    "Rio de Janeiro",
    "Amsterdam",
    "Dubai",
    "Cancun",
    "Barcelona",
    "Honolulu",
    "Berlin",
    "Marrakech",
    "Edinburgh",
    "New York City",
    "Bangkok",
    "Vancouver",
    "Rome",
    "Seoul",
    "Cape Town",
    "Los Angeles",
    "Athens",
    "Auckland",
    "Australia",
    "Hawaii"
  ];

  String selectedDestination = '';
  final TextEditingController destinationController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController guestsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();

  List<String> destinations = [];
  List<String> filteredDestinations = [];
  int numberOfGuests = 0;
  List<Map<String, TextEditingController>> guestDetails = [];

  String selectedAccommodation = 'Hotel';
  String selectedTravelClass = 'Economy';
  String selectedReturnTravelClass = 'Economy';
  String? selectedViewType;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  Future<void> _loadDestinations() async {
    try {
      final String response = await rootBundle
          .loadString('assets/filedatacost/filtered_travel_dataset.json');
      final List<dynamic> data = jsonDecode(response);

      setState(() {
        destinations =
            data.map((item) => item['Destination'].toString()).toSet().toList();
        filteredDestinations = destinations;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading destinations: $e')),
      );
    }
  }

  void _filterDestinations(String query) {
    setState(() {
      filteredDestinations = destinations
          .where((destination) =>
              destination.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
    // Validate email format
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // Validate ID
    if (idController.text.length <= 14 ||
        int.tryParse(idController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID must be more than 14 digits')),
      );
      return;
    }

    // Validate destination
    if (!destinations.contains(destinationController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('The entered destination is not available')),
      );
      return;
    }

    final bookingData = {
      'name': nameController.text,
      'email': emailController.text,
      'id': idController.text,
      'destination': destinationController.text,
      'duration': int.tryParse(durationController.text) ?? 0,
      'guests': numberOfGuests,
      'guestDetails': guestDetails.map((guest) {
        return {
          'name': guest['name']!.text,
          'id': guest['id']!.text,
          'email': guest['email']!.text,
        };
      }).toList(),
      'accommodation': selectedAccommodation,
      'viewType': selectedViewType,
      'travelClass': selectedTravelClass,
      'returnTravelClass': selectedReturnTravelClass,
      'startDate': startDateController.text,
      'bookingTime': FieldValue.serverTimestamp(),
    };

    saveBookingData(bookingData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripCostPage(bookingData: bookingData),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> saveBookingData(Map<String, dynamic> bookingData) async {
    try {
      await FirebaseFirestore.instance.collection('trips').add(bookingData);
      print("Booking saved successfully!");
    } catch (e) {
      print("Error saving booking data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Form'),
        backgroundColor: const Color.fromARGB(255, 100, 65, 45),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://images.rawpixel.com/image_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvbHIvcm00MjItMDYzLWt6cGhnMjNrLmpwZw.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildInputField('Name', 'Enter your name', nameController),
                buildInputField(
                  'Email',
                  'Enter your email',
                  emailController,
                  isEmail: true,
                ),
                buildInputField(
                  'ID',
                  'Enter your ID (more than 14 digits)',
                  idController,
                  isNumber: true,
                ),
                buildAutocompleteField(),
                buildInputField(
                  'Duration (Days)',
                  'Enter number of days',
                  durationController,
                  isNumber: true,
                ),
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Guest Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...guestDetails.map((guest) {
                    return Column(
                      children: [
                        buildInputField(
                          'Guest Name',
                          'Enter guest name',
                          guest['name']!,
                        ),
                        buildInputField(
                          'Guest ID',
                          'Enter guest ID',
                          guest['id']!,
                          isNumber: true,
                        ),
                        buildInputField(
                          'Guest Email',
                          'Enter guest email',
                          guest['email']!,
                          isEmail: true,
                        ),
                        const Divider(),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickStartDate,
                  child: AbsorbPointer(
                    child: buildInputField(
                      'Start Date',
                      'Select your start date',
                      startDateController,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 100, 65, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _handleTripBookingWithBuilder,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Book with Builder Pattern',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
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
    bool isEmail = false,
    Function(String)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        keyboardType: isNumber
            ? TextInputType.number
            : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChange,
      ),
    );
  }

  Widget buildAutocompleteField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Destination',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return filteredDestinations.where((destination) => destination
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()));
            },
            onSelected: (String selection) {
              destinationController.text = selection;
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your destination',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
