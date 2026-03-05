import 'package:flutter/material.dart';
import '../../services/code_service.dart';

class LinkPatientScreen extends StatefulWidget {
  const LinkPatientScreen({super.key});

  @override
  State<LinkPatientScreen> createState() => _LinkPatientScreenState();
}

class _LinkPatientScreenState extends State<LinkPatientScreen> {
  final TextEditingController _codeController = TextEditingController();
  final CodeService _codeService = CodeService();
  bool _isLoading = false;

  Future<void> _verifyAndLinkCode() async {
    final code = _codeController.text.trim().toUpperCase();

    // Validation
    if (code.isEmpty) {
      _showError('Please enter an access code');
      return;
    }

    if (code.length != 6) {
      _showError('Access code must be 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      print('🔍 Attempting to link with code: $code');
      
      final result = await _codeService.linkCaregiverToPatient(code);
if (mounted) {
  // Show success message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '✅ Successfully linked to ${result['patientName']}!',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );

  // Navigate to Caregiver Home
  Navigator.pushReplacementNamed(context, '/caregiverHome'); // ← CHANGED
}
    } catch (e) {
      print('❌ Link error: $e');
      setState(() => _isLoading = false);
      
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      _showError(errorMessage);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Link to Patient'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.link_rounded,
                  size: 80,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Enter Patient Access Code',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Enter the 6-character code provided by your patient to gain access to their health data',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Code Input Field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green[300]!, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'ABC123',
                    hintStyle: TextStyle(
                      color: Colors.green[200],
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    counterText: '',
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    letterSpacing: 6,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  onChanged: (value) {
                    // Auto-submit when 6 characters entered
                    if (value.length == 6) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  onSubmitted: (_) => _verifyAndLinkCode(),
                ),
              ),

              const SizedBox(height: 32),

              // Verify Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyAndLinkCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          'Verify & Link to Patient',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 32),

              // Help Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.help_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'How to get the code?',
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Ask your patient to open their MediPal app\n'
                      '2. They should go to "Generate Access Code"\n'
                      '3. They\'ll generate a 6-character code\n'
                      '4. They can share it with you via message',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontSize: 12,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Security Note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.amber[700],
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Codes are secure and can only be used once',
                        style: TextStyle(
                          color: Colors.amber[900],
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}