import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
        backgroundColor: Color(0xFF016274),
      ),
      body: Center(
        child: Text(
          'Profile Page',
          style: GoogleFonts.poppins(fontSize: 24),
        ),
      ),
    );
  }
}