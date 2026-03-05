import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'caregiver_home_screen.dart';

class RoleRouter extends StatelessWidget {
  const RoleRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Not logged in
        // ✅ REPLACE WITH THIS
if (authSnapshot.connectionState == ConnectionState.waiting) {
  // Still loading — wait for Firebase, don't redirect yet!
  return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}

if (!authSnapshot.hasData) {
  // Now we're sure there's no session — safe to redirect
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacementNamed(context, '/choice');
  });
  return const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );
}

        // User is logged in - check their role
        final uid = authSnapshot.data!.uid;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
          builder: (context, userSnapshot) {
            // Loading user data
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Error or user doesn't exist
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text('User data not found'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Get user role
            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final role = userData['role'] as String?;

            print('✅ User role: $role');

            // Route based on role
            if (role == 'patient') {
              return const HomeScreen(); // Your existing patient home
            } else if (role == 'caregiver') {
              return const CaregiverHomeScreen();
            } else {
              // Unknown role
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.help_outline, size: 64, color: Colors.orange),
                      const SizedBox(height: 16),
                      Text('Unknown role: $role'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}