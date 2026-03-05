import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/widgets/background_vedio.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); 

  final _authService = AuthService(); 
  String _selectedRole = 'patient';
  bool _isLoading = false; 

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _emailController.dispose(); 
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFEAFE63),
              onPrimary: Color(0xFF016274),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _showGenderPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Male', style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Male';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Female', style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Female';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Other', style: GoogleFonts.poppins()),
                onTap: () {
                  setState(() {
                    _genderController.text = 'Other';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

// NEW - Handle Firebase Sign Up
// NEW - Handle Firebase Sign Up
Future<void> _handleSignUp() async {
  if (!_formKey.currentState!.validate()) {
    print('❌ Form validation failed');
    return;
  }

  // Check password match
  if (_passwordController.text != _confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  print('🔵 Starting sign up process...');
  print('🔵 Selected role: $_selectedRole');
  setState(() => _isLoading = true);

  // Create full name
  String fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

  try {
    // Call Firebase Sign Up
    String? error = await _authService.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      name: fullName,
      role: _selectedRole,
    );

    setState(() => _isLoading = false);

    if (!mounted) {
      print('⚠️ Widget not mounted');
      return;
    }

    if (error == null) {
      print('✅ Sign up successful! Role: $_selectedRole');
      
      // SUCCESS - Navigate based on role
      if (_selectedRole == 'patient') {
        print('✅ PATIENT → Navigating to BMI screen...');
        Navigator.pushReplacementNamed(context, '/bmi');
      } else if (_selectedRole == 'caregiver') {
        print('✅ CAREGIVER → Navigating to Link Patient screen...');
        Navigator.pushReplacementNamed(context, '/linkPatient');
      }
      
    } else {
      print('❌ Sign up error: $error');
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  } catch (e) {
    print('❌ Unexpected error in _handleSignUp: $e');
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    // MEDIPAL Logo
                    Center(
                      child: Text(
                        "MEDIPAL",
                        style: GoogleFonts.montserrat(
                          fontSize: 26,
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
                    SizedBox(height: 20),
                    // SIGN UP heading
                    Text(
                      "SIGN UP",
                      style: GoogleFonts.montserrat(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: whiteColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    // First Name
                    Text(
                      "First Name",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _firstNameController,
                      hintText: "",
                    ),
                    SizedBox(height: 12),
                    // Last Name
                    Text(
                      "Last Name",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _lastNameController,
                      hintText: "",
                    ),
                    SizedBox(height: 12),

                    // NEW - Email Field
                    Text(
                      "Email",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _emailController,
                      hintText: "example@email.com",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 12),

                    // Phone Number
                    Text(
                      "Phone Number",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: "+94",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 12),
                    // Date of Birth
                    Text(
                      "Date of Birth",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _dobController,
                      hintText: "",
                      readOnly: true,
                      suffixIcon: Icon(Icons.calendar_today, color: whiteColor.withOpacity(0.7), size: 18),
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 12),
                    // Gender
                    Text(
                      "Gender",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _genderController,
                      hintText: "",
                      readOnly: true,
                      onTap: () => _showGenderPicker(context),
                    ),
                    SizedBox(height: 12),

                    // NEW - Role Selection (Patient or Caregiver)
                    Text(
                      "I am a:",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.7),
                          width: 2,
                        ),
                        color: Colors.white.withOpacity(0.18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(
                              'Patient',
                              style: GoogleFonts.poppins(
                                color: whiteColor,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              'Managing my own health',
                              style: GoogleFonts.poppins(
                                color: whiteColor.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            value: 'patient',
                            groupValue: _selectedRole,
                            onChanged: (value) => setState(() => _selectedRole = value!),
                            activeColor: primaryColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            title: Text(
                              'Caregiver',
                              style: GoogleFonts.poppins(
                                color: whiteColor,
                                fontSize: 13,
                              ),
                            ),
                            subtitle: Text(
                              'Helping someone manage their health',
                              style: GoogleFonts.poppins(
                                color: whiteColor.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                            value: 'caregiver',
                            groupValue: _selectedRole,
                            onChanged: (value) => setState(() => _selectedRole = value!),
                            activeColor: primaryColor,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),

                    // Password
                    Text(
                      "Password",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Minimum 6 characters",
                      obscureText: true,
                    ),
                    SizedBox(height: 12),

                    // NEW - Confirm Password
                    Text(
                      "Confirm Password",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: "Re-enter password",
                      obscureText: true,
                    ),
                    SizedBox(height: 24),

                    // NEXT Button (UPDATED with Firebase handling)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp, // UPDATED
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: darkColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: primaryColor.withOpacity(0.5),
                        ),
                        child: _isLoading // NEW - Show loading indicator
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(darkColor),
                                ),
                              )
                            : Text(
                                "NEXT",
                                style: GoogleFonts.montserrat(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // NEW - Sign In Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(
                              color: whiteColor,
                              fontSize: 13,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/signin'),
                            child: Text(
                              "Sign In",
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // After the "Sign In" row, add:

const SizedBox(height: 30),
const Divider(color: Colors.white),
const SizedBox(height: 20),

// TEST BUTTONS
Column(
  children: [
    // Test 1: Navigation Only
    ElevatedButton(
      onPressed: () {
        print('🧪 TEST 1: Direct navigation to BMI');
        Navigator.pushReplacementNamed(context, '/bmi');
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      child: const Text('TEST 1: Navigate to BMI'),
    ),
    
    const SizedBox(height: 10),
    
    // Test 2: Firestore Write Only
    ElevatedButton(
      onPressed: () async {
        print('🧪 TEST 2: Firestore write test');
        try {
          String testUid = DateTime.now().millisecondsSinceEpoch.toString();
          
          await FirebaseFirestore.instance
              .collection('users')
              .doc(testUid)
              .set({
            'uid': testUid,
            'name': 'Test User',
            'email': 'test@test.com',
            'role': 'patient',
            'createdAt': FieldValue.serverTimestamp(),
            'linkedPatients': [],
            'linkedCaregivers': [],
          }).timeout(const Duration(seconds: 10));
          
          print('✅ Firestore write SUCCESS');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Firestore write successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          print('❌ Firestore write FAILED: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
      child: const Text('TEST 2: Firestore Write'),
    ),
    
    const SizedBox(height: 10),
    
    // Test 3: Full Sign Up Without Navigation
    ElevatedButton(
      onPressed: () async {
        print('🧪 TEST 3: Sign up without navigation');
        
        String testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@test.com';
        
        setState(() => _isLoading = true);
        
        String? error = await _authService.signUp(
          email: testEmail,
          password: 'test123',
          name: 'Test User',
          role: 'patient',
        );
        
        setState(() => _isLoading = false);
        
        if (error == null) {
          print('✅ Sign up SUCCESS (no navigation)');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Sign up successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('❌ Sign up FAILED: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ $error'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
      child: const Text('TEST 3: Sign Up (No Nav)'),
    ),
  ],
),
                  ],
                ),
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
    bool obscureText = false,
    bool readOnly = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    VoidCallback? onTap,
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
        obscureText: obscureText,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onTap: onTap,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          suffixIcon: suffixIcon,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          // Additional email validation
          if (controller == _emailController && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          // Password length validation
          if (controller == _passwordController && value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }
}
