import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Fade in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Scale animation with bounce
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    // Pulse animation for glow effect
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animation
    _animationController.forward();

    // Wait 3 seconds then navigate to choice screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/choice');
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define custom colors based on your theme
    const Color primaryColor = Color(0xFFEAFE63); // light yellow
    const Color accentColor = Color(0xFFEAF7FB); // light blue
    const Color darkColor = Color(0xFF016274); // dark teal
    const Color whiteColor = Colors.white;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accentColor.withOpacity(0.4),
              whiteColor,
              accentColor.withOpacity(0.2),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated logo with yellow glow
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primaryColor,
                                primaryColor.withOpacity(0.85),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                              BoxShadow(
                                color: accentColor.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.favorite_rounded,
                            size: 85,
                            color: darkColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),
                    // Bold MEDIPAL text with yellow stroke
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Stack(
                        children: [
                          // Yellow stroke effect
                          Text(
                            "MEDIPAL",
                            style: GoogleFonts.montserrat(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 10
                                ..color = primaryColor,
                              letterSpacing: 4,
                            ),
                          ),
                          // Main dark teal text
                          Text(
                            "MEDIPAL",
                            style: GoogleFonts.montserrat(
                              fontSize: 52,
                              fontWeight: FontWeight.w900,
                              color: darkColor,
                              letterSpacing: 4,
                              shadows: [
                                Shadow(
                                  color: primaryColor.withOpacity(0.5),
                                  offset: const Offset(0, 5),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Tagline
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(
                          color: whiteColor.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: accentColor.withOpacity(0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "Your Health Companion",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: darkColor,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}