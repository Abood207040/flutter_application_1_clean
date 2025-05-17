import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/design%20patterns/observer_paymentconfirmed.dart';
import 'package:flutter_application_1/screens/mainn.dart';

class PaymentConfirmedPage extends StatefulWidget {
  final String username;

  const PaymentConfirmedPage({Key? key, required this.username})
      : super(key: key);

  @override
  State<PaymentConfirmedPage> createState() => _PaymentConfirmedPageState();
}

class _PaymentConfirmedPageState extends State<PaymentConfirmedPage> {
  String? _bookingStatus;
  String? _previousStatus;
  late Subject _statusSubject;
  late StatusObserver _observer;

  int _selectedRating = 0;
  bool _isSubmitting = false;
  String _ratingFeedback = "";

  @override
  void initState() {
    super.initState();

    _statusSubject = Subject();
    _observer = StatusObserver("UI Observer");
    _statusSubject.addObserver(_observer);

    FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.username)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final status = data['status'] ?? 'unknown';

        if (status != _previousStatus) {
          setState(() {
            _bookingStatus = status;
          });

          _statusSubject.notifyObservers("Status updated to: $status");

          if (_previousStatus != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Status changed to: $status")),
            );
          }

          _previousStatus = status;
        }
      }
    });
  }

  Future<void> submitRating() async {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a rating before submitting.')),
      );
      return;
    }

    // Set feedback message based on rating
    switch (_selectedRating) {
      case 5:
        _ratingFeedback = "Excellent";
        break;
      case 4:
        _ratingFeedback = "Very Good";
        break;
      case 3:
        _ratingFeedback = "Good";
        break;
      case 2:
        _ratingFeedback = "Fair";
        break;
      case 1:
        _ratingFeedback = "Poor";
        break;
      default:
        _ratingFeedback = "";
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance.collection('service_ratings').add({
          'userId': currentUser.uid,
          'username': widget.username,
          'rating': _selectedRating,
          'feedback': _ratingFeedback,
          'timestamp': Timestamp.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Thank you for your feedback! ($_ratingFeedback)')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TravelApp(),
            ),
          );
        }
      } else {
        throw Exception('User not authenticated.');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit rating: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Payment Confirmed'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://marketplace.canva.com/EAF6acpWphQ/2/0/1600w/canva-brown-colorful-travel-photo-collage-sJLlU2R3gLs.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                color: Colors.white.withOpacity(0.93),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.brown,
                        size: 80.0,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your payment has been successfully confirmed!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade700,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.info, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              "Booking Status: ${_bookingStatus ?? 'Loading...'}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton.icon(
                        onPressed: _bookingStatus == 'cancelled'
                            ? null
                            : () async {
                                try {
                                  final docRef = FirebaseFirestore.instance
                                      .collection('bookings')
                                      .doc(widget.username);

                                  final docSnap = await docRef.get();
                                  if (docSnap.exists) {
                                    await docRef
                                        .update({'status': 'cancelled'});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Booking cancelled.')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Booking not found.')),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Failed to cancel booking: $e')),
                                  );
                                }
                              },
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancel Booking"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 18),
                        child: Column(
                          children: [
                            Text(
                              'Rate our service:',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.amber.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () {
                                          setState(() {
                                            _selectedRating = index + 1;
                                          });
                                        },
                                  icon: Icon(
                                    index < _selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 36,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : submitRating,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Submit Rating',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TravelApp(),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Back to Home',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> createBooking(BuildContext context, String username) async {
  final bookingRef =
      await FirebaseFirestore.instance.collection('bookings').add({
    'username': username,
    'status': 'pending',
    'created_at': Timestamp.now(),
  });

  // Navigate to PaymentConfirmedPage with the new booking ID
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PaymentConfirmedPage(username: bookingRef.id),
    ),
  );
}
