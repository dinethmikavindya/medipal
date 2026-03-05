import 'package:cloud_firestore/cloud_firestore.dart';
class ReportModel {
final String id;
final String reportUrl;
final String fileName;
final DateTime uploadedAt;
final String fileType;
final String uid;
final String? extractedText; 
final bool isProcessed;      
ReportModel({
required this.id,
required this.reportUrl,
required this.fileName,
required this.uploadedAt,
required this.fileType,
required this.uid,
this.extractedText,
this.isProcessed = false,
  });
// Convert Firestore document → ReportModel
factory ReportModel.fromFirestore(DocumentSnapshot doc) {
Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
return ReportModel(
id: doc.id,
reportUrl: data['reportUrl'] ?? '',
fileName: data['fileName'] ?? '',
uploadedAt: (data['uploadedAt'] as Timestamp).toDate(),
fileType: data['fileType'] ?? 'image',
uid: data['uid'] ?? '',
extractedText: data['extractedText'],
isProcessed: data['isProcessed'] ?? false,
    );
  }
// Convert ReportModel → Map for Firestore
Map<String, dynamic> toMap() {
return {
'reportUrl': reportUrl,
'fileName': fileName,
'uploadedAt': Timestamp.fromDate(uploadedAt),
'fileType': fileType,
'uid': uid,
'extractedText': extractedText,
'isProcessed': isProcessed,
    };
  }
ReportModel copyWith({
String? id,
String? reportUrl,
String? fileName,
DateTime? uploadedAt,
String? fileType,
String? uid,
String? extractedText,
bool? isProcessed,
  }) {
return ReportModel(
id: id ?? this.id,
reportUrl: reportUrl ?? this.reportUrl,
fileName: fileName ?? this.fileName,
uploadedAt: uploadedAt ?? this.uploadedAt,
fileType: fileType ?? this.fileType,
uid: uid ?? this.uid,
extractedText: extractedText ?? this.extractedText,
isProcessed: isProcessed ?? this.isProcessed,
    );
  }
}