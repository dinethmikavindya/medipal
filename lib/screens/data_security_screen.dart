import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataSecurityScreen extends StatefulWidget {
  const DataSecurityScreen({super.key});

  @override
  State<DataSecurityScreen> createState() => _DataSecurityScreenState();
}

class _DataSecurityScreenState extends State<DataSecurityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward();

    // Wait 10 seconds then go to Home page
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFEAFE63);
    const Color darkTeal = Color(0xFF016274);
    const Color lightBlue = Color(0xFFEAF7FB);

    return Scaffold(
      backgroundColor: lightBlue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lightBlue,
              Colors.white,
              lightBlue.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lock Icon with Yellow Circle
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryYellow.withOpacity(0.5),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: darkTeal.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.shield_outlined,
                            size: 70,
                            color: darkTeal,
                          ),
                        ),

                        SizedBox(height: 50),

                        // Main Content Card
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 32),
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Title
                              Text(
                                "Your Medical Data\nIs Protected",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  color: darkTeal,
                                  height: 1.3,
                                ),
                              ),

                              SizedBox(height: 24),

                              // Security Features
                              _buildSecurityFeature(
                                icon: Icons.lock_outline,
                                text: "Securely encrypted storage",
                                color: darkTeal,
                              ),
                              SizedBox(height: 16),
                              _buildSecurityFeature(
                                icon: Icons.verified_user_outlined,
                                text: "Only you can access your data",
                                color: darkTeal,
                              ),
                              SizedBox(height: 16),
                              _buildSecurityFeature(
                                icon: Icons.people_outline,
                                text: "Caregiver access with approval",
                                color: darkTeal,
                              ),

                              SizedBox(height: 32),

                              // Loading Progress
                              Column(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      valueColor: AlwaysStoppedAnimation<Color>(darkTeal),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    "Setting up your secure space...",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40),

                        // MEDIPAL Branding
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Powered by ",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "MEDIPAL",
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: darkTeal,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityFeature({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFEAFE63).withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 22,
            color: color,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}