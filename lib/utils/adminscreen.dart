import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/homepagee.dart';
import 'package:flutter_application_1/utils/dashboardscreenadmin.dart';

class AdminScreenpadge extends StatelessWidget {
  const AdminScreenpadge(
      {Key? key, required receiverUserID, required receiveruserEmail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Header Image with enhanced corners
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  'https://media.istockphoto.com/id/1443287362/photo/woman-hiking-in-mountains-on-the-background-of-lysefjorden.jpg?s=612x612&w=0&k=20&c=KvjX-5qcy0Q3dM03sBl8CYkvtF3g1Zn77Kd8uHdOXlA=',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),

              // Admin Options Title
              const Text(
                'Admin Options',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 20),

              // Dashboard Box
              AdminOptionBox(
                image:
                    'https://www.shutterstock.com/image-vector/sales-growth-vector-icon-style-600w-331846619.jpg',
                title: 'Dashboard',
                description: 'Manage and oversee admin operations.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminDashboard(userId: 'user'),
                    ),
                  );
                },
              ),

              // Emails Box
              AdminOptionBox(
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSNrrcjoniz2VD0CD679jw54HeoA4BFim9LTg&s',
                title: 'Emails',
                description: 'Access and manage all user emails.',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePageH()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminOptionBox extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onPressed;

  const AdminOptionBox({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Column(
        children: [
          // Enhanced picture with rounded diagonal clipping
          ClipPath(
            clipper: DiagonalClipper(),
            child: Image.network(
              image,
              height: 120.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A4E23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                    ),
                    child: const Text(
                      'Open',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Diagonal from bottom left
    path.lineTo(size.width, size.height); // Straight line to bottom right
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
