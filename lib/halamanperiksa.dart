import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl for date formatting

class HalamanPeriksaAnak extends StatelessWidget {
  final String childName;

  HalamanPeriksaAnak({required this.childName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Periksa Anak: $childName"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('anak')
            .doc(childName)
            .collection('periksa')
            .orderBy('timestamp', descending: true)
            .limit(1) // Fetch the most recent record
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('Tidak ada data pemeriksaan untuk anak ini.'));
          }

          var record = snapshot.data!.docs.first.data();
          var date = (record['timestamp'] as Timestamp).toDate();
          String formattedDate = DateFormat('dd-MM-yyyy').format(date);

          // Convert the values to double if they are stored as strings
          double? weight = _toDouble(record['beratBadan']);
          double? height = _toDouble(record['tinggiBadan']);
          double? headCircumference = _toDouble(record['lingkarKepala']);

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Text(
                'Data Pemeriksaan: $formattedDate',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.monitor_weight, color: Colors.red),
                title: Text('Berat Badan: ${weight?.toStringAsFixed(1)} kg'),
                subtitle: Text('Perbandingan: ${_analyzeWeight(weight)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HasilStatusGiziScreen(
                        kategori: 'Berat Badan menurut Umur (BB/U)',
                        status: _analyzeWeight(weight),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.straighten, color: Colors.orange),
                title: Text('Tinggi Badan: ${height?.toStringAsFixed(1)} cm'),
                subtitle: Text('Perbandingan: ${_analyzeHeight(height)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HasilStatusGiziScreen(
                        kategori: 'Tinggi Badan menurut Umur (TB/U)',
                        status: _analyzeHeight(height),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.circle, color: Colors.blue),
                title: Text(
                    'Lingkar Kepala: ${headCircumference?.toStringAsFixed(1)} cm'),
                subtitle: Text(
                    'Perbandingan: ${_analyzeHeadCircumference(headCircumference)}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HasilStatusGiziScreen(
                        kategori: 'Lingkar Kepala menurut Umur',
                        status: _analyzeHeadCircumference(headCircumference),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to convert String to double
  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return double.tryParse(value);
    }
    return value is double ? value : null;
  }

  // Function to analyze weight status
  String _analyzeWeight(double? weight) {
    if (weight == null) {
      return 'Data berat badan tidak tersedia';
    }
    if (weight < 10) {
      return 'Berat badan kurang (Underweight)';
    } else if (weight >= 10 && weight <= 20) {
      return 'Berat badan normal';
    } else {
      return 'Berat badan berlebih (Overweight)';
    }
  }

  // Function to analyze height status
  String _analyzeHeight(double? height) {
    if (height == null) {
      return 'Data tinggi badan tidak tersedia';
    }
    if (height < 70) {
      return 'Tinggi badan kurang (Stunted)';
    } else if (height >= 70 && height <= 110) {
      return 'Tinggi badan normal';
    } else {
      return 'Tinggi badan lebih (Tall)';
    }
  }

  // Function to analyze head circumference status
  String _analyzeHeadCircumference(double? headCircumference) {
    if (headCircumference == null) {
      return 'Data lingkar kepala tidak tersedia';
    }
    if (headCircumference < 44) {
      return 'Lingkar kepala kurang (Underdeveloped)';
    } else if (headCircumference >= 44 && headCircumference <= 48) {
      return 'Lingkar kepala normal';
    } else {
      return 'Lingkar kepala lebih (Large)';
    }
  }
}

class HasilStatusGiziScreen extends StatelessWidget {
  final String kategori;
  final String status;

  HasilStatusGiziScreen({required this.kategori, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kategori),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Hasil Status Gizi Anak",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "Kategori: $kategori",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                "Status Gizi: $status",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
