import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/about.dart';
import 'package:flutter_application_1/screens/bookingpage.dart';
import 'package:flutter_application_1/screens/chatbot.dart';
import 'package:flutter_application_1/screens/customer_service.dart';
import 'package:flutter_application_1/screens/mainn.dart';
import 'package:flutter_application_1/screens/mlf.dart';
import 'package:flutter_application_1/screens/packagepage.dart';
import 'package:flutter_application_1/screens/paymentpage.dart';
import 'package:flutter_application_1/screens/pymentconfirmed.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/utils/authgate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home:PaymentPage(totalCost: 55, bookingData: {'date': '5/8/2022'}), // Example usage
    );
  }
}
