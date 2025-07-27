import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing/services/api_service.dart';
//import 'forgot_password_screen.dart';
import '../patient/patient_home_screen.dart';
import 'forgot_password_dialog.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Form key to validate form fields
  final _formKey = GlobalKey<FormState>();

  // Controllers to access user input values
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Toggle for hiding/showing password
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method to handle login logic
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      try{

        //step 1: key - value pair object created
        Map<String,dynamic> data = {
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        };

        //step 2: make an api call with data
        final response = await ApiServices.loginUser(data);

        //step 3: check for response
        if(response.statusCode == 200){

          //step 4: store response data in local variable so we can use it further
          final data = jsonDecode(response.body);

          //step 5: Here, we store token and role in shared preference.
          final pref = await SharedPreferences.getInstance();

          //bool flag is stored so, when user open application second time then he/she redirect to dashboard screen
          pref.setBool("isLoggedIn", true);

          //token is  used where we need to authenticate
          await pref.setString("authToken", data["token"]);

          //role is used to navigate to different screen from login
          await pref.setString("role", data["user"]["role"]);

          //name is used in patient screen
          await pref.setString("name", data["user"]["name"]);

          Fluttertoast.showToast(msg: "Login Successful!");

          //step 6: here we navigate to dashboard screen according to role
          if(data["user"]["role"] == 'A'){

          }else if(data["user"]["role"] == 'D'){

          }else if(data["user"]["role"] == "U") {
            Navigator.pushReplacementNamed(context, '/userDashboard');
          }
        }else{
          final error = jsonDecode(response.body);
          Fluttertoast.showToast(
            msg: error['error'] ?? 'Login failed. Try again.',
          );
        }
      }catch (e){
        Fluttertoast.showToast(msg: 'An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2E3F), // Dark teal background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo section
              Column(
                children: [
                  Image.asset('assets/images/appLogo.png', height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome to HealthSync',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFFFDF3E7), // Cream color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),

              // Login form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white12,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordDialog()),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Login button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE74C3C), // Red button
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _handleLogin,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              // Register option (for Patients only)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        color: Color(0xFF27AE60), // Green link
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear login state

    // Navigate to login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }
}
