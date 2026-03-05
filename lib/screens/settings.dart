import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/caregiver_service.dart';
import 'caregiver/generate_code_screen.dart';
import 'caregiver/link_patient_screen.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = AuthService();
  final _caregiverService = CaregiverService();
  
  String? _userRole;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    String? role = await _authService.getUserRole();
    setState(() {
      _userRole = role;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFEAFE63),
        foregroundColor: const Color(0xFF016274),
      ),
      body: ListView(
        children: [
          // Profile Section
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('View and edit your profile'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          
          const Divider(),

          // Data & Security
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Data & Security'),
            subtitle: const Text('Manage your privacy settings'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/dataSecurity');
            },
          ),

          const Divider(),

          // Caregiver Section - FOR PATIENTS
          if (_userRole == 'patient') ...[
            const ListTile(
              title: Text(
                'Caregiver Access',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.supervisor_account, color: Color(0xFF016274)),
              title: const Text('Share Access with Caregiver'),
              subtitle: const Text('Generate a code for your caregiver'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateCodeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFF016274)),
              title: const Text('Manage Caregivers'),
              subtitle: const Text('View and remove caregivers'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to manage caregivers screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),
            const Divider(),
          ],

          // Patient Management Section - FOR CAREGIVERS
          if (_userRole == 'caregiver') ...[
            const ListTile(
              title: Text(
                'Patient Management',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add, color: Color(0xFF016274)),
              title: const Text('Link New Patient'),
              subtitle: const Text('Enter patient access code'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () async {
                bool? success = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LinkPatientScreen(),
                  ),
                );
                if (success == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Patient linked successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFF016274)),
              title: const Text('View Linked Patients'),
              subtitle: const Text('Switch between patient profiles'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to patient list screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),
            const Divider(),
          ],

          // Notifications
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to notifications settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),

          const Divider(),

          // Help & Support
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help and contact support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to help screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),

          // About
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'MediPal',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.medical_services,
                  size: 48,
                  color: Color(0xFF016274),
                ),
                children: const [
                  Text('Your personal health companion'),
                ],
              );
            },
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await _authService.signOut();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/choice',
                    (route) => false,
                  );
                }
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}