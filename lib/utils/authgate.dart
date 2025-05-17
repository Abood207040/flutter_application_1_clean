import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/customer_service.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/utils/authserv.dart';
import 'package:flutter_application_1/utils/homepagee.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final AuthService _authService = AuthService();
  String? adminUID;

  @override
  void initState() {
    super.initState();
    _fetchAdminUID();
  }

  Future<void> _fetchAdminUID() async {
    final uid = await _authService.getUserUIDByEmail("dmin@gmail.com");
    setState(() {
      adminUID = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User? user = FirebaseAuth.instance.currentUser;
            if (user != null && adminUID != null) {
              if (user.email == "dmin@gmail.com") {
                return const HomePageH(); // Admin homepage
              } else {
                return ChatPage(
                  receiveruserEmail: "dmin@gmail.com",
                  receiverUserID: adminUID!, // Dynamic admin UID
                );
              }
            }
          }
          return const SignInScreen(); // Default login/register flow
        },
      ),
    );
  }
}
