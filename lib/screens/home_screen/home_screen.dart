import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(), // Listen for authentication state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for Firebase to initialize
          return const Center(child: CircularProgressIndicator());
        }

        // If there is no authenticated user
        if (!snapshot.hasData) {
          return const Center(child: Text('No user logged in.'));
        }

        // Get the current user from snapshot data
        User? user = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'DMCalendar',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 3, 192, 244),
            actions: [
              IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
            ],
          ),
          body: Center(
            child: Text('Logged in as: ${user?.email ?? 'Unknown'}'),
          ),
        );
      },
    );
  }
}
