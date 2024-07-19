

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import '../widgets/app_drawer.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool _isLoggedIn = false;
  String? _generatedOTP;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = preferences.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _googleSignIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var result = await googleSignIn.signIn();
      if (result != null) {
        String firstName = result.displayName!.split(" ")[0];
        String lastName = result.displayName!.split(" ")[1];
        _saveLoginState();
        Navigator.pushReplacementNamed(context, '/home', arguments: {'firstName': firstName, 'lastName': lastName});
      }
    } catch (error) {
      print(error);
    }
  }

  void _generateOTP() {
    setState(() {
      _generatedOTP = (Random().nextInt(9000) + 1000).toString();
    });
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Your OTP"),
        content: Text(_generatedOTP!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _verifyOTP() {
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
      if (otpController.text == _generatedOTP) {
        _saveLoginState();
        Navigator.pushReplacementNamed(context, '/home', arguments: {'phoneNumber': phoneController.text});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect OTP")));
      }
    });
  }

  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 2, 47, 17),
      appBar: AppBar(
        title: Text('Login'),
      ),
      drawer: AppDrawer(
        onLogout: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', false);
        },
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 2 / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 155, 210, 84),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          hintText: "Phone Number",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: otpController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: "OTP Number",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Color.fromARGB(255, 2, 47, 17),
                                foregroundColor: Color.fromARGB(255, 155, 210, 48),
                              ),
                              onPressed: _generateOTP,
                              child: Text(
                                "Generate OTP",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: 230,
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Color.fromARGB(255, 2, 47, 17),
                                    ),
                                  )
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 10,
                                      backgroundColor: Color.fromARGB(255, 2, 47, 17),
                                      foregroundColor: Color.fromARGB(255, 155, 210, 48),
                                    ),
                                    onPressed: _verifyOTP,
                                    child: Text(
                                      "Verify OTP",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: SizedBox(
                            width: 230,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                backgroundColor: Color.fromARGB(255, 2, 47, 17),
                                foregroundColor: Color.fromARGB(255, 155, 210, 48),
                              ),
                              onPressed: _googleSignIn,
                              child: Text(
                                "Google Login",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Spacer(),
                      Row(
                        children: [
                          Spacer(),
                          Text("Don't have an account? "),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.green,
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
            ],
          ),
        ),
      ),
    );
  }
}
