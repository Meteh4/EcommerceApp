import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Theme/Custom_Text_Theme.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDAD3C8),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    'assets/images/forgot_password.gif',
                  ),
                ),
                const Text(
                  'Forgot',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Password?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Don\'t worry! It happens. Please enter the address associated with your account.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                  cursorHeight: 18,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(5.5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.brown,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color: Colors.brown,
                    ),
                    filled: true,
                    fillColor: Colors.white60,
                    labelText: "Enter your Email",
                    labelStyle: TextStyle(color: Colors.brown[700]),
                  ),


                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: _email);
                      Navigator.of(context).pop();

                    },
                    style: ButtonStyle(
                      elevation: const MaterialStatePropertyAll<double>(0),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}