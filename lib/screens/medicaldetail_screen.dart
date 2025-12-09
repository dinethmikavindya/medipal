import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/widgets/background_vedio.dart';

class MedicalDetailScreen extends StatefulWidget {
  const MedicalDetailScreen({super.key});

  @override
  State<MedicalDetailScreen> createState() => _MedicalDetailScreenState();
}

class _MedicalDetailScreenState extends State<MedicalDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form Controllers
  String? _selectedBloodType;
  final Set<String> _selectedAllergies = {};
  String _otherAllergy = '';
  final Set<String> _selectedDiseases = {};
  String _otherDisease = '';
  final _medicationsController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();

  final List<String> _bloodTypes = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  final List<String> _allergyTypes = ['Food', 'Drug', 'Environmental', 'Other'];
  final List<String> _chronicDiseases = [
    'Asthma',
    'Diabetes',
    'Hypertension',
    'Thyroid',
    'Heart Disease',
    'Other'
  ];

  @override
  void dispose() {
    _medicationsController.dispose();
    _emergencyNameController.dispose();
    _emergencyRelationController.dispose();
    _emergencyPhoneController.dispose();
    super.dispose();
  }

  void _showAllergyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Select Allergies',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._allergyTypes.map((allergy) => CheckboxListTile(
                      title: Text(allergy, style: GoogleFonts.poppins()),
                      value: _selectedAllergies.contains(allergy),
                      activeColor: Color(0xFF016274),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedAllergies.add(allergy);
                          } else {
                            _selectedAllergies.remove(allergy);
                          }
                        });
                      },
                    )),
                    if (_selectedAllergies.contains('Other'))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Specify other allergy',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => _otherAllergy = value,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text('Done', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDiseaseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Chronic Diseases',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._chronicDiseases.map((disease) => CheckboxListTile(
                      title: Text(disease, style: GoogleFonts.poppins()),
                      value: _selectedDiseases.contains(disease),
                      activeColor: Color(0xFF016274),
                      onChanged: (bool? value) {
                        setDialogState(() {
                          if (value == true) {
                            _selectedDiseases.add(disease);
                          } else {
                            _selectedDiseases.remove(disease);
                          }
                        });
                      },
                    )),
                    if (_selectedDiseases.contains('Other'))
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Specify other disease',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => _otherDisease = value,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text('Done', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
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
                    // Heading
                    Text(
                      "Medical Details",
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
                    SizedBox(height: 8),
                    Text(
                      "Help us personalize your health journey",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor.withOpacity(0.9),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Blood Type
                    Text(
                      "Blood Type *",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildDropdown(),
                    SizedBox(height: 12),

                    // Allergies
                    Text(
                      "Allergies *",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildMultiSelectButton(
                      label: _selectedAllergies.isEmpty
                          ? 'Select allergies'
                          : _selectedAllergies.join(', '),
                      onTap: _showAllergyDialog,
                    ),
                    SizedBox(height: 12),

                    // Chronic Diseases
                    Text(
                      "Chronic Diseases (Optional)",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildMultiSelectButton(
                      label: _selectedDiseases.isEmpty
                          ? 'Select conditions'
                          : _selectedDiseases.join(', '),
                      onTap: _showDiseaseDialog,
                    ),
                    SizedBox(height: 12),

                    // Current Medications
                    Text(
                      "Current Medications (Optional)",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _medicationsController,
                      hintText: "e.g., Metformin 500mg - Daily",
                      maxLines: 2,
                    ),
                    SizedBox(height: 16),

                    // Emergency Contact Section
                    Text(
                      "Emergency Contact *",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
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
                    SizedBox(height: 12),
                    Text(
                      "Name",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _emergencyNameController,
                      hintText: "",
                      isRequired: true,
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Relationship",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: whiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 6),
                    _buildTextField(
                      controller: _emergencyRelationController,
                      hintText: "e.g., Mother, Father, Spouse",
                      isRequired: true,
                    ),
                    SizedBox(height: 12),
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
                      controller: _emergencyPhoneController,
                      hintText: "+94",
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                    ),
                    SizedBox(height: 24),

                    // DONE Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedBloodType == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select blood type')),
                              );
                              return;
                            }
                            if (_selectedAllergies.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select at least one allergy')),
                              );
                              return;
                            }
                            // Navigate to Home Screen
                            Navigator.pushReplacementNamed(context, '/dataSecurity');
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
                          "DONE",
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

  Widget _buildDropdown() {
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
      child: DropdownButtonFormField<String>(
        value: _selectedBloodType,
        dropdownColor: Color(0xFF016274),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        hint: Text(
          'Select blood type',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        items: _bloodTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type, style: GoogleFonts.poppins(color: Colors.white)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedBloodType = value;
          });
        },
      ),
    );
  }

  Widget _buildMultiSelectButton({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  color: label.contains('Select')
                      ? Colors.white.withOpacity(0.6)
                      : Colors.white,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = false,
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
        maxLines: maxLines,
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
        ),
        validator: isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              }
            : null,
      ),
    );
  }
}