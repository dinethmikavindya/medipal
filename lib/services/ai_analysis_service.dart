class AIAnalysisService {
  // ✅ Analyze all health data and generate risk assessment + suggestions
  Map<String, dynamic> analyzeHealthData(Map<String, dynamic> parsedData) {
    final suggestions = <String>[];
    String overallRisk = 'Normal';
    int riskScore = 0; // 0-10 scale

    print('🤖 Starting AI health analysis...');

    // ✅ Analyze Blood Sugar
    final bloodSugar = parsedData['bloodSugar'] as double?;
    if (bloodSugar != null) {
      if (bloodSugar < 70) {
        suggestions.add('⚠️ Low blood sugar detected (${bloodSugar.toStringAsFixed(0)} mg/dL). Consume fast-acting carbohydrates immediately.');
        riskScore += 3;
        overallRisk = 'High';
      } else if (bloodSugar >= 70 && bloodSugar <= 100) {
        suggestions.add('✅ Blood sugar is in healthy range (${bloodSugar.toStringAsFixed(0)} mg/dL). Keep up the good work!');
      } else if (bloodSugar > 100 && bloodSugar <= 125) {
        suggestions.add('⚠️ Blood sugar slightly elevated (${bloodSugar.toStringAsFixed(0)} mg/dL). Monitor your diet and exercise regularly.');
        riskScore += 1;
        if (overallRisk == 'Normal') overallRisk = 'Medium';
      } else if (bloodSugar > 125 && bloodSugar <= 180) {
        suggestions.add('🔴 High blood sugar detected (${bloodSugar.toStringAsFixed(0)} mg/dL). Consult your doctor about diabetes management.');
        riskScore += 2;
        overallRisk = 'High';
      } else {
        suggestions.add('🚨 Critical blood sugar level (${bloodSugar.toStringAsFixed(0)} mg/dL). Seek immediate medical attention!');
        riskScore += 4;
        overallRisk = 'Critical';
      }
    }

    // ✅ Analyze Heart Rate
    final heartRate = parsedData['heartRate'] as double?;
    if (heartRate != null) {
      if (heartRate < 60) {
        suggestions.add('⚠️ Low heart rate detected (${heartRate.toStringAsFixed(0)} bpm). If you\'re not an athlete, consult a doctor.');
        riskScore += 1;
        if (overallRisk == 'Normal') overallRisk = 'Medium';
      } else if (heartRate >= 60 && heartRate <= 100) {
        suggestions.add('✅ Heart rate is normal (${heartRate.toStringAsFixed(0)} bpm). Your cardiovascular health looks good!');
      } else if (heartRate > 100 && heartRate <= 120) {
        suggestions.add('⚠️ Elevated heart rate (${heartRate.toStringAsFixed(0)} bpm). Try relaxation techniques and monitor stress levels.');
        riskScore += 2;
        if (overallRisk == 'Normal') overallRisk = 'Medium';
      } else {
        suggestions.add('🔴 High heart rate detected (${heartRate.toStringAsFixed(0)} bpm). Consult a cardiologist if persistent.');
        riskScore += 3;
        overallRisk = 'High';
      }
    }

    // ✅ Analyze SpO2
    final spo2 = parsedData['spo2'] as double?;
    if (spo2 != null) {
      if (spo2 < 90) {
        suggestions.add('🚨 Critical oxygen saturation (${spo2.toStringAsFixed(0)}%). Seek emergency medical care immediately!');
        riskScore += 4;
        overallRisk = 'Critical';
      } else if (spo2 >= 90 && spo2 < 95) {
        suggestions.add('⚠️ Low oxygen saturation (${spo2.toStringAsFixed(0)}%). Monitor breathing and consult a doctor.');
        riskScore += 2;
        overallRisk = 'High';
      } else {
        suggestions.add('✅ Oxygen saturation is excellent (${spo2.toStringAsFixed(0)}%). Your respiratory health is good!');
      }
    }

    // ✅ Analyze BMI
    final bmi = parsedData['bmi'] as double?;
    if (bmi != null) {
      if (bmi < 18.5) {
        suggestions.add('⚠️ Underweight (BMI: ${bmi.toStringAsFixed(1)}). Consider consulting a nutritionist for healthy weight gain.');
        riskScore += 1;
        if (overallRisk == 'Normal') overallRisk = 'Medium';
      } else if (bmi >= 18.5 && bmi < 25) {
        suggestions.add('✅ Healthy weight (BMI: ${bmi.toStringAsFixed(1)}). Maintain your current lifestyle!');
      } else if (bmi >= 25 && bmi < 30) {
        suggestions.add('⚠️ Overweight (BMI: ${bmi.toStringAsFixed(1)}). Increase physical activity and improve diet.');
        riskScore += 1;
        if (overallRisk == 'Normal') overallRisk = 'Medium';
      } else if (bmi >= 30 && bmi < 35) {
        suggestions.add('🔴 Obese (BMI: ${bmi.toStringAsFixed(1)}). Weight management program recommended. Consult a doctor.');
        riskScore += 2;
        overallRisk = 'High';
      } else {
        suggestions.add('🚨 Severely obese (BMI: ${bmi.toStringAsFixed(1)}). Urgent medical consultation needed for health risks.');
        riskScore += 3;
        overallRisk = 'High';
      }
    }

    // ✅ Analyze Blood Pressure
    final bloodPressure = parsedData['bloodPressure'] as String?;
    if (bloodPressure != null) {
      final parts = bloodPressure.split('/');
      if (parts.length == 2) {
        final systolic = int.tryParse(parts[0]);
        final diastolic = int.tryParse(parts[1]);
        
        if (systolic != null && diastolic != null) {
          if (systolic < 90 || diastolic < 60) {
            suggestions.add('⚠️ Low blood pressure ($bloodPressure mmHg). Stay hydrated and avoid sudden position changes.');
            riskScore += 1;
            if (overallRisk == 'Normal') overallRisk = 'Medium';
          } else if (systolic <= 120 && diastolic <= 80) {
            suggestions.add('✅ Blood pressure is optimal ($bloodPressure mmHg). Keep maintaining healthy habits!');
          } else if (systolic <= 139 || diastolic <= 89) {
            suggestions.add('⚠️ Pre-hypertension ($bloodPressure mmHg). Reduce sodium intake and exercise regularly.');
            riskScore += 2;
            if (overallRisk == 'Normal') overallRisk = 'Medium';
          } else if (systolic <= 179 || diastolic <= 109) {
            suggestions.add('🔴 High blood pressure ($bloodPressure mmHg). Consult a doctor about hypertension management.');
            riskScore += 3;
            overallRisk = 'High';
          } else {
            suggestions.add('🚨 Hypertensive crisis ($bloodPressure mmHg). Seek immediate emergency care!');
            riskScore += 4;
            overallRisk = 'Critical';
          }
        }
      }
    }

    // ✅ Check for medications
    final medications = parsedData['medications'] as List<dynamic>?;
    if (medications != null && medications.isNotEmpty) {
      suggestions.add('💊 Taking medications: ${medications.join(", ")}. Remember to take them as prescribed!');
    }

    // ✅ General health recommendations
    if (suggestions.isEmpty) {
      suggestions.add('📊 Upload a medical report to receive personalized health insights and recommendations.');
    } else {
      // Add general wellness tips based on risk level
      if (overallRisk == 'Normal') {
        suggestions.add('🌟 Overall health status: Good! Keep up your healthy lifestyle habits.');
      } else if (overallRisk == 'Medium') {
        suggestions.add('📈 Monitor your health regularly. Small lifestyle changes can make a big difference!');
      } else if (overallRisk == 'High') {
        suggestions.add('⚠️ Schedule a doctor\'s appointment to discuss your health concerns.');
      } else if (overallRisk == 'Critical') {
        suggestions.add('🚨 Immediate medical attention recommended. Do not delay seeking help!');
      }
    }

    // Calculate health score (0-100)
    final healthScore = ((10 - riskScore.clamp(0, 10)) / 10 * 100).round();

    print('✅ AI Analysis complete!');
    print('   Risk Level: $overallRisk');
    print('   Health Score: $healthScore%');
    print('   Generated ${suggestions.length} suggestions');

    return {
      'suggestions': suggestions,
      'riskLevel': overallRisk,
      'riskScore': riskScore,
      'healthScore': healthScore,
      'analyzedAt': DateTime.now(),
    };
  }

  // ✅ Get risk level color
  static int getRiskColor(String riskLevel) {
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
  static String getRiskEmoji(String riskLevel) {
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

  // ✅ Get health score description
  static String getHealthScoreDescription(int score) {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Fair';
    if (score >= 40) return 'Needs Attention';
    return 'Critical';
  }
}