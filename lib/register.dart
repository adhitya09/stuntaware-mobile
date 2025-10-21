import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuntaware/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String? _selectedGender;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _register(BuildContext context) async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Passwords do not match")));
      return;
    }

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'date_of_birth': _dobController.text,
          'gender': _selectedGender,
        });

        // Use addPostFrameCallback to navigate after the current frame is built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Register')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an Account",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900), // Earliest date
                    lastDate: DateTime.now(), // Latest date
                  );
                  setState(() {
                    _dobController.text = "${pickedDate.toLocal()}".split(
                      ' ',
                    )[0]; // Format to YYYY-MM-DD
                  });
                },
                child: TextField(
                  controller: _dobController,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ), // Icon to indicate calendar
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ["Male", "Female", "Other"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _register(context),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Color(0xFF42c4fc),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
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
    );
  }
}
