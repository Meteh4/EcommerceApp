import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shoptral1/Screens/Forgot_Password.dart';
import 'package:shoptral1/Screens/Home_Screen.dart';
import 'package:shoptral1/Screens/Register_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;

  final auth = FirebaseAuth.instance;
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffDAD3C8),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 250,
                    child: Image.asset(
                      'assets/images/login.gif',
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
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
                          icon: Icon(
                              _isObscure ? Icons.visibility : Icons.visibility_off),
                          onPressed: (){
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          auth.signInWithEmailAndPassword(email: _email, password: _password)
                              .then((userCredential) {
                            Fluttertoast.showToast(
                              msg: "Login successful",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          }).catchError((error) {
                            Fluttertoast.showToast(
                              msg: "Failed to sign in: $error",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                            );
                          });
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'OR',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(0),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        icon: Image.asset(
                          'assets/images/google_icon.png',
                          scale: 2,
                        ),
                        label: const Center(
                          child: Text(
                            'Login with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 42),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      children: [
                        TextSpan(
                          text: 'New to Shoptral ? ',
                        ),
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
