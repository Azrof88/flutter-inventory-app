import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- ADD THIS LINE
import '../../data/models/user_model.dart'; // Import the user model to check the role
import '../dashboard/dashboard_screen.dart'; // To navigate after login
import '../dashboard/admin_dashboard_screen.dart'; // Import the admin dashboard
import '../dashboard/staff_dashboard_screen.dart'; // Import the staff dashboard
import 'signup_screen.dart'; // Import the new sign up screen
import 'forgot_password_screen.dart'; // <-- IMPORT THE NEW SCREEN


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // --- AZROF: REMEMBER ME LOGIC (Saves email locally) ---
    // MEHEDI-NOTE: This feature is for user convenience and saves the email only.
    // It is separate from the real "session persistence" that you will implement
    // using FirebaseAuth's `authStateChanges()` stream to keep the user
    // automatically logged in after they close and reopen the app.
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      // If checked, save the email
      await prefs.setString('remembered_email', _emailController.text.trim());
    } else {
      // If unchecked, remove any saved email
      await prefs.remove('remembered_email');
    }

    try {
      final user = await AuthService.instance.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // --- NEW: ROLE-BASED NAVIGATION ---
      // Here, we check the role of the user returned from the AuthService
      // and navigate to the appropriate dashboard.
      if (mounted) {
        if (user.role == UserRole.admin) {
          // Navigate to Admin Dashboard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          );
        } else {
          // Navigate to Staff Dashboard for any other role
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StaffDashboardScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // <-- ADD THIS LINE
  }

// --- NEW METHOD FOR REMEMBER ME ---
  // This method loads the user's email from the device's local storage.
  void _loadUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('remembered_email');
    if (email != null) {
      setState(() {
        _emailController.text = email;
        _rememberMe = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- NEW: STACK FOR BACKGROUND IMAGE ---
      // We use a Stack to layer the background image, an overlay, and the form.
      body: Stack(
        children: [
          // 1. Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                // Replace with your desired image URL
                image: NetworkImage('https://images.unsplash.com/photo-1556740738-b6a63e27c4df?q=80&w=2070&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. Semi-transparent Overlay for readability
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          // 3. The Login Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Inventory App',
                      // Adjusted text style for better visibility on a dark background
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Email Text Field
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white), // Text color for input
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: const Icon(Icons.email, color: Colors.white70),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your email';
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) return 'Please enter a valid email address';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Password Text Field
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    // Remember Me & Forgot Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() { _rememberMe = value ?? false; });
                              },
                              checkColor: Colors.deepPurple,
                              activeColor: Colors.white,
                              side: const BorderSide(color: Colors.white70),
                            ),
                            const Text('Remember Me', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        TextButton(
                          // --- UPDATE THIS BUTTON ---
                          onPressed: () {
                            // Navigate to the Forgot Password screen
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Error Message Display
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    // Login Button
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            onPressed: _login,
                            child: const Text('Login'),
                          ),
                    const SizedBox(height: 24),
                    // Sign Up Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: const Text('Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

