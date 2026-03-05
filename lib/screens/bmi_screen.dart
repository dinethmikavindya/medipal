import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/widgets/background_vedio.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _isLoading = false;
  bool _isSignUpFlow = true; 

  @override
  void initState() {
    super.initState();
    _checkFlow();
  }

  Future<void> _checkFlow() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        if (mounted) {
          setState(() {
            _isSignUpFlow = data['bmi'] == null;
          });
        }
      }
    } catch (e) {
      print('❌ Error checking flow: $e');
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Overweight';
    return 'Obese';
  }

  Future<void> _calculateBMI() async {
    if (!_formKey.currentState!.validate()) return;

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || height <= 0) return;

    setState(() => _isLoading = true);

    final bmi = weight / ((height / 100) * (height / 100));
    final bmiCategory = _getBMICategory(bmi);

    print('🔵 BMI calculated: ${bmi.toStringAsFixed(1)} - Category: $bmiCategory');

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'height': height,
          'weight': weight,
          'bmi': double.parse(bmi.toStringAsFixed(1)),
          'bmiCategory': bmiCategory,
        });
        print('✅ BMI data saved to Firestore');
      }

      setState(() => _isLoading = false);
      if (!mounted) return;

      if (_isSignUpFlow) {
        // Sign up flow: BMI → Medical Detail → Home
        print('🔵 Sign up flow: navigating to Medical Detail');
        Navigator.pushNamed(
          context,
          '/medical',
          arguments: {'bmi': bmi.toStringAsFixed(1), 'bmiCategory': bmiCategory},
        );
      } else {
        // From Profile: just pop back to Profile
        print('🔵 Profile flow: popping back to Profile');
        Navigator.pop(context);
      }
    } catch (e) {
      print('❌ Error saving BMI: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save BMI: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _skipBMI() async {
    if (_isSignUpFlow) {
      // Sign up flow: skip BMI, go to Medical Detail
      Navigator.pushNamed(context, '/medical');
    } else {
      // From Profile: just go back
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFEAFE63);
    const Color darkColor = Color(0xFF016274);
    const Color whiteColor = Colors.white;

    return Scaffold(
      body: BackgroundVideo(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // MEDIPAL Logo
                  Center(
                    child: Text(
                      "MEDIPAL",
                      style: GoogleFonts.montserrat(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: whiteColor,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  // Heading
                  Text(
                    "Add your height &\nweight to calculate\nBMI.",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  // Height
                  Text(
                    "Height",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    controller: _heightController,
                    hintText: "cm",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24),
                  // Weight
                  Text(
                    "Weight",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: whiteColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    controller: _weightController,
                    hintText: "kg",
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 40),
                  // GET BMI Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _calculateBMI,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: darkColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        shadowColor: primaryColor.withOpacity(0.5),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(darkColor),
                              ),
                            )
                          : Text(
                              "GET BMI",
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Maybe Later / Back button
                  Center(
                    child: TextButton(
                      onPressed: _skipBMI,
                      child: Text(
                        _isSignUpFlow ? "Maybe Later" : "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: whiteColor.withOpacity(0.9),
                          decoration: TextDecoration.underline,
                          decorationColor: whiteColor.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.7),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.6),
            fontSize: 15,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }
}