import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widget.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _userNameTextController = TextEditingController();

  String? validatePassword(String password) {
    // Regular expression for a strong password
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');

    if (!passwordRegex.hasMatch(password)) {
      return 'Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQQQskhbpgjJeVxHEO6WtY0nJYQRBIPJjSq7Cc7eikNuLFsKI91',
            ),
            fit: BoxFit.cover, // Ensure the image covers the screen
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                reusableTextField(
                  "Enter UserName",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(height: 20),
                reusableTextField(
                  "Enter Password",
                  Icons.lock_outlined,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, () {
                  final passwordValidationMessage =
                      validatePassword(_passwordTextController.text.trim());
                  if (passwordValidationMessage != null) {
                    // Show validation error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(passwordValidationMessage)),
                    );
                    return;
                  }

                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: _emailTextController.text.trim(),
                    password: _passwordTextController.text.trim(),
                  )
                      .then((value) {
                    // Save user data in Firestore after successful signup
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(value.user?.uid)
                        .set({
                      'email': _emailTextController.text.trim(),
                      'name': _userNameTextController.text.trim(),
                    });

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User created successfully!"),
                        duration: Duration(seconds: 3),
                      ),
                    );

                    // Navigate back to the SignInScreen after successful signup
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()),
                    );
                  }).catchError((error) {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${error.message}")),
                    );
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
