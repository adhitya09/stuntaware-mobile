import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pusat Bantuan"),
        backgroundColor: Color(0xFF42c4fc), // Sesuaikan dengan tema aplikasi
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header Section
            Text(
              "Selamat datang di Pusat Bantuan Stuntaware",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // FAQ Section
            _buildHelpOption(
              icon: Icons.question_answer,
              text: "FAQ - Pertanyaan yang Sering Diajukan",
              onTap: () {
                // Tambahkan logika untuk membuka FAQ atau bagian lainnya
              },
            ),
            _buildHelpOption(
              icon: Icons.article,
              text: "Panduan Penggunaan Aplikasi",
              onTap: () {
                // Tambahkan logika untuk membuka panduan atau tutorial
              },
            ),
            _buildHelpOption(
              icon: Icons.phone_in_talk,
              text: "Hubungi Kami",
              onTap: () {
                // Tampilkan popup bottom sheet untuk menginformasikan tim support tutup
                _showSupportClosedPopup(context);
              },
            ),

            // Section for additional info
            SizedBox(height: 40),
            Text(
              "Jika Anda membutuhkan bantuan lebih lanjut, jangan ragu untuk menghubungi kami.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showSupportClosedPopup(context);
              },
              child: Text("Hubungi Tim Support"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF42c4fc),
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF42c4fc)),
      title: Text(text, style: TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  // Function to show the bottom sheet when user taps on "Hubungi Kami"
  void _showSupportClosedPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 60,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                "Tim Support Sedang Tutup",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Kami tidak dapat melayani permintaan Anda saat ini. Silakan coba lagi nanti.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text("Tutup"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        );
      },
    );
  }
}
