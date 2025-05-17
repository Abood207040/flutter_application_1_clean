import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/about.dart';
import 'package:flutter_application_1/screens/bookingpage.dart';
import 'package:flutter_application_1/screens/chatbot.dart';
import 'package:flutter_application_1/screens/customer_service.dart';
import 'package:flutter_application_1/screens/mlf.dart';
import 'package:flutter_application_1/screens/packagepage.dart';

import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/utils/dashboard.dart'; // Import SignInScreen

class TravelApp extends StatelessWidget {
  const TravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel Journal',
      theme: ThemeData(
        primaryColor: Colors.brown,
        hintColor: const Color.fromARGB(255, 153, 89, 52),
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 18, color: Colors.grey[800]),
          labelLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Journal'),
        backgroundColor: Colors.brown,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              accountName: Text(
                FirebaseAuth.instance.currentUser?.displayName ??
                    'Travel Journal',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              accountEmail: Text(
                FirebaseAuth.instance.currentUser?.email ?? 'Not logged in',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: FirebaseAuth.instance.currentUser?.photoURL != null
                      ? Image.network(
                          FirebaseAuth.instance.currentUser!.photoURL!,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        )
                      : const Icon(Icons.person),
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
            ),
            ListTile(
              title: const Text('Package'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PackagePage()),
                );
              },
            ),
            ListTile(
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Book'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Dashboard'),
              onTap: () {
                final currentUser = FirebaseAuth.instance.currentUser;

                if (currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DashboardPage(userId: currentUser.uid),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not authenticated')),
                  );
                }
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error during logout: $e')),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
        // Gradient background container with lighter shades of brown
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8CBA7), // Lightest brown
              Color(0xFFD7B59E), // Lighter brown
              Color(
                  0xFF6A4E23), // Dark brown (you can change this to match your preference)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const HomeSlider(),
              const ServicesSection(),
              const AboutSection(),
              const PackagesSection(),
              const OfferSection(),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeSlider extends StatefulWidget {
  const HomeSlider({super.key});

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  final List<Map<String, String>> images = [
    {
      'url':
          'https://media.istockphoto.com/id/155439315/photo/passenger-airplane-flying-above-clouds-during-sunset.jpg?s=612x612&w=0&k=20&c=LJWadbs3B-jSGJBVy9s0f8gZMHi2NvWFXa3VJ2lFcL0=',
      'text': 'Travel Around The World',
    },
    {
      'url':
          'https://images.stockcake.com/public/2/f/e/2fe053c7-cbeb-4e9c-8fc2-ad2898751586_large/sunset-flight-adventure-stockcake.jpg',
      'text': 'Discover New Places',
    },
    {
      'url':
          'https://media.istockphoto.com/id/628875016/photo/airplane.jpg?s=612x612&w=0&k=20&c=-S-Pv54xmNqABv4ALLZWc61ANg_UyqMTFh1e077SmOk=',
      'text': 'Make Your Travel Worthwhile',
    },
    {
      'url':
          'https://i2.pickpik.com/photos/551/769/133/sunset-airplane-silhouette-flying-preview.jpg',
      'text': 'Explore The World',
    },
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0), // Standard padding
      child: ClipRRect(
        // Apply circular border radius to the widget
        borderRadius:
            BorderRadius.circular(30), // Circular radius for all edges
        child: SizedBox(
          height: 250.0,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      FadeInImage.assetNetwork(
                        placeholder:
                            'assets/loading.gif', // Add a placeholder for loading
                        image: images[index]['url']!,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.black26],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              images[index]['text']!,
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    blurRadius: 10.0,
                                    color: Colors.black,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PackagePage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                backgroundColor:
                                    const Color.fromARGB(255, 153, 89, 52),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text(
                                'Discover More',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                bottom: 10.0,
                left: 0.0,
                right: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      width: _currentPage == index ? 12.0 : 8.0,
                      height: _currentPage == index ? 12.0 : 8.0,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'OUR SERVICES',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1,
          padding: const EdgeInsets.all(16.0),
          children: [
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/1706/1706709.png',
              title: 'Adventure',
            ),
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/592/592245.png',
              title: 'Tour Guide',
            ),
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/3531/3531652.png',
              title: 'Trekking',
            ),
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/3373/3373690.png',
              title: 'Camp Fire',
            ),
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/1881/1881985.png',
              title: 'Off Road',
            ),
            ServiceBox(
              image: 'https://cdn-icons-png.freepik.com/256/1020/1020739.png',
              title: 'Camping',
            ),
          ],
        ),
      ],
    );
  }
}

