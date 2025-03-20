import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:testing/daftar/daftar_kontak.dart';
import 'package:testing/details/account.dart';
import 'package:testing/endpoint/reusable_users.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
     appBar: AppBar(
  title: const Text("Tambah Data"),
  backgroundColor: Colors.blueGrey,
  actions: [
    PopupMenuButton<String>(
      onSelected: (String choice) {
        if (choice == 'detail') {
          // Navigasi ke halaman detail akun
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailAccountPage()),
          );
        } else if (choice == 'logout') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Konfirmasi"),
                content: Text("Apakah Anda yakin ingin logout?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    child: Text("Logout"),
                    onPressed: () {
                      // Tambahkan fungsi logout di sini
                      Navigator.of(context).pop();
                      // Bisa ditambahkan navigasi ke halaman login
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            value: 'detail',
            child: Text("Detail Akun"),
          ),
          PopupMenuItem(
            value: 'logout',
            child: Text("Logout"),
          ),
        ];
      },
    ),
  ],
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
            ElevatedButton.icon(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    numberController.text.isNotEmpty) {
                  userProvider.addUser(
                    nameController.text,
                    numberController.text,
                  );
                  nameController.clear();
                  numberController.clear();
                }
              },
              icon: Icon(Icons.add),
              label: const Text("Tambah Data"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button untuk pindah ke DaftarScreen
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

  void blockUser(String id) {
    _firestore.collection('new').doc(id).update({'blocked': true});
  }

  void unblockUser(String id) {
    _firestore.collection(NewUser.hrdusers).doc(id).update({'blocked': false});
  }

  void addUser(String name, String number) {
    _firestore.collection(NewUser.hrdusers).add({
      'name': name,
      'number': number,
      'checked': false,
    });
  }

  void updateChecked(String id, bool value) {
    _firestore.collection(NewUser.hrdusers).doc(id).update({'checked': value});
  }

  void deleteUser(String id) {
    _firestore.collection(NewUser.hrdusers).doc(id).delete();
  }
}
