import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stuntaware/halamanperiksa.dart'; // Import intl for date formatting

class HasilPeriksaAnakScreen extends StatefulWidget {
  @override
  _HasilPeriksaAnakScreenState createState() => _HasilPeriksaAnakScreenState();
}

class _HasilPeriksaAnakScreenState extends State<HasilPeriksaAnakScreen> {
  List<String> childrenNames = [];

  @override
  void initState() {
    super.initState();
    _fetchChildrenNames();
  }

  void _fetchChildrenNames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('anak').get();
      final names = snapshot.docs.map((doc) => doc['nama'] as String).toList();

      setState(() {
        childrenNames = names;
      });
    } catch (e) {
      print("Error fetching children names: $e");
    }
  }

  void _showRiwayatProgress(String childName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('anak')
          .doc(childName)
          .collection('periksa')
          .orderBy('timestamp', descending: true)
          .get();

      List<DataRow> rows = snapshot.docs.map((doc) {
        var data = doc.data();
        var date = (data['timestamp'] as Timestamp).toDate();
        String formattedDate =
            DateFormat('dd-MM-yyyy').format(date); // Format date

        return DataRow(cells: [
          DataCell(Text(formattedDate)), // Tanggal (formatted)
          DataCell(Text(
              '${data['beratBadan'] ?? 'N/A'} Kg')), // Berat Badan dengan satuan Kg
          DataCell(Text(
              '${data['lingkarKepala'] ?? 'N/A'} Cm')), // Lingkar Kepala dengan satuan Cm
          DataCell(Text(
              '${data['tinggiBadan'] ?? 'N/A'} Cm')), // Tinggi Badan dengan satuan Cm
        ]);
      }).toList();

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Perkembangan $childName",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),

                SizedBox(height: 8),
                Text(
                  "Geser untuk melihat data lainnya",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ), // Tambahkan teks ini
                SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text('Tanggal')),
                      DataColumn(label: Text('Berat Badan')),
                      DataColumn(label: Text('Lingkar Kepala')),
                      DataColumn(label: Text('Tinggi Badan')),
                    ],
                    rows: rows,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print("Error fetching progress data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tidak ada data riwayat untuk anak ini."),
        ),
      );
    }
  }

  void _showOptionsDialog(String childName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Opsi", style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.history, color: Colors.blue),
                  title: Text("Riwayat Perkembangan Anak"),
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    _showRiwayatProgress(childName); // Show Riwayat
                  },
                ),
                ListTile(
                  leading: Icon(Icons.medical_services, color: Colors.green),
                  title: Text("Hasil Pemeriksaan Anak"),
                  onTap: () {
                    Navigator.pop(context); // Close dialog
                    // Navigate to HalamanPeriksaAnak and pass the child name
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            HalamanPeriksaAnak(childName: childName),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil Pemeriksaan Anak"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: childrenNames.isEmpty
          ? Center(child: Text('Tidak ada data anak.'))
          : ListView.builder(
              itemCount: childrenNames.length,
              itemBuilder: (context, index) {
                String childName = childrenNames[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: Icon(Icons.child_care),
                    title: Text(childName),
                    subtitle: Text("Tap to view details"),
                    onTap: () => _showOptionsDialog(childName),
                  ),
                );
              },
            ),
    );
  }
}
