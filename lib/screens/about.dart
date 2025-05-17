import 'dart:math';

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  final List<String> reviewImages = [
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxuxduozCJ22NgdJcT3TeFZlsgvqiPZUvqkQ&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfMqxc-96nAKj6T3n8iazQMcUqACkhWVE2nA&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZTjkoktclVrTpakvfUTNncPvc3n2jHS1z4A&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3fuW6Zf7LTwG3_KvxWg6CcjusxzeAnb4tGg&s',
  ];

  final List<String> reviewTexts = [
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod',
    'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod',
  ];

  final List<String> reviewNames = [
    'John Deo',
    'Jane Doe',
    'Alex Smith',
    'Emily Johnson',
  ];

  final List<String> reviewRoles = [
    'Traveler',
    'Software Engineer',
    'Web Developer',
    'CEO, ABC Company',
  ];

  AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text('Travel Agency'),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                          50), // Rounded corners for all edges
                      child: Container(
                        height:
                            200, // Adjust height to fit mobile screens better
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGjlv393Cj_i1FRhcq9Pbmpmd8DAkytGNodA&s'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 45, // Adjust bottom to raise the text
                    left: 65,
                    child: Text(
                      'About Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Us?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildIconColumn(Icons.map, 'Top Destinations'),
                        _buildIconColumn(Icons.money, 'Affordable Price'),
                        _buildIconColumn(Icons.headset, '24/7 Guide Service'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    Text(
                      'Reviews',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildReviewList(),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconColumn(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 30),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildReviewList() {
    Random random = Random();
    return Column(
      children: List.generate(reviewImages.length, (index) {
        double rating = (index < 3)
            ? 5.0
            : 4 +
                random
                    .nextDouble(); // First 3 reviews have 5 stars, last one has random rating between 4 and 5

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(reviewImages[index]),
              radius: 30,
            ),
            title: Text(reviewNames[index]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reviewRoles[index]),
                SizedBox(height: 4),
                Row(
                  children: List.generate(5, (starIndex) {
                    return Icon(
                      Icons.star,
                      color: starIndex < rating.round()
                          ? Colors.yellow
                          : Colors.grey,
                      size: 20,
                    );
                  }),
                ),
              ],
            ),
            isThreeLine: true,
            onTap: () {
              // Add review tap functionality here if needed
            },
          ),
        );
      }),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick Links',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text('Home')),
                  TextButton(onPressed: () {}, child: Text('About')),
                  TextButton(onPressed: () {}, child: Text('Package')),
                  TextButton(onPressed: () {}, child: Text('Book')),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact Info',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: Text('+123-456-7890')),
                  TextButton(
                      onPressed: () {}, child: Text('plsgq@example.com')),
                  TextButton(
                      onPressed: () {}, child: Text('Aswan, Egypt - 400104')),
                ],
              ),
            ],
          ),
          Divider(),
          Text('Created by Best Team | All rights reserved'),
        ],
      ),
    );
  }
}
