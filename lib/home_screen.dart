import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stuntaware/hasilpemeriksaan.dart';
import 'login.dart';
import 'tambah_anak_screen.dart';
import 'daftar_anak_screen.dart';
import 'profil_akun_screen.dart';
import 'artikel_screen.dart';
import 'periksa_anak_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      backgroundColor: Color(0xFF42c4fc),
      body: Column(
        children: [
          // Top Header Section
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
                    // Do nothing since we are on Home
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfilAkunScreen()),
                    );
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOptionCard(
                      icon: Icons.person_add,
                      title: "Tambah Anak",
                      subtitle: "Tambahkan data anak anda di sini.",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TambahAnakScreen()),
                        );
                      },
                    ),

                    _buildOptionCard(
                      icon: Icons.list,
                      title: "Daftar Anak",
                      subtitle: "Lihat daftar anak anda di sini.",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DaftarAnakScreen()),
                        );
                      },
                    ),
                    _buildOptionCard(
                      icon: Icons.medical_services,
                      title: "Periksa Anak",
                      subtitle:
                          "Periksa tumbuh kembang anak anda setiap bulan.",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PeriksaAnakScreen()),
                        );
                      },
                    ),
                    _buildOptionCard(
                      icon: Icons.medical_services,
                      title: "Hasil Pemeriksaan Anak",
                      subtitle: "Cek Hasil Pemeriksaan disini!",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HasilPeriksaAnakScreen()),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    // Article Section Header with "Selengkapnya" button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Artikel",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtikelScreen()),
                            );
                          },
                          child: Text(
                            "Selengkapnya",
                            style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF42c4fc),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Responsive Article Cards
                    SizedBox(
                      height: 150, // Define a fixed height for ListView
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildArticleCard("Salah Satu 4T, Melahirkan...",
                              "assets/images/a1.jpg"),
                          _buildArticleCard("Dampak Buruk Stunting Bagi...",
                              "assets/images/a2.jpeg"),
                          _buildArticleCard("Kenali Gejala Stunting Pada...",
                              "assets/images/a3.jpeg"),
                        ],
                      ),
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

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 40),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(String title, String imagePath) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            height: 80, // Set the height for the image area
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300], // Placeholder color
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
