import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:testing/daftar/daftar_kontak.dart';
import 'package:testing/endpoint/reusable_users.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool isCheckedIn = false;
  String? documentId;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Data"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Nama",
                hintText: "Masukkan Nama",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nomor",
                hintText: "Masukkan Nomor",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || numberController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nama dan Nomor harus diisi")),
                  );
                  return;
                }

                setState(() {
                  isCheckedIn = !isCheckedIn;
                });

                if (documentId == null) {
                  // Jika belum ada, buat baru
                  DocumentReference docRef = await userProvider.addUser(
                    nameController.text,
                    numberController.text,
                    isCheckedIn,
                  );
                  documentId = docRef.id;
                } else {
                  // Jika sudah ada, update saja
                  userProvider.updateChecked(documentId!, isCheckedIn);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isCheckedIn
                        ? "Anda sudah Check-in"
                        : "Anda sudah Check-out"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn
                    ? Colors.red
                    : Colors.green,
              ),
              child: Text(
                isCheckedIn ? "Check-out" : "Check-in",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DaftarScreen()),
          );
        },
        backgroundColor: Colors.blueGrey,
        child: const Icon(Icons.list),
      ),
    );
  }
}

// Provider untuk mengelola data
class UserProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> addUser(String name, String number, bool checked) async {
    try {
      DocumentReference docRef = await _firestore.collection(NewUser.hrdusers).add({
        'name': name,
        'number': number,
        'checked': checked,
      });
      notifyListeners();
      return docRef;
    } catch (e) {
      print("Error adding user: $e");
      throw e;
    }
  }

  Future<void> updateChecked(String id, bool value) async {
    try {
      await _firestore.collection(NewUser.hrdusers).doc(id).update({
        'checked': value,
      });
      notifyListeners();
    } catch (e) {
      print("Error updating checked: $e");
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await _firestore.collection(NewUser.hrdusers).doc(id).delete();
      notifyListeners();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
