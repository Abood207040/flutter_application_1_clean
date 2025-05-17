import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/adminchat.dart';
import 'package:flutter_application_1/utils/authserv.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePageH extends StatefulWidget {
  const HomePageH({super.key});

  @override
  State<HomePageH> createState() => _HomePageHState();
}

class _HomePageHState extends State<HomePageH> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Center(
          child: Text(
            'Support Chat',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: signOut,
            color: Colors.white,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Users',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading users'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data?.docs ?? [];
        if (users.isEmpty) {
          return const Center(child: Text('No users found'));
        }
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(users[index]);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return const Center(
        child: Text('Error: Invalid user data'),
      );
    }

    final String email = data['email'] ?? 'Unknown Email';
    final String uid = data['uid'] ?? '';

    // Check to avoid showing the current user's email
    if (_auth.currentUser?.email != email) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: ListTile(
          leading: const Icon(Icons.account_circle, size: 40),
          title: Text(
            email,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing:
              const Icon(Icons.chat, color: Color.fromARGB(255, 150, 132, 75)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminChatPage(
                  receiveruserEmail: email,
                  receiverUserID: uid,
                ),
              ),
            );
          },
        ),
      );
    } else {
      return Container(); // Skip rendering for the current user
    }
  }
}
