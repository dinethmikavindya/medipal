import 'package:cloud_firestore/cloud_firestore.dart';

class HealthSummaryModel {
  final double? bloodSugar;
  final double? spo2;
  final double? heartRate;
  final double? bmi;
  final String? bloodPressure;
  final double? weight;
  final double? height;
  final double? temperature;
  final List<String>? medications;
  final String? diagnosis;
  final DateTime? lastUpdated;
  
  // ✅ NEW: AI Analysis fields
  final List<String>? suggestions;
  final String? riskLevel;
  final int? healthScore;

  HealthSummaryModel({
    this.bloodSugar,
    this.spo2,
    this.heartRate,
    this.bmi,
    this.bloodPressure,
    this.weight,
    this.height,
    this.temperature,
    this.medications,
    this.diagnosis,
    this.lastUpdated,
    this.suggestions,
    this.riskLevel,
    this.healthScore,
  });

  // ✅ Create from Firestore document
  factory HealthSummaryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return HealthSummaryModel();
    }

    return HealthSummaryModel(
      bloodSugar: data['bloodSugar']?.toDouble(),
      spo2: data['spo2']?.toDouble(),
      heartRate: data['heartRate']?.toDouble(),
      bmi: data['bmi']?.toDouble(),
      bloodPressure: data['bloodPressure'],
      weight: data['weight']?.toDouble(),
      height: data['height']?.toDouble(),
      temperature: data['temperature']?.toDouble(),
      medications: data['medications'] != null 
          ? List<String>.from(data['medications'])
          : null,
      diagnosis: data['diagnosis'],
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
      // ✅ NEW: Parse AI fields
      suggestions: data['suggestions'] != null
          ? List<String>.from(data['suggestions'])
          : null,
      riskLevel: data['riskLevel'],
      healthScore: data['healthScore'],
    );
  }

  // ✅ Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    
    if (bloodSugar != null) map['bloodSugar'] = bloodSugar;
    if (spo2 != null) map['spo2'] = spo2;
    if (heartRate != null) map['heartRate'] = heartRate;
    if (bmi != null) map['bmi'] = bmi;
    if (bloodPressure != null) map['bloodPressure'] = bloodPressure;
    if (weight != null) map['weight'] = weight;
    if (height != null) map['height'] = height;
    if (temperature != null) map['temperature'] = temperature;
    if (medications != null) map['medications'] = medications;
    if (diagnosis != null) map['diagnosis'] = diagnosis;
    if (lastUpdated != null) {
      map['lastUpdated'] = Timestamp.fromDate(lastUpdated!);
    }
    
    // ✅ NEW: Add AI fields
    if (suggestions != null) map['suggestions'] = suggestions;
    if (riskLevel != null) map['riskLevel'] = riskLevel;
    if (healthScore != null) map['healthScore'] = healthScore;
    
    return map;
  }

  // ✅ Check if any data exists
  bool get hasData {
    return bloodSugar != null ||
        spo2 != null ||
        heartRate != null ||
        bmi != null ||
        bloodPressure != null ||
        weight != null ||
        height != null ||
        temperature != null ||
        (medications != null && medications!.isNotEmpty) ||
        diagnosis != null;
  }

  // ✅ Get risk level color
  static int getRiskColor(String? riskLevel) {
    switch (riskLevel) {
      case 'Critical':
        return 0xFFD32F2F; // Dark Red
      case 'High':
        return 0xFFFF5252; // Red
      case 'Medium':
        return 0xFFFFB74D; // Orange
      case 'Normal':
        return 0xFF4CAF50; // Green
      default:
        return 0xFF9E9E9E; // Grey
    }
  }

  // ✅ Get risk level emoji
  static String getRiskEmoji(String? riskLevel) {
    switch (riskLevel) {
      case 'Critical':
        return '🚨';
      case 'High':
        return '🔴';
      case 'Medium':
        return '⚠️';
      case 'Normal':
        return '✅';
      default:
        return '📊';
    }
  }

  // ✅ Copy with updated values
  HealthSummaryModel copyWith({
    double? bloodSugar,
    double? spo2,
    double? heartRate,
    double? bmi,
    String? bloodPressure,
    double? weight,
    double? height,
    double? temperature,
    List<String>? medications,
    String? diagnosis,
    DateTime? lastUpdated,
    List<String>? suggestions,
    String? riskLevel,
    int? healthScore,
  }) {
    return HealthSummaryModel(
      bloodSugar: bloodSugar ?? this.bloodSugar,
      spo2: spo2 ?? this.spo2,
      heartRate: heartRate ?? this.heartRate,
      bmi: bmi ?? this.bmi,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      temperature: temperature ?? this.temperature,
      medications: medications ?? this.medications,
      diagnosis: diagnosis ?? this.diagnosis,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      suggestions: suggestions ?? this.suggestions,
      riskLevel: riskLevel ?? this.riskLevel,
      healthScore: healthScore ?? this.healthScore,
    );
  }
}