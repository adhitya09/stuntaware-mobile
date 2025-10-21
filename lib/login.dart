import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stuntaware/register.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }

  void _checkIfLoggedIn() async {
    User? user = _auth.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
  }

  void _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      // Delay navigation until after the build is completed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  Widget _buildSocialButton(
      {required IconData icon, required Color color, required String label}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                      duration: Duration(seconds: 1),
                      child: Container(decoration: BoxDecoration()),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1200),
                      child: Container(decoration: BoxDecoration()),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: Duration(milliseconds: 1300),
                      child: Container(decoration: BoxDecoration()),
                    ),
                  ),
                ],
              ),
            ),
            FadeInUp(
              duration: Duration(milliseconds: 1600),
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1800),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF42c4fc)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF42c4fc).withOpacity(0.2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          Divider(color: Color(0xFF42c4fc)),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: () => _login(context),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF42c4fc),
                              Color(0xFF42c4fc).withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(color: Colors.black.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    duration: Duration(milliseconds: 2200),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account? "),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
