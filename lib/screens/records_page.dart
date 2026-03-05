import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/report_model.dart';
import '../services/upload_report_service.dart';
import '../widgets/upload_bottom_sheet.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  static const Color darkTeal = Color(0xFF016274);
  static const Color primaryYellow = Color(0xFFEAFE63);
  static const Color lightBlue = Color(0xFFEAF7FB);

  void _showUploadSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final UploadReportService service = UploadReportService();

    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: darkTeal,
        elevation: 0,
        title: Text(
          'My Records',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _showUploadSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: primaryYellow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.upload_rounded, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      'Upload',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => _showUploadSheet(context),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: darkTeal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: primaryYellow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 28, color: Colors.black),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Your Report',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'AI will automatically scan & extract data',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 18),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Uploaded Reports',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: StreamBuilder<List<ReportModel>>(
              stream: service.getReports(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: darkTeal),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Error loading reports',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                }

                final reports = snapshot.data ?? [];
                if (reports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.folder_open_rounded, size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No reports uploaded yet',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the upload button to add your\nfirst medical report',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black38,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showUploadSheet(context),
                          icon: const Icon(Icons.upload_rounded),
                          label: Text(
                            'Upload Report',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkTeal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final report = reports[index];
                    return _ReportCard(
                      report: report,
                      service: service,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Stateful Report Card with Expandable Text
class _ReportCard extends StatefulWidget {
  final ReportModel report;
  final UploadReportService service;

  const _ReportCard({
    required this.report,
    required this.service,
  });

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> {
  bool _isExpanded = false;

  static const Color darkTeal = Color(0xFF016274);
  static const Color primaryYellow = Color(0xFFEAFE63);

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy').format(widget.report.uploadedAt);
    final formattedTime = DateFormat('hh:mm a').format(widget.report.uploadedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Main Card Content
          GestureDetector(
            onTap: () => _viewReport(context),
            child: Row(
              children: [
                // Thumbnail
// Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    bottomLeft: _isExpanded ? Radius.circular(0) : const Radius.circular(18),
                  ),
                  child: widget.report.fileType == 'application/pdf'
                      ? Container(
                          width: 100,
                          height: 100,
                          color: Colors.red[50],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.picture_as_pdf_rounded,
                                size: 40,
                                color: Colors.red[700],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'PDF',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red[700],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.network(
                          widget.report.reportUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: darkTeal,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported_rounded, color: Colors.grey),
                          ),
                        ),
                ),

                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: darkTeal.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Medical Report',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: darkTeal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // ✅ OCR Status Badge
                            if (widget.report.isProcessed)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, size: 10, color: Colors.green),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Scanned',
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 12, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              formattedTime,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions Column
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      // ✅ View Extracted Text Button
                      if (widget.report.extractedText != null)
                        GestureDetector(
                          onTap: () => setState(() => _isExpanded = !_isExpanded),
                          child: Container(
                            width: 34,
                            height: 34,
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: primaryYellow.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _isExpanded ? Icons.keyboard_arrow_up : Icons.description_outlined,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      // Delete Button
                      GestureDetector(
                        onTap: () => _confirmDelete(context),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ✅ Expandable Extracted Text Section
          if (_isExpanded && widget.report.extractedText != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.text_fields_rounded, size: 16, color: darkTeal),
                          const SizedBox(width: 6),
                          Text(
                            'Extracted Text',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      // Copy Button
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: widget.report.extractedText!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Text copied to clipboard',
                                style: GoogleFonts.poppins(),
                              ),
                              backgroundColor: darkTeal,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: darkTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 12, color: darkTeal),
                              const SizedBox(width: 4),
                              Text(
                                'Copy',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: darkTeal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      widget.report.extractedText!,
                      style: GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _viewReport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ReportViewPage(report: widget.report),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Delete Report?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w900),
        ),
        content: Text(
          'This report will be permanently deleted.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await widget.service.deleteReport(widget.report.id, widget.report.fileName);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Report deleted', style: GoogleFonts.poppins()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Full Screen Report Viewer
class _ReportViewPage extends StatelessWidget {
  final ReportModel report;
  const _ReportViewPage({required this.report});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM dd, yyyy – hh:mm a').format(report.uploadedAt);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Report',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              formattedDate,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            report.reportUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            },
          ),
        ),
      ),
    );
  }
}