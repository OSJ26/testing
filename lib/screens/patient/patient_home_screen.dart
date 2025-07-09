import 'package:flutter/material.dart';
/*import 'package:healthsync/screens/patient/book_appointment_screen.dart';
import 'package:healthsync/screens/patient/view_appointment_screen.dart';
import 'package:healthsync/screens/patient/prescription_screen.dart';
import 'package:healthsync/screens/patient/lab_result_screen.dart';
import 'package:healthsync/screens/common/profile_screen.dart';
import 'package:healthsync/screens/chat/chat_list_screen.dart';
import 'package:healthsync/services/auth_service.dart';*/
import 'package:testing/screens/auth/login_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2E3F), // Dark teal base
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'HealthSync',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Clear session and return to login
              //await AuthService.logout(context, const LoginScreen());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, 👋',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFDF3E7), // Cream
              ),
            ),
            const SizedBox(height: 24),

            // Grid of action cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.calendar_month,
                    label: 'Book\nAppointment',
                    color: const Color(0xFF27AE60), // Green
                    screen: const LoginScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.event_note,
                    label: 'My\nAppointments',
                    color: const Color(0xFFE67E22), // Orange
                    screen: const LoginScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.medication,
                    label: 'Prescriptions',
                    color: const Color(0xFFC0392B), // Red
                    screen: const LoginScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.science,
                    label: 'Lab\nResults',
                    color: const Color(0xFF2980B9), // Blue
                    screen: const LoginScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.chat,
                    label: 'Messages',
                    color: const Color(0xFF8E44AD), // Purple
                    screen: const LoginScreen(),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.settings,
                    label: 'Profile',
                    color: const Color(0xFF16A085), // Teal
                    screen: const LoginScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable dashboard card for navigation
  Widget _buildDashboardCard(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
        required Widget screen,
      }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: color,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
