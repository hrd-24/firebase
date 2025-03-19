import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testing/main.dart';
import 'package:testing/reusable/function.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Fungsi navigasi ke halaman LoginScreen
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Fungsi logout dari akun Google dan Firebase
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Logout dari Firebase
      await GoogleSignIn().signOut(); // Logout dari Google

      // Navigasi kembali ke halaman login
      _navigateToLoginScreen(context);
    } catch (e) {
      print("Logout Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal logout. Coba lagi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: const Text("Apakah Anda yakin ingin keluar?"),
                  actions: [
                    TextButton(
                      child: const Text("Batal"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                        _navigateToLoginScreen(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(
          "Home",
          style: TextStyle(color: textBar()),
        ),
        backgroundColor: appBarBG(),
        actions: [
          // Tombol logout Google
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black,),
            tooltip: "Logout",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Logout"),
                    content: const Text("Apakah Anda yakin ingin logout dari akun Google?"),
                    actions: [
                      TextButton(
                        child: const Text("Batal"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text("Logout"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Tutup dialog
                          _logout(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Hello, World!", style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
