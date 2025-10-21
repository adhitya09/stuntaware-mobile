import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  void _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Cek jika password baru dan konfirmasi password cocok
    if (newPassword != confirmPassword) {
      setState(() {
        errorMessage = "Password baru dan konfirmasi password tidak cocok.";
      });
      return;
    }

    try {
      User? user = _auth.currentUser;

      // Verifikasi password lama dengan re-authenticate
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPassword,
      );

      // Reauthenticate user
      await user.reauthenticateWithCredential(credential);

      // Ganti password
      await user.updatePassword(newPassword);
      await user.reload();

      // Menampilkan sukses dan kembali ke layar sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password berhasil diganti!")),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ganti Password"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password Lama"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password Baru"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration:
                  InputDecoration(labelText: "Konfirmasi Password Baru"),
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text("Ganti Password"),
            ),
          ],
        ),
      ),
    );
  }
}
