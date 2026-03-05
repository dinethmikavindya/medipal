import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/health_summary_model.dart';

class HealthDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Save parsed medical data + AI analysis to Firestore
  Future<void> saveHealthSummary(Map<String, dynamic> healthData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      print('💾 Saving health summary + AI analysis to Firestore...');

      // Prepare data for Firestore (remove null values)
      final cleanData = <String, dynamic>{
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      // Add medical values
      if (healthData['bloodSugar'] != null) {
        cleanData['bloodSugar'] = healthData['bloodSugar'];
      }
      if (healthData['spo2'] != null) {
        cleanData['spo2'] = healthData['spo2'];
      }
      if (healthData['heartRate'] != null) {
        cleanData['heartRate'] = healthData['heartRate'];
      }
      if (healthData['bmi'] != null) {
        cleanData['bmi'] = healthData['bmi'];
      }
      if (healthData['bloodPressure'] != null) {
        cleanData['bloodPressure'] = healthData['bloodPressure'];
      }
      if (healthData['weight'] != null) {
        cleanData['weight'] = healthData['weight'];
      }
      if (healthData['height'] != null) {
        cleanData['height'] = healthData['height'];
      }
      if (healthData['temperature'] != null) {
        cleanData['temperature'] = healthData['temperature'];
      }
      if (healthData['medications'] != null && 
          (healthData['medications'] as List).isNotEmpty) {
        cleanData['medications'] = healthData['medications'];
      }
      if (healthData['diagnosis'] != null) {
        cleanData['diagnosis'] = healthData['diagnosis'];
      }

      // ✅ NEW: Add AI analysis results
      if (healthData['suggestions'] != null) {
        cleanData['suggestions'] = healthData['suggestions'];
      }
      if (healthData['riskLevel'] != null) {
        cleanData['riskLevel'] = healthData['riskLevel'];
      }
      if (healthData['healthScore'] != null) {
        cleanData['healthScore'] = healthData['healthScore'];
      }

      // Save to Firestore (merge with existing data)
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc('summary')
          .set(cleanData, SetOptions(merge: true));

      print('✅ Health summary saved! Updated ${cleanData.keys.length} fields');
    } catch (e) {
      print('❌ Error saving health summary: $e');
    }
  }

  // ✅ Get current health summary (real-time stream)
  Stream<HealthSummaryModel?> getHealthSummary() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('health')
        .doc('summary')
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return HealthSummaryModel.fromFirestore(snapshot);
        });
  }

  // ✅ Get health summary once (for one-time reads)
  Future<HealthSummaryModel?> getHealthSummaryOnce() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc('summary')
          .get();

      if (!snapshot.exists) return null;
      return HealthSummaryModel.fromFirestore(snapshot);
    } catch (e) {
      print('❌ Error getting health summary: $e');
      return null;
    }
  }

  // ✅ Save individual health metric
  Future<void> updateHealthMetric(String metricName, dynamic value) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc('summary')
          .set({
        metricName: value,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Updated $metricName: $value');
    } catch (e) {
      print('❌ Error updating metric: $e');
    }
  }

  // ✅ Add health record to history
  Future<void> addHealthRecord(Map<String, dynamic> healthData) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc('summary')
          .collection('history')
          .add({
        ...healthData,
        'recordedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Health record added to history');
    } catch (e) {
      print('❌ Error adding health record: $e');
    }
  }

  // ✅ Get health history (last 30 days)
  Stream<List<Map<String, dynamic>>> getHealthHistory() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('health')
        .doc('summary')
        .collection('history')
        .where('recordedAt', isGreaterThan: Timestamp.fromDate(thirtyDaysAgo))
        .orderBy('recordedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  // ✅ Clear all health data (for testing)
  Future<void> clearHealthData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('health')
          .doc('summary')
          .delete();

      print('✅ Health data cleared');
    } catch (e) {
      print('❌ Error clearing health data: $e');
    }
  }
}