import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/bookingforpackage.dart'; // Import the new booking screen

class PackagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Journal'),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        decoration: BoxDecoration(
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
              // Header Image with rounded right edges
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(50), // Rounded top-right corner
                  bottomRight:
                      Radius.circular(50), // Rounded bottom-right corner
                  bottomLeft: Radius.circular(0),
                ),
                child: Container(
                  child: Image.network(
                    'https://media.istockphoto.com/id/1443287362/photo/woman-hiking-in-mountains-on-the-background-of-lysefjorden.jpg?s=612x612&w=0&k=20&c=KvjX-5qcy0Q3dM03sBl8CYkvtF3g1Zn77Kd8uHdOXlA=',
                    width:
                        double.infinity, // This makes the image take full width
                    height: 180, // Adjust the height to your preference
                    fit: BoxFit
                        .cover, // Ensures the image stretches to fill the space
                  ),
                ),
              ),
              SizedBox(height: 20), // Small gap before the list of packages

              // Title for Popular Packages
              Text(
                'Our Popular Packages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20), // Gap between title and package boxes

              // List of Package Boxes
              PackageBox(
                image:
                    'https://t4.ftcdn.net/jpg/08/39/11/31/360_F_839113100_fQwwrgUrrqZM2cv6ZJolnVRup9aotCKV.jpg',
                title: 'Beach Escape',
                description: 'Relax on a beautiful beach and soak in the sun.',
                price: 499.99, // Add price
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreenForPackage(
                        packageName: 'Beach Escape',
                        packageCost: 499.99,
                      ),
                    ),
                  );
                },
              ),
              PackageBox(
                image:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU9DYJA6urxnqFKddbMjycIxLFa-el7NsS9A&s',
                title: 'Cultural Exploration',
                description: 'Explore rich cultural landmarks and traditions.',
                price: 699.99, // Add price
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreenForPackage(
                        packageName: 'Cultural Exploration',
                        packageCost: 699.99,
                      ),
                    ),
                  );
                },
              ),
              PackageBox(
                image:
                    'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1d/50/57/2d/caption.jpg?w=1200&h=700&s=1&cx=1728&cy=1152&chk=v1_c3b95e04b02f1c246e25',
                title: 'Desert Safari',
                description:
                    'Explore the desert with a thrilling safari experience.',
                price: 899.99, // Add price
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreenForPackage(
                        packageName: 'Desert Safari',
                        packageCost: 899.99,
                      ),
                    ),
                  );
                },
              ),
              PackageBox(
                image:
                    'https://media.istockphoto.com/id/579768912/photo/silhouette-of-a-standing-happy-man-on-the-mountain-peak.jpg?s=612x612&w=0&k=20&c=bU27_YKvR2o012jCzgS_cQJNL_NAEbYQuYy9bi7wIuY=',
                title: 'Mountain Adventure',
                description:
                    'Challenge yourself with an exciting mountain adventure.',
                price: 1099.99, // Add price
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreenForPackage(
                        packageName: 'Mountain Adventure',
                        packageCost: 1099.99,
                      ),
                    ),
                  );
                },
              ),
              PackageBox(
                image:
                    'https://media.istockphoto.com/id/521714583/photo/new-york-city-midtown-with-empire-state-building-at-sunset.jpg?s=612x612&w=0&k=20&c=paLoZfZnaZSfaBK_DxLls_Ii0hD3r2PBKSlS6M1QxVU=',
                title: 'City Discovery',
                description: 'Discover the vibrant city life and culture.',
                price: 799.99, // Add price
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreenForPackage(
                        packageName: 'City Discovery',
                        packageCost: 799.99,
                      ),
                    ),
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

class PackageBox extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double price; // Add price field
  final VoidCallback onPressed;

  const PackageBox({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.price, // Add price
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8, // Increased shadow for a more pronounced effect
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: Image.network(
              image,
              height: 180.0, // Increase image height for more prominence
              width: double.infinity, // Ensure it spans across the container
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
                    fontSize: 22, // Increase title size for emphasis
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ), // Subtle description style
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Price: \$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 153, 89, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shadowColor: Colors.black.withOpacity(0.2),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(color: Colors.white),
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
