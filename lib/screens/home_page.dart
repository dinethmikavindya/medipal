import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/upload_bottom_sheet.dart';
import '../services/health_data_services.dart';   
import '../models/health_summary_model.dart';  
import 'package:medipal1/config/keys.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {  
  int _selectedIndex = 2;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousIndex = 2;
  final HealthDataService _healthService = HealthDataService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double _getIconPosition(int index) {
    final width = MediaQuery.of(context).size.width;
    final spacing = width / 5;
    return spacing * index + spacing / 2;
  }

  void _onNavBarTap(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _previousIndex = _selectedIndex;
      _selectedIndex = index;
    });

    _animationController.forward(from: 0);

    Future.delayed(Duration(milliseconds: 300), () {
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/notes');
          break;
        case 1:
          Navigator.pushNamed(context, '/reminders');
          break;
        case 2:
          // Stay on home
          break;
        case 3:
          Navigator.pushNamed(context, '/records');
          break;
        case 4:
          Navigator.pushNamed(context, '/settings');
          break;
      }
    });
  }

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const UploadBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryYellow = Color(0xFFEAFE63);
    const Color darkTeal = Color(0xFF016274);
    const Color lightBlue = Color(0xFFEAF7FB);
    const Color lightGrey = Color(0xFFE3E3E3);

    return Scaffold(
      backgroundColor: lightBlue,
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "MEDIPAL",
                            style: GoogleFonts.montserrat(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/profile'),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: darkTeal,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Hello Card with Water Splash Image
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          // Water Splash Image (Right Side)
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            width: 140,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1548933122-8739b8e4b9cc?w=300',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WEDNESDAY, OCTOBER 30 2025",
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      "HELLO\n",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: primaryYellow),
                                      child: Text(
                                        "DINETHMI!",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  "Your Health Overview",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildMiniCard("40%", "💧", darkTeal),
                                    SizedBox(width: 8),
                                    _buildMiniCard("365\nC°", "☀️", primaryYellow),
                                    SizedBox(width: 8),
                                    _buildMiniCard("120/80", "🩺", lightGrey),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Health Metrics Grid (2x2) - REAL DATA
                    StreamBuilder<HealthSummaryModel?>(
                      stream: _healthService.getHealthSummary(),
                      builder: (context, snapshot) {
                        final health = snapshot.data;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildHealthCard(
                                      "BMI",
                                      health?.bmi != null 
                                          ? health!.bmi!.toStringAsFixed(1)
                                          : "--",
                                      "🎯",
                                      Color(0xFFFFD54F),
                                    ),
                                    SizedBox(height: 12),
                                    _buildHealthCard(
                                      "Blood Sugar",
                                      health?.bloodSugar != null
                                          ? "${health!.bloodSugar!.toStringAsFixed(0)} mg/dL"
                                          : "-- mg/dL",
                                      "🩸",
                                      Color(0xFF4DB6AC),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  children: [
                                    _buildHealthCard(
                                      "Heart Rate",
                                      health?.heartRate != null
                                          ? "${health!.heartRate!.toStringAsFixed(0)} bpm"
                                          : "-- bpm",
                                      "❤️",
                                      Color(0xFF4DB6AC),
                                    ),
                                    SizedBox(height: 12),
                                    _buildHealthCard(
                                      "SpO2 Level",
                                      health?.spo2 != null
                                          ? "${health!.spo2!.toStringAsFixed(0)}%"
                                          : "--%",
                                      "🫁",
                                      lightBlue,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    // AI Suggestion + Progress Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // AI Suggestion Card
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                image: DecorationImage(
                                  image: NetworkImage('https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600'),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(14),
                                child: StreamBuilder<HealthSummaryModel?>(
                                  stream: _healthService.getHealthSummary(),
                                  builder: (context, snapshot) {
                                    final health = snapshot.data;
                                    final suggestions = health?.suggestions;
                                    
                                    String displayText;
                                    if (suggestions != null && suggestions.isNotEmpty) {
                                      displayText = suggestions.first;
                                    } else {
                                      displayText = "Upload medical reports to get AI-powered health insights!";
                                    }
                                    
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.tips_and_updates, color: Colors.white, size: 20),
                                            SizedBox(width: 6),
                                            Text(
                                              "AI Suggestions",
                                              style: GoogleFonts.poppins(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white70,
                                              ),
                                            ),
                                            if (health?.riskLevel != null) ...[
                                              SizedBox(width: 6),
                                              Text(
                                                HealthSummaryModel.getRiskEmoji(health?.riskLevel),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ],
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          displayText,
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            height: 1.2,
                                          ),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          // Progress Card
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 120,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: primaryYellow, width: 2),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "86%",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                      color: darkTeal,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Your Doing\nAmazing!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // Hydration Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 80,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        decoration: BoxDecoration(
                          color: darkTeal,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.water_drop, color: primaryYellow, size: 28),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Hydration!",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "60% to go",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Map Section + Notifications
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(
  'https://api.mapbox.com/styles/v1/mapbox/light-v10/static/79.8612,6.9271,12,0/600x400@2x?access_token=${AppKeys.mapboxToken}'
),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Doctor Recommendation
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Doctor\nRecommendation",
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "• Nalanda Hospital (2km)\n• MediCare Clinic (5km)",
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        color: Colors.black87,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Skin Rash Alert
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryYellow,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Skin rash",
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      "Dr. Sarah's dermatologist\nclinic (4km away)",
                                      style: GoogleFonts.poppins(
                                        fontSize: 8,
                                        color: Colors.black87,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Hospital Marker
                            Positioned(
                              bottom: 50,
                              right: 100,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.local_hospital, size: 16, color: Colors.red),
                                    SizedBox(width: 6),
                                    Text(
                                      "Get to near by hospital",
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Report History
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Report history 📋",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Report Cards Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: primaryYellow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.auto_awesome, size: 32),
                                  SizedBox(height: 8),
                                  Text(
                                    "Generate\nHealth Report",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
        
Expanded(
  child: GestureDetector(
    onTap: _showUploadSheet, 
    child: Container(
      height: 130,
      decoration: BoxDecoration(
        color: darkTeal,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, color: primaryYellow, size: 32),
          SizedBox(height: 8),
          Text(
            "Upload your\nreport here",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
        ],
      ),
    ),
  ),
),
                        ],
                      ),
                    ),

                    SizedBox(height: 12),

                    // Reminders & AI Insights
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "Reminders",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "AI Insights",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Today's Plan
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primaryYellow, width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TODAY'S PLAN",
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(height: 16),
                          _buildPlanItem("9:00AM", "Morning Pills", "☀️"),
                          _buildPlanItem("10:00AM", "BP Check", "☀️"),
                          _buildPlanItem("18:00PM", "Mandala Art", "🔥"),
                          _buildPlanItem("20:00PM", "Night Pills", "🌙"),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Emergency Contact
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5252),
                          minimumSize: Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.phone_in_talk, color: Colors.white),
                            SizedBox(width: 10),
                            Text(
                              "Emergency Contact",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Animated Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: darkTeal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Animated Yellow Circle
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final startPos = _getIconPosition(_previousIndex);
                      final endPos = _getIconPosition(_selectedIndex);
                      final currentPos = startPos + (endPos - startPos) * _animation.value;

                      return Positioned(
                        left: currentPos - 32,
                        top: 7.5,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: primaryYellow,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryYellow.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // Navigation Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildNavIcon(Icons.edit_note_outlined, 0),
                      _buildNavIcon(Icons.alarm_add_outlined, 1),
                      _buildNavIcon(Icons.home_outlined, 2),
                      _buildNavIcon(Icons.folder_outlined, 3),
                      _buildNavIcon(Icons.settings_outlined, 4),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(String value, String emoji, Color color) {
    return Expanded(
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: 20)),
            SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCard(String title, String value, String icon, Color borderColor) {
    return Container(
      height: 130,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: TextStyle(fontSize: 20)),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(String time, String task, String icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(icon, style: TextStyle(fontSize: 18)),
          SizedBox(width: 10),
          Text(
            time,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          SizedBox(width: 6),
          Text(
            "| $task",
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Color(0xFFEAFE63),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check, size: 18),
          ),
          SizedBox(width: 6),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavBarTap(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        height: 75,
        child: Center(
          child: AnimatedScale(
            scale: isSelected ? 1.1 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: isSelected ? Color(0xFF016274) : Colors.white.withOpacity(0.7),
              size: isSelected ? 30 : 26,
            ),
          ),
        ),
      ),
    );
  }
}