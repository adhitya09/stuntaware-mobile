import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stuntaware/chanepassword.dart';
import 'package:stuntaware/helpcentre.dart';
import 'home_screen.dart'; // Import HomeScreen
import 'login.dart'; // Import LoginScreen

class ProfilAkunScreen extends StatefulWidget {
  @override
  _ProfilAkunScreenState createState() => _ProfilAkunScreenState();
}

class _ProfilAkunScreenState extends State<ProfilAkunScreen> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userName = userDoc['name'] ?? "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF42c4fc), // Blue background color
      body: Column(
        children: [
          // Top Profile Information Section with Notification Icon
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            color: Color(0xFF42c4fc),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.person, color: Color(0xFF42c4fc)),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Navigation Tabs for Home and Profil Akun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to HomeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text(
                    "Home",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Do nothing since we are on Profil Akun
                  },
                  child: Text(
                    "Profil Akun",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  Text(
                    "Akun",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  _buildProfileOption(
                    icon: Icons.lock_outline,
                    text: "Ganti Password",
                    onTap: () {
                      // Arahkan pengguna ke halaman ganti password
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()),
                      );
                    },
                  ),

                  SizedBox(height: 20),
                  // Help Center Section
                  Text(
                    "Pusat Bantuan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    text: "Bantuan",
                    onTap: () {
                      // Arahkan pengguna ke halaman Pusat Bantuan
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HelpCenterScreen()),
                      );
                    },
                  ),

                  _buildProfileOption(
                    icon: Icons.logout, // Changed icon to notifications
                    text: "Keluar", // Updated text to "Notifikasi"
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
