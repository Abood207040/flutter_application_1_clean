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

  const PaymentPage({
    super.key,
    required this.totalCost,
    required this.bookingData,
  });

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
  final TextEditingController paypalPasswordController = TextEditingController();

  void applyPaymentStrategy() {
    switch (_selectedMethod) {
      case 'Credit Card':
      case 'Visa':
        _paymentStrategy = CreditCardPayment(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
        );
        break;
      case 'PayPal':
        _paymentStrategy = PayPalPayment(
          email: paypalEmailController.text,
          password: paypalPasswordController.text,
        );
        break;
      default:
        _paymentStrategy = CreditCardPayment(
          cardNumber: '',
          expiryDate: '',
          cardHolderName: '',
          cvvCode: '',
        );
    }
  }

  Future<void> savePaymentDetails() async {
    setState(() => isLoading = true);
    applyPaymentStrategy();

    final paymentData = _paymentStrategy.getPaymentData(widget.totalCost);

    try {
      final docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('payments')
          .add(paymentData);

      await FirebaseFirestore.instance
          .collection('confirmed_payments')
          .doc(docRef.id)
          .set({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        ...paymentData,
      });

      final tripData = {
        'userId': FirebaseAuth.instance.currentUser!.uid,
        ...widget.bookingData,
        'paymentId': docRef.id,
        'paymentStatus': true,
        'bookingTime': Timestamp.now(),
      };

      final tripDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('tripdetails')
          .add(tripData);

      await FirebaseFirestore.instance
          .collection('confirmed_trips')
          .doc(tripDoc.id)
          .set({'userId': FirebaseAuth.instance.currentUser!.uid, ...tripData});

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PaymentConfirmedPage(username: 'name'),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void userTappedPay() {
    if (_selectedMethod == 'PayPal') {
      if (paypalEmailController.text.isEmpty || paypalPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in PayPal details')),
        );
        return;
      }
    } else {
      if (!formKey.currentState!.validate()) return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Payment"),
        content: Text("Are you sure you want to pay \$${widget.totalCost.toStringAsFixed(2)}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              savePaymentDetails();
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedMethod,
              items: paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (_selectedMethod == 'Credit Card' || _selectedMethod == 'Visa') ...[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (_) {},
              ),
              CreditCardForm(
                formKey: formKey,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                themeColor: Theme.of(context).primaryColor,
                onCreditCardModelChange: (model) {
                  setState(() {
                    cardNumber = model.cardNumber;
                    expiryDate = model.expiryDate;
                    cardHolderName = model.cardHolderName;
                    cvvCode = model.cvvCode;
                  });
                },
              ),
            ],
            if (_selectedMethod == 'PayPal') ...[
              TextField(
                controller: paypalEmailController,
                decoration: const InputDecoration(labelText: 'PayPal Email'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: paypalPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'PayPal Password'),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isLoading ? null : userTappedPay,
              icon: const Icon(Icons.lock),
              label: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
