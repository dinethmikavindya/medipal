import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/report_model.dart';
import 'ocr_service.dart';
import 'medical_parser_services.dart';
import 'health_data_services.dart';
import 'ai_analysis_service.dart';
import 'pdf_service.dart';

class UploadReportService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OCRService _ocrService = OCRService();
  final MedicalParserService _parserService = MedicalParserService();
  final HealthDataService _healthService = HealthDataService();
  final AIAnalysisService _aiService = AIAnalysisService();
  final PDFService _pdfService = PDFService(); 

  // ✅ COMPLETE WORKFLOW: Upload → OCR → Parse → AI Analysis → Save
  Future<String?> uploadReport(File imageFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User not logged in';

      final uid = user.uid;
      final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // 1. Upload image to Firebase Storage
      print('⏳ Uploading image to Firebase Storage...');
      final storageRef = _storage
          .ref()
          .child('users')
          .child(uid)
          .child('reports')
          .child(fileName);

      final uploadTask = await storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      print('✅ Image uploaded! URL: $downloadUrl');

      // 2. Run OCR text extraction
      print('🔍 Running OCR text extraction...');
      final extractedText = await _ocrService.extractTextFromImage(imageFile.path);
      
      if (extractedText != null) {
        print('✅ OCR Success! Extracted ${extractedText.length} characters');
        
        // 3. Parse medical data from extracted text
        print('🧠 Parsing medical data...');
        final parsedData = _parserService.parseAllMedicalData(extractedText);
        
        // 4. Run AI analysis on parsed data
        print('🤖 Running AI health analysis...');
        final aiAnalysis = _aiService.analyzeHealthData(parsedData);
        
        // 5. Combine parsed data with AI results
        final completeHealthData = {
          ...parsedData,
          'suggestions': aiAnalysis['suggestions'],
          'riskLevel': aiAnalysis['riskLevel'],
          'healthScore': aiAnalysis['healthScore'],
        };
        
        // 6. Save complete health data to Firestore
        await _healthService.saveHealthSummary(completeHealthData);
        
      } else {
        print('⚠️ OCR found no text');
      }

      // 7. Save report metadata to Firestore
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('records')
          .add({
        'reportUrl': downloadUrl,
        'fileName': fileName,
        'uploadedAt': FieldValue.serverTimestamp(),
        'fileType': 'image/jpeg',
        'uid': uid,
        'extractedText': extractedText,
        'isProcessed': extractedText != null,
      });

      print('✅ Complete! Report uploaded, scanned, parsed, and analyzed!');
      return null; // null = success

    } on FirebaseException catch (e) {
      print('❌ Firebase error: ${e.message}');
      return 'Upload failed: ${e.message}';
    } catch (e) {
      print('❌ Error: $e');
      return 'Error: $e';
    }
  }

  // ✅ Get all reports for current user (real-time stream)
  Stream<List<ReportModel>> getReports() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('records')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ReportModel.fromFirestore(doc))
            .toList());
  }

  // ✅ Delete a report
  Future<void> deleteReport(String reportId, String fileName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Delete from Storage
      await _storage
          .ref()
          .child('users')
          .child(user.uid)
          .child('reports')
          .child(fileName)
          .delete();

      // Delete from Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('records')
          .doc(reportId)
          .delete();

      print('✅ Report deleted!');
    } catch (e) {
      print('❌ Delete error: $e');
    }
  }

  // ✅ Search reports by text content
  Future<List<ReportModel>> searchReports(String query) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('records')
          .get();

      final reports = snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .where((report) {
            if (report.extractedText == null) return false;
            return report.extractedText!
                .toLowerCase()
                .contains(query.toLowerCase());
          })
          .toList();

      return reports;
    } catch (e) {
      print('❌ Search error: $e');
      return [];
    }
  }

  /// Upload and process PDF report
  Future<String?> uploadPDFReport(File pdfFile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return 'User not logged in';

      final uid = user.uid;
      final fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // 1. Upload PDF to Firebase Storage
      print('⏳ Uploading PDF to Firebase Storage...');
      final storageRef = _storage
          .ref()
          .child('users')
          .child(uid)
          .child('reports')
          .child(fileName);

      final uploadTask = await storageRef.putFile(
        pdfFile,
        SettableMetadata(contentType: 'application/pdf'),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();
      print('✅ PDF uploaded! URL: $downloadUrl');

      // 2. Extract text from PDF
      print('📄 Extracting text from PDF...');
      final extractedText = await _pdfService.extractTextFromPDF(pdfFile.path);
      
      if (extractedText != null) {
        print('✅ PDF text extraction success! Extracted ${extractedText.length} characters');
        
        // 3. Parse medical data (same as image)
        print('🧠 Parsing medical data...');
        final parsedData = _parserService.parseAllMedicalData(extractedText);
        
        // 4. Run AI analysis (same as image)
        print('🤖 Running AI health analysis...');
        final aiAnalysis = _aiService.analyzeHealthData(parsedData);
        
        // 5. Combine data
        final completeHealthData = {
          ...parsedData,
          'suggestions': aiAnalysis['suggestions'],
          'riskLevel': aiAnalysis['riskLevel'],
          'healthScore': aiAnalysis['healthScore'],
        };
        
        // 6. Save to Firestore
        await _healthService.saveHealthSummary(completeHealthData);
      } else {
        print('⚠️ No text found in PDF');
      }

      // 7. Save report metadata
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('records')
          .add({
        'reportUrl': downloadUrl,
        'fileName': fileName,
        'uploadedAt': FieldValue.serverTimestamp(),
        'fileType': 'application/pdf',
        'uid': uid,
        'extractedText': extractedText,
        'isProcessed': extractedText != null,
      });

      print('✅ Complete! PDF uploaded, processed, and analyzed!');
      return null; // Success

    } on FirebaseException catch (e) {
      print('❌ Firebase error: ${e.message}');
      return 'Upload failed: ${e.message}';
    } catch (e) {
      print('❌ Error: $e');
      return 'Error: $e';
    }
  }

  // ✅ Clean up
  void dispose() {
    _ocrService.dispose();
  }
}
