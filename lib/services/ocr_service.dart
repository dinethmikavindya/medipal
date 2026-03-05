import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
class OCRService {
final TextRecognizer _textRecognizer = TextRecognizer();
// ✅ Extract text from image using Google ML Kit
Future<String?> extractTextFromImage(String imagePath) async {
try {
print('📸 Starting OCR on: $imagePath');
final inputImage = InputImage.fromFilePath(imagePath);
// Process image with ML Kit
final RecognizedText recognizedText = 
await _textRecognizer.processImage(inputImage);
// Get all extracted text
final extractedText = recognizedText.text;
if (extractedText.isEmpty) {
print('⚠️ No text found in image');
return null;
      }
print('✅ OCR Complete! Extracted ${extractedText.length} characters');
print('📝 Preview: ${extractedText.substring(0, extractedText.length > 100 ? 100 : extractedText.length)}...');
return extractedText;
    } catch (e) {
print('❌ OCR Error: $e');
return null;
    }
  }
// ✅ Get structured blocks (for advanced parsing in Phase 3)
Future<List<TextBlock>> extractTextBlocks(String imagePath) async {
try {
final inputImage = InputImage.fromFilePath(imagePath);
final RecognizedText recognizedText = 
await _textRecognizer.processImage(inputImage);
return recognizedText.blocks;
    } catch (e) {
print('❌ Error extracting blocks: $e');
return [];
    }
  }
// ✅ Clean up resources
void dispose() {
_textRecognizer.close();
  }
// ✅ Search for specific keywords in extracted text
bool containsKeyword(String text, String keyword) {
return text.toLowerCase().contains(keyword.toLowerCase());
  }
// ✅ Find all lines containing a keyword
List<String> findLinesWithKeyword(String text, String keyword) {
final lines = text.split('\n');
return lines
        .where((line) => line.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}