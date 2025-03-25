import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testing/reusable/function.dart';

class ListHadir extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Hadir")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(NewUser.hrdpage).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada data kehadiran."));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
        itemBuilder: (context, index) {
  var user = users[index].data() as Map<String, dynamic>;

  bool isCheckedIn = (user['isCheckedIn'] ?? false) as bool; // Gunakan default false

  return Card(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    elevation: 3,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: isCheckedIn ? Colors.green : Colors.grey,
        child: Icon(
          isCheckedIn ? Icons.check : Icons.close,
          color: Colors.white,
        ),
      ),
      title: Text(user['email'] ?? 'Tidak diketahui'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Check In: ${user['checkIn'] ?? '-'}"),
          Text("Check Out: ${user['checkOut'] ?? '-'}"),
          Text("Status: ${isCheckedIn ? 'Sedang Hadir' : 'Sudah Pulang'}"),
        ],
      ),
    ),
  );
}

          );
        },
      ),
    );
  }
}
