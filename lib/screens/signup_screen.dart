import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/widgets/background_vedio.dart';

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
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
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
                      hintText: "",
                      obscureText: true,
                    ),
                    SizedBox(height: 24),
                    // NEXT Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Navigate to BMI screen
                            Navigator.pushNamed(context, '/bmi');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: darkColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          shadowColor: primaryColor.withOpacity(0.5),
                        ),
                        child: Text(
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
          return null;
        },
      ),
    );
  }
}