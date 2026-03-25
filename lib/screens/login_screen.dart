import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  final auth = AuthService();
  final fbAuth = FirebaseAuthService();

  /// 🔥 GOOGLE LOGIN (FINAL FIX)
  Future googleLogin() async {
    try {
      GoogleAuthProvider provider = GoogleAuthProvider();

      final userCredential =
          await FirebaseAuth.instance.signInWithPopup(provider);

      if (userCredential.user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Login Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),

              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF667eea),
                          child: Icon(Icons.lock, color: Colors.white, size: 30),
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(labelText: "Email"),
                          validator: (v) =>
                              v!.contains('@') ? null : "Enter valid email",
                        ),

                        const SizedBox(height: 15),

                        TextFormField(
                          controller: pass,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: "Password"),
                          validator: (v) =>
                              v!.length >= 6 ? null : "Min 6 chars",
                        ),

                        const SizedBox(height: 20),

                        /// 🔥 NORMAL LOGIN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {

                                bool exists = await auth.login(
                                  email.text.trim(),
                                  pass.text.trim(),
                                );

                                if (!exists) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Please register first")),
                                  );
                                  return;
                                }

                                try {
                                  await fbAuth.login(
                                    email.text.trim(),
                                    pass.text.trim(),
                                  );

                                  Navigator.pushReplacementNamed(context, '/dashboard');

                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Login Failed")),
                                  );
                                }
                              }
                            },
                            child: const Text("Login"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// 🔥 GOOGLE LOGIN
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.g_mobiledata, size: 28),
                            label: const Text("Login with Google"),
                            onPressed: googleLogin,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text("Don't have account? Register"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}