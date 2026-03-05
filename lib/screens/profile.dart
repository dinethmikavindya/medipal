import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _userData = doc.data();
          _isLoading = false;
        });
        print('✅ User data loaded: $_userData');
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Color _getBMIColor(String category) {
    switch (category) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getBMIIcon(String category) {
    switch (category) {
      case 'Underweight':
        return Icons.arrow_downward;
      case 'Normal':
        return Icons.check_circle;
      case 'Overweight':
        return Icons.arrow_upward;
      case 'Obese':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFEAFE63);
    const Color darkColor = Color(0xFF016274);

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text('Profile',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
          backgroundColor: darkColor,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final name = _userData?['name'] ?? 'Unknown';
    final email = _userData?['email'] ?? '';
    final role = _userData?['role'] ?? 'patient';
    final height = _userData?['height'];
    final weight = _userData?['weight'];
    final bmi = _userData?['bmi'];
    final bmiCategory = _userData?['bmiCategory'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w900)),
        backgroundColor: darkColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Profile Header Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: darkColor,
                      border: Border.all(color: primaryColor, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                        style: GoogleFonts.montserrat(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name
                  Text(
                    name,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: darkColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Role badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: role == 'caregiver'
                          ? Colors.purple.withOpacity(0.1)
                          : darkColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role == 'caregiver' ? '🩺 Caregiver' : '🏥 Patient',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color:
                            role == 'caregiver' ? Colors.purple : darkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // --- BMI Card ---
            if (bmi != null) ...[
              Text(
                'BMI Overview',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // BMI Circle
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getBMIColor(bmiCategory).withOpacity(0.1),
                        border: Border.all(
                          color: _getBMIColor(bmiCategory),
                          width: 4,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$bmi',
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: _getBMIColor(bmiCategory),
                            ),
                          ),
                          Text(
                            'BMI',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Category badge
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getBMIColor(bmiCategory).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getBMIIcon(bmiCategory),
                            color: _getBMIColor(bmiCategory),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            bmiCategory,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _getBMIColor(bmiCategory),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // BMI Scale Bar
                    _buildBMIScaleBar(bmi),
                    const SizedBox(height: 16),
                    // Update BMI button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/bmi');
                          // Reload data after coming back
                          _loadUserData();
                        },
                        icon: const Icon(Icons.edit, size: 18),
                        label: Text(
                          'Update BMI',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkColor,
                          side: BorderSide(color: darkColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // --- Height & Weight Cards ---
            if (height != null && weight != null) ...[
              Text(
                'Body Measurements',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Height
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.height, color: Color(0xFF016274),
                              size: 28),
                          const SizedBox(height: 8),
                          Text(
                            '$height',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: darkColor,
                            ),
                          ),
                          Text(
                            'cm',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Height',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Weight
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.monitor_weight,
                              color: Color(0xFF016274), size: 28),
                          const SizedBox(height: 8),
                          Text(
                            '$weight',
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: darkColor,
                            ),
                          ),
                          Text(
                            'kg',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Weight',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],

            // --- No BMI data yet ---
            if (bmi == null) ...[
              Text(
                'BMI Overview',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: darkColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.grey, size: 44),
                    const SizedBox(height: 12),
                    Text(
                      'No BMI data yet',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Add your height and weight to calculate and see your BMI here',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    // Add BMI button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/bmi');
                          // Reload after coming back from BMI
                          _loadUserData();
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        label: Text(
                          'Add BMI Now',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // BMI scale bar
  Widget _buildBMIScaleBar(double bmi) {
    final clampedBmi = bmi.clamp(10.0, 40.0);
    final position = (clampedBmi - 10.0) / 30.0;

    return Column(
      children: [
        // Gradient bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: double.infinity,
            height: 12,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green, Colors.orange, Colors.red],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Pointer
        Row(
          children: [
            SizedBox(
                width:
                    (MediaQuery.of(context).size.width - 40) * position - 10),
            const Icon(Icons.arrow_drop_up, color: Colors.black54, size: 22),
          ],
        ),
        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('10',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            Text('18.5',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            Text('25',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            Text('30',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
            Text('40',
                style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
