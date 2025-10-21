import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TambahAnakScreen extends StatefulWidget {
  @override
  _TambahAnakScreenState createState() => _TambahAnakScreenState();
}

class _TambahAnakScreenState extends State<TambahAnakScreen> {
  final _namaController = TextEditingController();
  String _jenisKelamin = 'Laki laki';
  DateTime? _tanggalLahir;
  String _golonganDarah = 'A';
  String _riwayatPenyakit = '';

  void _submitForm() async {
    final nama = _namaController.text;
    final jenisKelamin = _jenisKelamin;
    final tanggalLahir = _tanggalLahir;
    final golonganDarah = _golonganDarah;
    final riwayatPenyakit = _riwayatPenyakit;

    if (nama.isEmpty || tanggalLahir == null || riwayatPenyakit.isEmpty) {
      // Tampilkan pesan error atau validasi
      return;
    }

    // Menyimpan data ke Firestore
    try {
      await FirebaseFirestore.instance.collection('anak').add({
        'nama': nama,
        'jenis_kelamin': jenisKelamin,
        'tanggal_lahir': tanggalLahir,
        'golongan_darah': golonganDarah,
        'riwayat_penyakit': riwayatPenyakit,
      });

      // Bersihkan form setelah submit
      _namaController.clear();
      setState(() {
        _tanggalLahir = null;
        _jenisKelamin = 'Laki laki';
        _golonganDarah = 'A';
        _riwayatPenyakit = '';
      });

      // Menampilkan dialog sukses
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Berhasil'),
          content: Text('Data anak berhasil ditambahkan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      // Menampilkan dialog gagal
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Gagal'),
          content: Text('Terjadi kesalahan saat menyimpan data.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _pilihTanggal() async {
    final tanggalDipilih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (tanggalDipilih != null) {
      setState(() {
        _tanggalLahir = tanggalDipilih;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Anak'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        // Membungkus konten dengan SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Menggunakan MainAxisSize.min untuk menghindari overflow
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Lengkap
              TextField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Lengkap'),
              ),
              SizedBox(height: 20),

              // Jenis Kelamin
              Text('Jenis Kelamin'),
              Row(
                children: [
                  Radio<String>(
                    value: 'Laki laki',
                    groupValue: _jenisKelamin,
                    onChanged: (value) {
                      setState(() {
                        _jenisKelamin = value!;
                      });
                    },
                  ),
                  Text('Laki laki'),
                  Radio<String>(
                    value: 'Perempuan',
                    groupValue: _jenisKelamin,
                    onChanged: (value) {
                      setState(() {
                        _jenisKelamin = value!;
                      });
                    },
                  ),
                  Text('Perempuan'),
                ],
              ),
              SizedBox(height: 20),

              // Tanggal Lahir
              Text('Tanggal Lahir'),
              Row(
                children: [
                  Text(_tanggalLahir == null
                      ? 'belum memilih tanggal'
                      : '${_tanggalLahir!.toLocal()}'.split(' ')[0]),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: _pilihTanggal,
                    child: Text('pilih tanggal',
                        style: TextStyle(color: Colors.pink)),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Golongan Darah
              Text('Golongan Darah'),
              DropdownButton<String>(
                value: _golonganDarah,
                items: <String>['A', 'B', 'AB', 'O']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _golonganDarah = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),

              // Riwayat Penyakit Keras
              TextField(
                onChanged: (value) {
                  setState(() {
                    _riwayatPenyakit = value;
                  });
                },
                decoration:
                    InputDecoration(labelText: 'Riwayat Penyakit Keras'),
              ),
              SizedBox(height: 20), // Add space before the button
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Tambah'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
