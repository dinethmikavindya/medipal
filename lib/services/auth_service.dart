import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // SIGN UP with better error handling
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      print('🔵 Starting sign up: $email');

      // Create auth account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Auth timeout'),
      );

      print('✅ Auth created: ${userCredential.user!.uid}');

      String uid = userCredential.user!.uid;

      // Create Firestore profile
      try {
        print('⏳ Writing to Firestore...');
        
        await _firestore.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': null,
          'linkedPatients': [],
          'linkedCaregivers': [],
        }).timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('Firestore timeout'),
        );

        print('✅ Firestore profile created!');
        return null; // Success
        
      } catch (firestoreError) {
        print('❌ Firestore error: $firestoreError');
        
        // Delete auth account if Firestore fails
        await userCredential.user?.delete();
        
        if (firestoreError.toString().contains('permission-denied')) {
          return 'Database permission denied';
        }
        if (firestoreError.toString().contains('timeout') || 
            firestoreError.toString().contains('Timeout')) {
          return 'Cannot connect to database. Check your internet.';
        }
        
        return 'Failed to create profile: $firestoreError';
      }
      
    } on FirebaseAuthException catch (e) {
      print('❌ Auth error: ${e.code}');
      
      switch (e.code) {
        case 'email-already-in-use':
          return 'Email already registered';
        case 'weak-password':
          return 'Password too weak (min 6 characters)';
        case 'invalid-email':
          return 'Invalid email';
        case 'network-request-failed':
          return 'No internet connection';
        default:
          return e.message ?? 'Sign up failed';
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      return 'Error: $e';
    }
  }

  // SIGN IN
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'No account found';
        case 'wrong-password':
          return 'Incorrect password';
        case 'invalid-email':
          return 'Invalid email';
        default:
          return e.message ?? 'Sign in failed';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  // SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(const Duration(seconds: 10));
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Get user role
  Future<String?> getUserRole() async {
    if (currentUser == null) return null;
    var profile = await getUserProfile(currentUser!.uid);
    return profile?['role'] as String?;
  }
}