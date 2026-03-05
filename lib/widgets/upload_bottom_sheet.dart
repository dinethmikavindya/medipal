import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../services/upload_report_service.dart';
import 'package:file_picker/file_picker.dart';

class UploadBottomSheet extends StatefulWidget {
  const UploadBottomSheet({super.key});

  @override
  State<UploadBottomSheet> createState() => _UploadBottomSheetState();
}

class _UploadBottomSheetState extends State<UploadBottomSheet> {
  final ImagePicker _picker = ImagePicker();
  final UploadReportService _uploadService = UploadReportService();
  bool _isUploading = false;

  static const Color darkTeal = Color(0xFF016274);
  static const Color primaryYellow = Color(0xFFEAFE63);

  // ✅ EXISTING: Pick Image (Camera/Gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85, 
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (pickedFile == null) return; // User cancelled

      setState(() => _isUploading = true);

      // Upload to Firebase
      final File imageFile = File(pickedFile.path);
      final String? error = await _uploadService.uploadReport(imageFile);

      setState(() => _isUploading = false);

      if (!mounted) return;

      if (error == null) {
        // ✅ SUCCESS
        Navigator.pop(context); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Report uploaded successfully!',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: darkTeal,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // ❌ ERROR
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ✅ NEW: Pick PDF
  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.single.path == null) {
        return; // User cancelled
      }

      setState(() => _isUploading = true);

      // Upload PDF to Firebase
      final File pdfFile = File(result.files.single.path!);
      final String? error = await _uploadService.uploadPDFReport(pdfFile);

      setState(() => _isUploading = false);

      if (!mounted) return;

      if (error == null) {
        // ✅ SUCCESS
        Navigator.pop(context); // Close bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'PDF uploaded successfully!',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: darkTeal,
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        // ❌ ERROR
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Upload Medical Report',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how you want to upload your report',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 28),

          // Show loading or options
          if (_isUploading) ...[
            const SizedBox(height: 20),
            CircularProgressIndicator(color: darkTeal),
            const SizedBox(height: 16),
            Text(
              'Uploading your report...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: darkTeal,
              ),
            ),
            const SizedBox(height: 20),
          ] else ...[
            // Camera Option
            _buildOption(
              icon: Icons.camera_alt_rounded,
              title: 'Take Photo',
              subtitle: 'Use camera to capture report',
              color: darkTeal,
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 14),

            // Gallery Option
            _buildOption(
              icon: Icons.photo_library_rounded,
              title: 'Upload from Gallery',
              subtitle: 'Choose from your photo library',
              color: const Color(0xFF4DB6AC),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 14),
            
            // ✅ NEW: PDF Option
            _buildOption(
              icon: Icons.picture_as_pdf_rounded,
              title: 'Upload PDF',
              subtitle: 'Select PDF document',
              color: Colors.red.shade400,
              onTap: () => _pickPDF(),
            ),
            const SizedBox(height: 14),
            
            // Cancel Button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ),
          ],

          // Bottom safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
