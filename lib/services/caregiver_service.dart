import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CaregiverService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generate a unique 6-digit code for the patient
  /// The code expires after 24 hours
  Future<String> generatePatientCode(String patientUid) async {
    String code = _generateRandomCode();
    
    // Store the code in a separate collection with expiration
    await _firestore.collection('access_codes').doc(code).set({
      'patientUid': patientUid,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': DateTime.now().add(const Duration(hours: 24)).millisecondsSinceEpoch,
    });

    return code;
  }

  /// Generate a random 6-digit code
  String _generateRandomCode() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  /// Caregiver enters code to link with patient
  /// Returns null on success, error message on failure
  Future<String?> linkCaregiverToPatient(String caregiverUid, String code) async {
    try {
      // Get the code document
      DocumentSnapshot codeDoc = await _firestore.collection('access_codes').doc(code).get();

      if (!codeDoc.exists) {
        return 'Invalid code. Please check and try again.';
      }

      Map<String, dynamic> codeData = codeDoc.data() as Map<String, dynamic>;
      String patientUid = codeData['patientUid'];
      int expiresAt = codeData['expiresAt'];

      // Check if code expired
      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        // Delete expired code
        await _firestore.collection('access_codes').doc(code).delete();
        return 'Code has expired. Please ask the patient to generate a new code.';
      }

      // Check if caregiver is trying to link to themselves
      if (caregiverUid == patientUid) {
        return 'You cannot link to your own account.';
      }

      // Check if already linked
      DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
      if (caregiverDoc.exists) {
        Map<String, dynamic> caregiverData = caregiverDoc.data() as Map<String, dynamic>;
        List<dynamic> linkedPatients = caregiverData['linkedPatients'] ?? [];
        
        if (linkedPatients.contains(patientUid)) {
          return 'This patient is already linked to your account.';
        }
      }

      // Link caregiver to patient
      await _firestore.collection('users').doc(patientUid).update({
        'linkedCaregivers': FieldValue.arrayUnion([caregiverUid]),
      });

      // Link patient to caregiver
      await _firestore.collection('users').doc(caregiverUid).update({
        'linkedPatients': FieldValue.arrayUnion([patientUid]),
      });

      // Delete the code after successful use
      await _firestore.collection('access_codes').doc(code).delete();

      return null; // Success
    } on FirebaseException catch (e) {
      return 'Firebase error: ${e.message}';
    } catch (e) {
      return 'An error occurred: $e';
    }
  }

  /// Get all patients linked to a caregiver
  /// Returns list of patient profile maps
  Future<List<Map<String, dynamic>>> getLinkedPatients(String caregiverUid) async {
    try {
      DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
      
      if (!caregiverDoc.exists) return [];

      Map<String, dynamic> caregiverData = caregiverDoc.data() as Map<String, dynamic>;
      List<dynamic> linkedPatients = caregiverData['linkedPatients'] ?? [];

      if (linkedPatients.isEmpty) return [];

      // Fetch patient profiles
      List<Map<String, dynamic>> patients = [];
      for (String patientUid in linkedPatients) {
        DocumentSnapshot patientDoc = await _firestore.collection('users').doc(patientUid).get();
        if (patientDoc.exists) {
          patients.add({
            'uid': patientUid,
            ...patientDoc.data() as Map<String, dynamic>,
          });
        }
      }

      return patients;
    } catch (e) {
      print('Error getting linked patients: $e');
      return [];
    }
  }

  /// Get all caregivers linked to a patient
  /// Returns list of caregiver profile maps
  Future<List<Map<String, dynamic>>> getLinkedCaregivers(String patientUid) async {
    try {
      DocumentSnapshot patientDoc = await _firestore.collection('users').doc(patientUid).get();
      
      if (!patientDoc.exists) return [];

      Map<String, dynamic> patientData = patientDoc.data() as Map<String, dynamic>;
      List<dynamic> linkedCaregivers = patientData['linkedCaregivers'] ?? [];

      if (linkedCaregivers.isEmpty) return [];

      // Fetch caregiver profiles
      List<Map<String, dynamic>> caregivers = [];
      for (String caregiverUid in linkedCaregivers) {
        DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
        if (caregiverDoc.exists) {
          caregivers.add({
            'uid': caregiverUid,
            ...caregiverDoc.data() as Map<String, dynamic>,
          });
        }
      }

      return caregivers;
    } catch (e) {
      print('Error getting linked caregivers: $e');
      return [];
    }
  }

  /// Remove caregiver link (can be called by either patient or caregiver)
  Future<void> unlinkCaregiver(String patientUid, String caregiverUid) async {
    try {
      // Remove caregiver from patient's list
      await _firestore.collection('users').doc(patientUid).update({
        'linkedCaregivers': FieldValue.arrayRemove([caregiverUid]),
      });

      // Remove patient from caregiver's list
      await _firestore.collection('users').doc(caregiverUid).update({
        'linkedPatients': FieldValue.arrayRemove([patientUid]),
      });
    } catch (e) {
      print('Error unlinking caregiver: $e');
      rethrow;
    }
  }

  /// Check if a caregiver has access to a patient
  Future<bool> hasAccessToPatient(String caregiverUid, String patientUid) async {
    try {
      DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
      
      if (!caregiverDoc.exists) return false;

      Map<String, dynamic> caregiverData = caregiverDoc.data() as Map<String, dynamic>;
      List<dynamic> linkedPatients = caregiverData['linkedPatients'] ?? [];

      return linkedPatients.contains(patientUid);
    } catch (e) {
      print('Error checking access: $e');
      return false;
    }
  }

  /// Delete expired access codes (optional cleanup function)
  /// You can call this periodically or set up a Cloud Function to do it
  Future<void> cleanupExpiredCodes() async {
    try {
      QuerySnapshot expiredCodes = await _firestore
          .collection('access_codes')
          .where('expiresAt', isLessThan: DateTime.now().millisecondsSinceEpoch)
          .get();

      for (var doc in expiredCodes.docs) {
        await doc.reference.delete();
      }

      print('Cleaned up ${expiredCodes.docs.length} expired codes');
    } catch (e) {
      print('Error cleaning up expired codes: $e');
    }
  }

  /// Get patient basic info (for caregiver to see who they're linked with)
  Future<Map<String, dynamic>?> getPatientBasicInfo(String patientUid) async {
    try {
      DocumentSnapshot patientDoc = await _firestore.collection('users').doc(patientUid).get();
      
      if (!patientDoc.exists) return null;

      Map<String, dynamic> patientData = patientDoc.data() as Map<String, dynamic>;
      
      // Return only basic info (not sensitive data)
      return {
        'uid': patientUid,
        'name': patientData['name'] ?? 'Unknown',
        'email': patientData['email'] ?? '',
        'photoURL': patientData['photoURL'],
      };
    } catch (e) {
      print('Error getting patient info: $e');
      return null;
    }
  }

  /// Get caregiver basic info (for patient to see who has access)
  Future<Map<String, dynamic>?> getCaregiverBasicInfo(String caregiverUid) async {
    try {
      DocumentSnapshot caregiverDoc = await _firestore.collection('users').doc(caregiverUid).get();
      
      if (!caregiverDoc.exists) return null;

      Map<String, dynamic> caregiverData = caregiverDoc.data() as Map<String, dynamic>;
      
      // Return only basic info
      return {
        'uid': caregiverUid,
        'name': caregiverData['name'] ?? 'Unknown',
        'email': caregiverData['email'] ?? '',
        'photoURL': caregiverData['photoURL'],
      };
    } catch (e) {
      print('Error getting caregiver info: $e');
      return null;
    }
  }

  /// Check if code is valid (before trying to link)
  Future<Map<String, dynamic>?> validateCode(String code) async {
    try {
      DocumentSnapshot codeDoc = await _firestore.collection('access_codes').doc(code).get();

      if (!codeDoc.exists) {
        return {'valid': false, 'error': 'Invalid code'};
      }

      Map<String, dynamic> codeData = codeDoc.data() as Map<String, dynamic>;
      int expiresAt = codeData['expiresAt'];

      if (DateTime.now().millisecondsSinceEpoch > expiresAt) {
        // Clean up expired code
        await _firestore.collection('access_codes').doc(code).delete();
        return {'valid': false, 'error': 'Code expired'};
      }

      return {
        'valid': true,
        'patientUid': codeData['patientUid'],
      };
    } catch (e) {
      print('Error validating code: $e');
      return {'valid': false, 'error': 'Validation failed'};
    }
  }
}