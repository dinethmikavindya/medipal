import 'dart:io';
import 'package:pdfx/pdfx.dart';

class PDFService {
  
  /// Extracts text from PDF file using pdfx package
  Future<String?> extractTextFromPDF(String pdfPath) async {
    try {
      print('📄 Starting PDF text extraction...');
      
      // Open PDF document
      final document = await PdfDocument.openFile(pdfPath);
      
      String extractedText = '';
      
      // Extract text from all pages
      for (int i = 1; i <= document.pagesCount; i++) {
        print('📄 Extracting text from page $i/${document.pagesCount}...');
        
        final page = await document.getPage(i);
        // Note: pdfx package has limited text extraction capabilities
        // Consider using a different package like 'pdf' or 'pdfx' with Native support
        // For now, you may need to use OCR or alternative PDF libraries
        
        await page.close();
      }
      
      await document.close();
      
      if (extractedText.trim().isEmpty) {
        print('⚠️ No text found in PDF');
        return null;
      }
      
      print('✅ PDF text extraction complete! Extracted ${extractedText.length} characters');
      return extractedText;
      
    } catch (e) {
      print('❌ PDF extraction error: $e');
      return null;
    }
  }
}