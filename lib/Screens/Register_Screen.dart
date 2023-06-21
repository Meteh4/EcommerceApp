import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shoptral1/Screens/Login_Screen.dart';
import '../Theme/Custom_Text_Theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String _email, _password, _fullName;
  final auth = FirebaseAuth.instance;
  bool _isObscure = true;

  Future<void> updateProfile(String fullName) async {
    User? user = auth.currentUser;
    if (user != null) {
      await user.updateDisplayName(fullName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDAD3C8),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Image.asset(
                      'assets/images/sign_up.gif',
                    ),
                  ),
                ),
                const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 14),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _fullName = value.trim();
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
                      Icons.person,
                      color: Colors.brown,
                    ),
                    filled: true,
                    fillColor: Colors.white60,
                    labelText: "Enter your Full Name",
                    labelStyle: TextStyle(color: Colors.brown[700]),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                  cursorHeight: 18,
                  obscureText: _isObscure,
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
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    prefixIcon: const Icon(
                      Icons.password_outlined,
                      color: Colors.brown,
                    ),
                    filled: true,
                    fillColor: Colors.white60,
                    labelText: "Enter your Password",
                    labelStyle: TextStyle(color: Colors.brown[700]),
                  ),
                ),
                const SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.brown),
                    text: 'By signing up, you agree to our',
                    children: [
                      TextSpan(
                        text: ' Terms & Conditions',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(
                        text: ' and',
                      ),
                      TextSpan(
                        text: ' Privacy Policy',
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          auth.createUserWithEmailAndPassword(email: _email, password: _password).then((userCredential) async {
                            User? user = userCredential.user;
                            await updateProfile(_fullName);

                            await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({'full_name': _fullName});

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          });
                        },
                        child: const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'Joined us before? ',
                        style: TextStyle(
                          color: Colors.brown,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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