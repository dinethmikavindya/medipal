import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Generate a random 6-character alphanumeric code
  String _generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // PATIENT: Generate and save access code
  Future<String> generatePatientCode() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      print('🔄 Starting code generation for user: ${user.uid}');

      // Generate unique code
      String code;
      bool codeExists = true;
      int attempts = 0;

      // Keep generating until we get a unique code (max 10 attempts)
      do {
        code = _generateRandomCode();
        attempts++;
        
        print('🎲 Generated code attempt $attempts: $code');
        
        final existingCode = await _firestore
            .collection('access_codes')
            .doc(code)
            .get();
        
        codeExists = existingCode.exists;
        
        if (attempts > 10) {
          throw Exception('Failed to generate unique code after 10 attempts');
        }
      } while (codeExists);

      print('✅ Unique code found: $code');

      // Save code to Firestore access_codes collection
      await _firestore.collection('access_codes').doc(code).set({
        'patientId': user.uid,
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
        'expiresAt': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)), // Valid for 30 days
        ),
        'isUsed': false,
        'usedBy': null,
        'usedAt': null,
      });

      print('💾 Code saved to access_codes collection');

      // Update user's document with the active code
      await _firestore.collection('users').doc(user.uid).update({
        'activeAccessCode': code,
        'accessCodeGeneratedAt': FieldValue.serverTimestamp(),
      });

      print('✅ User document updated with active code');
      print('🎉 Code generation complete: $code');

      return code;
    } catch (e) {
      print('❌ Error generating code: $e');
      rethrow;
    }
  }

  // PATIENT: Get current active code if exists
  Future<String?> getPatientActiveCode() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      print('📖 Fetching active code for user: ${user.uid}');

      final userDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        print('⚠️ User document does not exist');
        return null;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final code = userData['activeAccessCode'] as String?;

      print('✅ Active code: ${code ?? "No code found"}');
      return code;
    } catch (e) {
      print('❌ Error fetching active code: $e');
      return null;
    }
  }

  // CAREGIVER: Verify and use access code to link with patient
  Future<Map<String, dynamic>> linkCaregiverToPatient(String code) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      final codeUpper = code.trim().toUpperCase();
      print('🔍 Verifying code: $codeUpper for caregiver: ${user.uid}');

      // Get code document from Firestore
      final codeDoc = await _firestore
          .collection('access_codes')
          .doc(codeUpper)
          .get();

      // Check if code exists
      if (!codeDoc.exists) {
        print('❌ Code does not exist');
        throw Exception('Invalid access code');
      }

      final codeData = codeDoc.data() as Map<String, dynamic>;
      print('📄 Code data retrieved: $codeData');

      // Check if code is already used
      if (codeData['isUsed'] == true) {
        print('❌ Code already used by: ${codeData['usedBy']}');
        throw Exception('This code has already been used');
      }

      // Check if code is expired
      final expiresAt = (codeData['expiresAt'] as Timestamp).toDate();
      if (DateTime.now().isAfter(expiresAt)) {
        print('❌ Code expired on: $expiresAt');
        throw Exception('This code has expired');
      }

      final patientId = codeData['patientId'] as String;
      print('✅ Code valid! Linking to patient: $patientId');

      // Mark code as used
      await _firestore.collection('access_codes').doc(codeUpper).update({
        'isUsed': true,
        'usedBy': user.uid,
        'usedAt': FieldValue.serverTimestamp(),
      });
      print('✅ Code marked as used');

      // Add caregiver to patient's caregivers array
      await _firestore.collection('users').doc(patientId).update({
        'caregivers': FieldValue.arrayUnion([user.uid]),
      });
      print('✅ Caregiver added to patient caregivers list');

      // Add patient to caregiver's patients array
      await _firestore.collection('users').doc(user.uid).update({
        'patients': FieldValue.arrayUnion([patientId]),
      });
      print('✅ Patient added to caregiver patients list');

      // Get patient info to return
      final patientDoc = await _firestore.collection('users').doc(patientId).get();
      final patientData = patientDoc.data() as Map<String, dynamic>;

      print('🎉 Successfully linked caregiver to patient!');

      return {
        'success': true,
        'patientId': patientId,
        'patientName': patientData['name'] ?? 'Unknown',
        'patientEmail': patientData['email'] ?? 'Unknown',
      };
    } catch (e) {
      print('❌ Error linking caregiver to patient: $e');
      rethrow;
    }
  }

  // CAREGIVER: Get list of linked patients
  Future<List<Map<String, dynamic>>> getCaregiverPatients() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      print('📋 Fetching patients for caregiver: ${user.uid}');

      final caregiverDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!caregiverDoc.exists) return [];

      final caregiverData = caregiverDoc.data() as Map<String, dynamic>;
      final patientIds = List<String>.from(caregiverData['patients'] ?? []);

      if (patientIds.isEmpty) {
        print('⚠️ No patients linked to this caregiver');
        return [];
      }

      print('📝 Found ${patientIds.length} patients');

      // Fetch each patient's details
      List<Map<String, dynamic>> patients = [];
      for (var patientId in patientIds) {
        final patientDoc = await _firestore
            .collection('users')
            .doc(patientId)
            .get();

        if (patientDoc.exists) {
          final patientData = patientDoc.data() as Map<String, dynamic>;
          patients.add({
            'id': patientId,
            'name': patientData['name'] ?? 'Unknown',
            'email': patientData['email'] ?? 'Unknown',
            ...patientData,
          });
        }
      }

      print('✅ Fetched ${patients.length} patient details');
      return patients;
    } catch (e) {
      print('❌ Error fetching caregiver patients: $e');
      return [];
    }
  }

  // PATIENT: Get list of linked caregivers
  Future<List<Map<String, dynamic>>> getPatientCaregivers() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      print('📋 Fetching caregivers for patient: ${user.uid}');

      final patientDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (!patientDoc.exists) return [];

      final patientData = patientDoc.data() as Map<String, dynamic>;
      final caregiverIds = List<String>.from(patientData['caregivers'] ?? []);

      if (caregiverIds.isEmpty) {
        print('⚠️ No caregivers linked to this patient');
        return [];
      }

      print('📝 Found ${caregiverIds.length} caregivers');

      // Fetch each caregiver's details
      List<Map<String, dynamic>> caregivers = [];
      for (var caregiverId in caregiverIds) {
        final caregiverDoc = await _firestore
            .collection('users')
            .doc(caregiverId)
            .get();

        if (caregiverDoc.exists) {
          final caregiverData = caregiverDoc.data() as Map<String, dynamic>;
          caregivers.add({
            'id': caregiverId,
            'name': caregiverData['name'] ?? 'Unknown',
            'email': caregiverData['email'] ?? 'Unknown',
            ...caregiverData,
          });
        }
      }

      print('✅ Fetched ${caregivers.length} caregiver details');
      return caregivers;
    } catch (e) {
      print('❌ Error fetching patient caregivers: $e');
      return [];
    }
  }
}