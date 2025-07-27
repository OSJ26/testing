import 'dart:convert';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  // 🔁 Submit form
  Future<void> _submit() async {
    setState(() => errorMessage = null);

    if (!_formKey.currentState!.validate()) return;

    if (newPassController.text.trim() != confirmPassController.text.trim()) {
      setState(() => errorMessage = "Passwords do not match");
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiServices.forgotPassword(
      email: emailController.text.trim(),
      newPassword: newPassController.text.trim(),
    );

    setState(() => isLoading = false);

    if (result.statusCode == 200) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password Reset Successfully")),
      );
    } else {
      setState(() => errorMessage = "Failed to reset password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0B2E3F), // Dark Teal
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_reset, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Color(0xFFFDF3E7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                _buildInputField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email,
                  validator: (val) => val == null || !val.contains('@') ? "Enter valid email" : null,
                ),
                const SizedBox(height: 12),

                _buildInputField(
                  controller: newPassController,
                  label: "New Password",
                  icon: Icons.lock,
                  obscure: true,
                  validator: (val) {
                    if (val == null || val.length < 6) return "Min 6 characters";
                    if (!RegExp(r'^(?=.*[A-Z])(?=.*[@#$%^&+=]).*$').hasMatch(val)) {
                      return "Must include uppercase & symbol";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                _buildInputField(
                  controller: confirmPassController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                  validator: (val) =>
                  val != newPassController.text ? "Passwords do not match" : null,
                ),

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                        ),
                        onPressed: isLoading ? null : () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF27AE60), // Green
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading ? null : _submit,
                        icon: const Icon(Icons.refresh),
                        label: isLoading
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text("Reset"),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black26,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF27AE60)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
