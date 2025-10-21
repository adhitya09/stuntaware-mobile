import 'package:flutter/material.dart';

class ArtikelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Semua Artikel"),
        backgroundColor: Color(0xFF42c4fc),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari artikel...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),
            // List of Articles
            Expanded(
              child: ListView(
                children: [
                  _buildArticleCard(
                    title: "Salah Satu 4T: Melahirkan Terlalu Muda...",
                    description:
                        "Permasalahan stunting merupakan masalah kesehatan yang penting...",
                    imagePath: 'assets/images/a1.jpg', // Example image path
                  ),
                  _buildArticleCard(
                    title: "Dampak Buruk Stunting Bagi Anak...",
                    description:
                        "Kenali dampak buruk stunting untuk mencegah masalah kesehatan...",
                    imagePath: 'assets/images/a2.jpeg', // Example image path
                  ),
                  _buildArticleCard(
                    title: "Kenali Gejala Stunting Pada Anak...",
                    description:
                        "Mengetahui gejala stunting sejak dini penting untuk kesehatan anak...",
                    imagePath: 'assets/images/a3.jpeg', // Example image path
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Image.asset(imagePath, width: 60, fit: BoxFit.cover),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          // Define navigation to detailed article screen if needed
        },
      ),
    );
  }
}
