import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Records', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF016274),
      ),
      body: Center(
        child: Text(
          'Records Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}