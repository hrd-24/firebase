import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // 📌 Fungsi untuk mengambil data user & foto dari Firestore
  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('HrdPage').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          _profileImageUrl = userDoc['profile_image'] ?? '';
        });
      }
    }
  }

  // 📌 Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _uploadImageToFirebase(imageFile);
    }
  }

  // 📌 Fungsi untuk mengupload gambar ke Firebase Storage
  Future<void> _uploadImageToFirebase(File imageFile) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String filePath = 'profile_images/${user.uid}.jpg';
      try {
        UploadTask uploadTask = _storage.ref(filePath).putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Simpan URL gambar di Firestore
        await _firestore.collection('HrdPage').doc(user.uid).set({
          'profile_image': downloadUrl,
        }, SetOptions(merge: true));

        // Perbarui tampilan
        setState(() {
          _profileImageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto berhasil diunggah!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunggah foto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengguna'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('HrdPage').doc(_auth.currentUser?.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Data tidak ditemukan.'));
          }

          Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
          String email = userData['email'] ?? 'Tidak ada email';
          String phoneNumber = userData['phone_number'] ?? 'Tidak ada nomor telepon';
          String gender = userData['gender'] ?? 'Tidak ada gender';

          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImage, // Klik untuk memilih gambar
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueAccent,
                          backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!)
                              : null,
                          child: _profileImageUrl == null || _profileImageUrl!.isEmpty
                              ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.blueAccent),
                        title: Text(email, style: const TextStyle(fontSize: 18)),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.green),
                        title: Text(phoneNumber, style: const TextStyle(fontSize: 18)),
                      ),
                      ListTile(
                        leading: Icon(
                          gender.toLowerCase() == 'male' ? Icons.male : Icons.female,
                          color: gender.toLowerCase() == 'male' ? Colors.blue : Colors.pink,
                        ),
                        title: Text(gender, style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