class ServiceBox extends StatelessWidget {
  final String image;
  final String title;

  const ServiceBox({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(image, height: 80.0, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSB1mCCUIOYJQAdvnMbNhoqiXtGztwFIVkerg&s',
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                      'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod. Qui, quod'),
                  const SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      backgroundColor: Color.fromARGB(255, 153, 89, 52),
                    ),
                    child: const Text(
                      'Read More',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PackagesSection extends StatelessWidget {
  const PackagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'OUR PACKAGES',
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0x000a95c8)),
          ),
        ),
        PackageBox(
          image:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrux9FcqbLuDUWNRFm8Te2Rq--me78gziJDA&s',
          title: 'Adventure & Tour',
          description:
              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
          buttonName: 'Book Now',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookingPage()));
          },
        ),
        PackageBox(
          image:
              'https://res.cloudinary.com/worldpackers/image/upload/c_fill,f_auto,q_auto,w_1024/v1/guides/article_cover/emqr2l4h2jyg8sqkzgei',
          title: 'Mountain Trip',
          description:
              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
          buttonName: 'Book Now',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BookingPage()));
          },
        ),
        PackageBox(
          image:
              'https://static.vecteezy.com/system/resources/previews/021/867/068/non_2x/ai-chatbot-with-large-language-models-of-prompt-engineering-of-using-artificial-intelligence-and-natural-language-processing-vector.jpg',
          title: 'AI Exploration',
          description:
              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
          buttonName: 'Open',
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Mlf(),
                ));
          },
        ),
        PackageBox(
          image:
              'https://st4.depositphotos.com/1688079/20602/i/450/depositphotos_206024928-stock-photo-customer-service-team-icon-isolated.jpg',
          title: 'support',
          description:
              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
          buttonName: "Support Chat",
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiveruserEmail: 'Admin@gmail.com',
                          receiverUserID: 'Admin@gmail.com',
                        )));
          },
        ),
        PackageBox(
          image:
              'https://static.vecteezy.com/system/resources/previews/004/974/554/non_2x/chatbot-message-neon-light-icon-talkbot-modern-robot-android-laughing-chat-bot-virtual-assistant-conversational-agent-glowing-sign-with-alphabet-numbers-symbols-isolated-illustration-vector.jpg',
          title: 'Chat Bot',
          description:
              'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
          buttonName: "Chat Bot",
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BotScreen()));
          },
        ),
      ],
    );
  }
}

class PackageBox extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final VoidCallback onPressed;
  final String buttonName;

  const PackageBox(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.onPressed,
      required this.buttonName});

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
            padding: const EdgeInsets.all(
                16.0), // Increased padding for better spacing
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 22, // Increase title size for emphasis
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
                const SizedBox(height: 8.0),
                Text(
                  description,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600]), // Subtle description style
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 153, 89, 52),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 20.0),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shadowColor: Colors.black
                        .withOpacity(0.2), // Subtle shadow effect on button
                  ),
                  child: Text(
                    buttonName,
                    style: const TextStyle(color: Colors.white),
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

class OfferSection extends StatelessWidget {
  const OfferSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Up to 50% Off',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          
          const Text(
            'Lorem ipsum dolor sit amet consectetur adipisicing elit. Quisquam, quod.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 153, 89, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Created by Best Team | All rights reserved',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}
