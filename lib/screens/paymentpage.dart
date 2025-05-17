import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/design%20patterns/payment_strategy.dart';

import 'package:flutter_application_1/screens/pymentconfirmed.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';

class PaymentPage extends StatefulWidget {
  final double totalCost;
  final Map<String, dynamic> bookingData;

  const PaymentPage(
      {super.key, required this.totalCost, required this.bookingData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedMethod = 'Credit Card';
  late PaymentStrategy _paymentStrategy;

  final List<String> paymentMethods = ['Credit Card', 'Visa', 'PayPal'];

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool isLoading = false;

  final TextEditingController paypalEmailController = TextEditingController();
  final TextEditingController paypalPasswordController =
      TextEditingController();

  Future<void> savePaymentDetails() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> paymentData;
    if (_selectedMethod == 'PayPal') {
      paymentData = {
        'paypalEmail': paypalEmailController.text,
        'paypalPassword': paypalPasswordController
            .text, // (You may want to hash or not store this)
        'method': 'PayPal',
        'totalCost': widget.totalCost,
        'paymentDate': Timestamp.now(),
        'paymentStatus': true,
      };
    } else {
      paymentData = {
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
        'method': _selectedMethod,
        'totalCost': widget.totalCost,
        'paymentDate': Timestamp.now(),
        'paymentStatus': true,
      };
    }

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
          .add(paymentData);

      await saveToConfirmedPayments(docRef.id, paymentData);
      await saveTripDetails(docRef.id, paymentData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentConfirmedPage(username: 'name'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process payment: $error')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveToConfirmedPayments(
      String paymentId, Map<String, dynamic> paymentData) async {
    try {
      await FirebaseFirestore.instance
          .collection('confirmed_payments')
          .doc(paymentId)
          .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        ...paymentData,
      });
    } catch (error) {
      print("Error saving confirmed payment: $error");
    }
  }

  Future<void> saveTripDetails(
      String paymentId, Map<String, dynamic> paymentData) async {
    final tripData = {
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'name': widget.bookingData['name'],
      'email': widget.bookingData['email'],
      'id': widget.bookingData['id'],
      'destination': widget.bookingData['destination'],
      'duration': widget.bookingData['duration'],
      'guests': widget.bookingData['guests'],
      'guestDetails': widget.bookingData['guestDetails'],
      'accommodation': widget.bookingData['accommodation'],
      'viewType': widget.bookingData['viewType'],
      'travelClass': widget.bookingData['travelClass'],
      'returnTravelClass': widget.bookingData['returnTravelClass'],
      'bookingTime': Timestamp.now(),
      'paymentStatus': true,
      'paymentId': paymentId,
    };

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tripdetails')
          .add(tripData);

      await saveToConfirmedTrips(docRef.id, tripData);
    } catch (error) {
      print("Error saving trip details: $error");
    }
  }

  Future<void> saveToConfirmedTrips(
      String tripId, Map<String, dynamic> tripData) async {
    try {
      await FirebaseFirestore.instance
          .collection('confirmed_trips')
          .doc(tripId)
          .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        ...tripData,
      });
    } catch (error) {
      print("Error saving confirmed trip: $error");
    }
  }

  void userTappedPay() {
    if (_selectedMethod == 'PayPal') {
      // Validate PayPal fields
      if (paypalEmailController.text.isEmpty ||
          paypalPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter your PayPal email and password.')),
        );
        return;
      }
      // Show confirmation dialog for PayPal
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Payment"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text("PayPal Email: ${paypalEmailController.text}"),
                Text("Total Amount: \$${widget.totalCost.toStringAsFixed(2)}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                savePaymentDetails(); // Will handle PayPal logic inside
              },
              child: const Text("Confirm"),
            )
          ],
        ),
      );
    } else {
      // Card payment validation
      if (formKey.currentState!.validate()) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirm Payment"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("Card Number: $cardNumber"),
                  Text("Expiry Date: $expiryDate"),
                  Text("Card Holder Name: $cardHolderName"),
                  Text("CVV: $cvvCode"),
                  Text(
                      "Total Amount: \$${widget.totalCost.toStringAsFixed(2)}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  savePaymentDetails();
                },
                child: const Text("Confirm"),
              )
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Checkout"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8CBA7),
              Color(0xFFD7B59E),
              Color(0xFF6A4E23),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Move "Select Payment Method" section to the top
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Payment Method",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedMethod,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                          items: paymentMethods.map((method) {
                            IconData icon;
                            switch (method) {
                              case 'Credit Card':
                                icon = Icons.credit_card;
                                break;
                              case 'Visa':
                                icon = Icons.payment;
                                break;
                              case 'PayPal':
                                icon = Icons.account_balance_wallet;
                                break;
                              default:
                                icon = Icons.payment;
                            }
                            return DropdownMenuItem(
                              value: method,
                              child: Row(
                                children: [
                                  Icon(icon, color: Colors.brown),
                                  const SizedBox(width: 8),
                                  Text(method),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedMethod = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Only show Credit Card widget if Credit Card or Visa is selected
                if (_selectedMethod == 'Credit Card' ||
                    _selectedMethod == 'Visa') ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CreditCardWidget(
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        showBackView: isCvvFocused,
                        chipColor: Colors.deepPurpleAccent,
                        onCreditCardWidgetChange: (p0) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CreditCardForm(
                        formKey: formKey,
                        cardNumber: cardNumber,
                        expiryDate: expiryDate,
                        cardHolderName: cardHolderName,
                        cvvCode: cvvCode,
                        themeColor: Colors.deepPurpleAccent,
                        onCreditCardModelChange: (model) {
                          setState(() {
                            cardNumber = model.cardNumber;
                            expiryDate = model.expiryDate;
                            cardHolderName = model.cardHolderName;
                            cvvCode = model.cvvCode;
                          });
                        },
                      ),
                    ),
                  ),
                ],
                // Only show PayPal logo and fields if PayPal is selected
                if (_selectedMethod == 'PayPal') ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          // Replace PayPal image with a Flutter logo as an example
                          FlutterLogo(size: 48),
                          const SizedBox(height: 18),
                          TextField(
                            controller: paypalEmailController,
                            decoration: const InputDecoration(
                              labelText: 'PayPal Email',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: paypalPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'PayPal Password',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Card(
                  color: Colors.white.withOpacity(0.9),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Amount:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                        Text(
                          "\$${widget.totalCost.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: userTappedPay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                    ),
                    icon: const Icon(Icons.lock, color: Colors.white),
                    label: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            "Pay Now",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
