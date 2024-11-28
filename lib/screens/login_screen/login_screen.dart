import 'package:auto_route/auto_route.dart';
import 'package:calendar/screens/components/custom_button.dart';
import 'package:calendar/screens/components/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign in method
  void signUserIn() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Error message to user
    void errorMessage(String message) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
          );
        },
      );
    }

    // Try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Pop loading circle
      Navigator.pop(context);

      // Show error message
      errorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DMCalendar',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 192, 244),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Login text
                const SizedBox(height: 100),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 45,
                  ),
                ),

                // Email text field
                const SizedBox(height: 100),
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                // Password text field
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                // Forget password
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Color.fromARGB(255, 100, 98, 98),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sign in button
                CustomButton(
                  textInButton: 'Sign in',
                  onTap: signUserIn,
                ),

                // Divider
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 3, 192, 244),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(
                            color: Color.fromARGB(255, 100, 98, 98),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Color.fromARGB(255, 3, 192, 244),
                        ),
                      ),
                    ],
                  ),
                ),

                // Sign in via Apple or Google (Currently empty)
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Placeholder for Google or Apple buttons
                    SizedBox(width: 10),
                  ],
                ),

                // Register text
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 100, 98, 98),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 3, 192, 244),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
