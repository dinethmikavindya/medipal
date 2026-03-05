import 'dart:core';

class MedicalParserService {
  double? extractBloodSugar(String text) {
    final patterns = [
      RegExp(r'(?:blood\s+sugar|glucose|fasting\s+blood\s+sugar|fbs|rbs|random\s+blood\s+sugar)[:\s]*(\d+\.?\d*)\s*(?:mg/dl|mg\/dl)?', 
          caseSensitive: false),
      RegExp(r'hba1c[:\s]*(\d+\.?\d*)', caseSensitive: false),
      RegExp(r'(\d{2,3})\s*mg/dl', caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          if (value >= 40 && value <= 600) {
            print('✅ Blood Sugar found: $value mg/dL');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  double? extractSpO2(String text) {
    final patterns = [
      RegExp(r'(?:spo2|o2\s+sat|oxygen\s+saturation)[:\s]*(\d+\.?\d*)\s*%?', 
          caseSensitive: false),
      RegExp(r'oxygen[:\s]*(\d+\.?\d*)\s*%', caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          // Validate reasonable range (70-100%)
          if (value >= 70 && value <= 100) {
            print('✅ SpO2 found: $value%');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  double? extractHeartRate(String text) {
    final patterns = [
      RegExp(r'(?:heart\s+rate|pulse|hr)[:\s]*(\d+\.?\d*)\s*(?:bpm|beats)?', 
          caseSensitive: false),
      RegExp(r'(\d{2,3})\s*bpm', caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          // Validate reasonable range (30-220 bpm)
          if (value >= 30 && value <= 220) {
            print('✅ Heart Rate found: $value bpm');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  // ✅ Extract BMI
  double? extractBMI(String text) {
    final patterns = [
      RegExp(r'(?:bmi|body\s+mass\s+index)[:\s]*(\d+\.?\d*)', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          if (value >= 10 && value <= 60) {
            print('✅ BMI found: $value');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  String? extractBloodPressure(String text) {
    final patterns = [
      RegExp(r'(?:bp|blood\s+pressure)[:\s]*(\d{2,3})\s*/\s*(\d{2,3})', 
          caseSensitive: false),
      RegExp(r'(\d{2,3})\s*/\s*(\d{2,3})\s*(?:mmhg)?', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final systolic = int.tryParse(match.group(1)!);
        final diastolic = int.tryParse(match.group(2)!);
        
        // Validate reasonable ranges
        if (systolic != null && diastolic != null &&
            systolic >= 60 && systolic <= 250 &&
            diastolic >= 40 && diastolic <= 150) {
          final bp = '$systolic/$diastolic';
          print('✅ Blood Pressure found: $bp mmHg');
          return bp;
        }
      }
    }
    return null;
  }

  double? extractWeight(String text) {
    final patterns = [
      RegExp(r'(?:weight|body\s+weight)[:\s]*(\d+\.?\d*)\s*(?:kg|kgs)?', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          // Validate reasonable range (20-300 kg)
          if (value >= 20 && value <= 300) {
            print('✅ Weight found: $value kg');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  double? extractHeight(String text) {
    final patterns = [
      RegExp(r'height[:\s]*(\d+\.?\d*)\s*(?:cm|m)?', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          var value = double.parse(match.group(1)!);
          
          if (value < 10) {
            value = value * 100;
          }
          
          // Validate reasonable range (50-250 cm)
          if (value >= 50 && value <= 250) {
            print('✅ Height found: $value cm');
            return value;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  List<String> extractMedications(String text) {
    final medications = <String>[];
    
    final patterns = [
      RegExp(r'(?:medication|medicine|drug|rx)[:\s]*([a-z]+(?:\s+\d+\s*mg)?)', 
          caseSensitive: false),
      RegExp(r'(metformin|insulin|glipizide|glyburide|pioglitazone)(?:\s+\d+\s*mg)?', 
          caseSensitive: false),
      RegExp(r'(aspirin|atorvastatin|lisinopril|amlodipine|metoprolol)(?:\s+\d+\s*mg)?', 
          caseSensitive: false),
      RegExp(r'([A-Z][a-z]+)\s+\d+\s*mg', caseSensitive: true),
    ];

    for (var pattern in patterns) {
      final matches = pattern.allMatches(text);
      for (var match in matches) {
        final med = match.group(1)?.trim();
        if (med != null && med.isNotEmpty && !medications.contains(med)) {
          medications.add(med);
        }
      }
    }

    if (medications.isNotEmpty) {
      print('✅ Medications found: ${medications.join(", ")}');
    }
    
    return medications;
  }

  double? extractTemperature(String text) {
    final patterns = [
      RegExp(r'(?:temperature|temp)[:\s]*(\d+\.?\d*)\s*[°]?[cf]?', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        try {
          final value = double.parse(match.group(1)!);
          
          var celsius = value;
          if (value > 50) {
            celsius = (value - 32) * 5 / 9;
          }
          
          if (celsius >= 30 && celsius <= 45) {
            print('✅ Temperature found: $celsius°C');
            return celsius;
          }
        } catch (e) {
          continue;
        }
      }
    }
    return null;
  }

  String? extractDiagnosis(String text) {
    final patterns = [
      // "Diagnosis: Type 2 Diabetes"
      RegExp(r'diagnosis[:\s]*([^\n]+)', caseSensitive: false),
      // "Condition: Hypertension"
      RegExp(r'condition[:\s]*([^\n]+)', caseSensitive: false),
      // Common conditions
      RegExp(r'(diabetes|hypertension|hyperlipidemia|obesity|anemia)', 
          caseSensitive: false),
    ];

    for (var pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        var diagnosis = match.group(1)?.trim();
        if (diagnosis != null && diagnosis.isNotEmpty) {
          // Clean up diagnosis text
          diagnosis = diagnosis.split('\n')[0].trim();
          if (diagnosis.length > 3) {
            print('✅ Diagnosis found: $diagnosis');
            return diagnosis;
          }
        }
      }
    }
    return null;
  }

  Map<String, dynamic> parseAllMedicalData(String text) {
    print('🔍 Parsing medical data from ${text.length} characters of text...');
    
    final data = <String, dynamic>{
      'bloodSugar': extractBloodSugar(text),
      'spo2': extractSpO2(text),
      'heartRate': extractHeartRate(text),
      'bmi': extractBMI(text),
      'bloodPressure': extractBloodPressure(text),
      'weight': extractWeight(text),
      'height': extractHeight(text),
      'temperature': extractTemperature(text),
      'medications': extractMedications(text),
      'diagnosis': extractDiagnosis(text),
      'parsedAt': DateTime.now(),
    };

    int foundCount = data.values.where((v) {
      if (v is List) return v.isNotEmpty;
      return v != null && v != 'parsedAt';
    }).length;

    print('✅ Parsing complete! Found $foundCount medical values');
    return data;
  }
}