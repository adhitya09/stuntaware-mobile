import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DaftarAnakScreen extends StatefulWidget {
  @override
  _DaftarAnakScreenState createState() => _DaftarAnakScreenState();
}

class _DaftarAnakScreenState extends State<DaftarAnakScreen> {
  // Function to get the list of children from Firestore
  Stream<QuerySnapshot> _getAnakList() {
    return FirebaseFirestore.instance.collection('anak').snapshots();
  }

  // Function to delete a child
  void _hapusAnak(String anakId, String namaAnak) async {
    // Menampilkan dialog konfirmasi
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data anak ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // Tidak jadi hapus
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), // Konfirmasi hapus
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    // Jika pengguna mengonfirmasi penghapusan
    if (confirmDelete == true) {
      try {
        // 1. Hapus semua dokumen di sub-koleksi periksa (jika ada)
        final periksaSnapshot = await FirebaseFirestore.instance
            .collection('anak')
            .doc(namaAnak) // Nama anak sebagai ID dokumen
            .collection('periksa')
            .get();

        // Loop untuk menghapus dokumen di sub-koleksi
        for (var doc in periksaSnapshot.docs) {
          await doc.reference.delete(); // Hapus dokumen di sub-koleksi
        }

        // 2. Hapus dokumen anak berdasarkan ID
        await FirebaseFirestore.instance
            .collection('anak')
            .doc(anakId)
            .delete();

        // 3. Hapus dokumen anak berdasarkan nama anak
        await FirebaseFirestore.instance
            .collection('anak')
            .doc(namaAnak)
            .delete();

        // Menampilkan notifikasi sukses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Anak dan data terkait berhasil dihapus')),
        );
      } catch (e) {
        // Menampilkan notifikasi error jika gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Terjadi kesalahan saat menghapus data anak')),
        );
      }
    }
  }

  // Function to show child details and navigate to UbahAnakScreen for editing
  void _showDetailAnak(String nama, String jenisKelamin, String tanggalLahir,
      String golonganDarah, String riwayatPenyakit, String documentId) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detail Anak',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Nama: $nama', style: TextStyle(fontSize: 18)),
            Text('Jenis Kelamin: $jenisKelamin',
                style: TextStyle(fontSize: 18)),
            Text('Tanggal Lahir: $tanggalLahir',
                style: TextStyle(fontSize: 18)),
            Text('Golongan Darah: $golonganDarah',
                style: TextStyle(fontSize: 18)),
            Text('Riwayat Penyakit: $riwayatPenyakit',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Anak"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getAnakList(),
        builder: (ctx, anakSnapshot) {
          if (anakSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!anakSnapshot.hasData || anakSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada data anak.'));
          }

          final anakData = anakSnapshot.data!.docs;

          return ListView.builder(
            itemCount: anakData.length,
            itemBuilder: (ctx, index) {
              final anak = anakData[index];

              // Convert the timestamp field to string
              Timestamp timestamp = anak['tanggal_lahir'];
              String tanggalLahir =
                  DateFormat('dd MMMM yyyy').format(timestamp.toDate());

              return ChildCard(
                id: anak.id,
                name: anak['nama'],
                gender: anak['jenis_kelamin'],
                birthDate: tanggalLahir, // Use formatted date
                golonganDarah: anak['golongan_darah'],
                riwayatPenyakit: anak['riwayat_penyakit'],
                onDelete: () {
                  _hapusAnak(anak.id, anak['nama']); // Pass ID dan nama
                },

                onTap: () {
                  _showDetailAnak(
                    anak['nama'],
                    anak['jenis_kelamin'],
                    tanggalLahir, // Use formatted date
                    anak['golongan_darah'],
                    anak['riwayat_penyakit'],
                    anak.id, // Pass documentId
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ChildCard extends StatelessWidget {
  final String id;
  final String name;
  final String gender;
  final String birthDate;
  final String golonganDarah;
  final String riwayatPenyakit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  ChildCard({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDate,
    required this.golonganDarah,
    required this.riwayatPenyakit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.child_care, color: Colors.blue),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(gender),
            Text(birthDate),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
