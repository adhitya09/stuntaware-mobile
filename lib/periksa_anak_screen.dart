import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: PeriksaAnakScreen(),
  ));
}

class PeriksaAnakScreen extends StatefulWidget {
  @override
  _PeriksaAnakScreenState createState() => _PeriksaAnakScreenState();
}

class _PeriksaAnakScreenState extends State<PeriksaAnakScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _headCircumferenceController =
      TextEditingController();

  String? selectedChild;
  List<String> childNames = [];

  @override
  void initState() {
    super.initState();
    _fetchChildrenNames();
  }

  // Fetch children names from Firestore
  void _fetchChildrenNames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('anak').get();

      // Casting the list from dynamic to String
      final childrenList = snapshot.docs.map((doc) {
        return doc['nama'] as String; // Explicitly casting to String
      }).toList();

      setState(() {
        childNames = childrenList;
        // Don't set selectedChild initially, it will remain null to show the "Pilih Nama Anak" text
      });
    } catch (e) {
      print("Error fetching children names: $e");
    }
  }

  // Fetch previous data for the selected child
  void _fetchPreviousData(String childName) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('anak')
          .doc(childName)
          .collection('periksa')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var data = snapshot.docs.first.data();
        _weightController.text = data['beratBadan'] ?? '';
        _heightController.text = data['tinggiBadan'] ?? '';
        _headCircumferenceController.text = data['lingkarKepala'] ?? '';
        _showPreviousDataPopup();
      }
    } catch (e) {
      print("Error fetching previous data: $e");
    }
  }

  // Show popup to notify the user about existing data
  void _showPreviousDataPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Menampilkan Data Pemeriksaan Sebelumnya"),
          content: Text(
              "Data pemeriksaan sebelumnya ditemukan, form akan diisi dengan data lama. Anda dapat mengupdate data."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Save or update data in Firestore
  void _saveData(BuildContext context) {
    String weight = _weightController.text;
    String height = _heightController.text;
    String headCircumference = _headCircumferenceController.text;

    if (weight.isEmpty || height.isEmpty || headCircumference.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap lengkapi semua data!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Store the data back to Firestore (Update or Add)
    try {
      FirebaseFirestore.instance
          .collection('anak')
          .doc(selectedChild)
          .collection('periksa')
          .add({
        'beratBadan': weight,
        'tinggiBadan': height,
        'lingkarKepala': headCircumference,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Data berhasil disimpan cek status di tab hasil pemeriksaan anak'),
          backgroundColor: Colors.green,
        ),
      );

      // After saving data, go back to the previous page (Home)
      Navigator.pop(context); // This line navigates back to the previous screen
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Store Data Anak"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("• Pastikan menimbang berat badan dengan timbangan"),
                    Text(
                        "• Pastikan mengukur tinggi badan dengan posisi badan tegak dan tidak menggunakan alas kaki"),
                    Text(
                        "• Pastikan mengukur lingkar kepala dengan alat ukur lingkar kepala/alat ukur yang elastis"),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              // Dropdown for selecting child
              childNames.isNotEmpty
                  ? DropdownButton<String>(
                      value: selectedChild,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedChild = newValue;
                        });
                        // Fetch previous data when a child is selected
                        if (newValue != null) {
                          _fetchPreviousData(newValue);
                        }
                      },
                      hint: Text('Pilih Nama Anak'), // Default hint
                      items: childNames
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  : Center(
                      child: Text(
                          'Tidak ada data anak, tambah data anak terlebih dahulu')), // Loading state
              SizedBox(height: 16.0),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Berat Badan (Kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Tinggi Badan (Cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _headCircumferenceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Lingkar Kepala (Cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveData(context),
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
