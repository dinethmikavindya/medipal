import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotePage extends StatelessWidget {
  const NotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF016274),
      ),
      body: Center(
        child: Text(
          'Notes Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}