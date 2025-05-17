import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/mainn.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter_application_1/utils/adminscreen.dart';

// Admin Screen Placeholder
class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Admin Panel'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Admin Panel!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/logo2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.2,
              20,
              0,
            ),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 30),
                rusableTextField(
                  "Enter Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                ),
                const SizedBox(height: 20),
                rusableTextField(
                  "Enter Password",
                  Icons.lock_outline,
                  true,
                  _passwordTextController,
                  backgroundColor: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                ),
                const SizedBox(height: 20),
                signInSignUpButton(context, true, () {
                  if (_emailTextController.text.trim() == 'dmin@gmail.com' &&
                      _passwordTextController.text.trim() ==
                          'Dmin@gmail.com1') {
                    // Navigate to AdminScreen if credentials match
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminScreenpadge(
                                receiveruserEmail: null,
                                receiverUserID: null,
                              )),
                    );
                    return;
                  }

                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text.trim(),
                    password: _passwordTextController.text.trim(),
                  )
                      .then((value) {
                    // Save user data in Firestore after successful login
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(value.user?.uid)
                        .get()
                        .then((doc) {
                      if (!doc.exists) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(value.user?.uid)
                            .set({
                          'email': _emailTextController.text.trim(),
                          'name': 'New User',
                        });
                      }
                    });

                    // Navigate to TravelApp after successful login
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TravelApp(),
                      ),
                    );
                  }).catchError((error) {
                    String errorMessage = error.code == 'user-not-found'
                        ? 'No user found for that email.'
                        : error.code == 'wrong-password'
                            ? 'Wrong password provided for that user.'
                            : 'Error: ${error.message}';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMessage)),
                    );
                  });
                }),
                signUpOption(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
            style: TextStyle(color: Colors.brown)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
            );
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

Widget rusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller,
    {Color backgroundColor = Colors.white,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(12)),
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0)}) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: borderRadius,
    ),
    child: TextField(
      controller: controller,
      obscureText: isPasswordType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: text,
        hintStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Colors.black),
        border: InputBorder.none,
        contentPadding: padding,
      ),
    ),
  );
}
