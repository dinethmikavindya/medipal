import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF016274),
      ),
      body: Center(
        child: Text(
          'Settings Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}