// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:provider/provider.dart';
// import 'package:testing/endpoint/reusable_users.dart';
// import 'package:testing/home/home.dart';

// class DaftarScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Daftar Pengguna"),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection(NewUser.hrdusers).snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return ListView(
//             padding: const EdgeInsets.all(10),
//             children: snapshot.data!.docs.map((doc) {
//               bool isChecked = doc['checked'];

//               return Card(
//                 elevation: 3,
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: ListTile(
//                   leading: Checkbox(
//                     value: isChecked,
//                     onChanged: (bool? value) {
//                       userProvider.updateChecked(doc.id, value!);
//                     },
//                   ),
//                   title: Text(
//                     doc['name'],
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(doc['number']),
//                       Text(
//                         isChecked ? "Status: ✅ Check-in" : "Status: ❌ Check-out",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: isChecked ? Colors.green : Colors.red,
//                         ),
//                       ),
//                     ],
//                   ),
//                   trailing: PopupMenuButton<String>(
//                     onSelected: (value) {
//                       if (value == "edit") {
//                         _editUser(context, doc);
//                       } else if (value == "delete") {
//                         userProvider.deleteUser(doc.id);
//                       }
//                     },
//                     itemBuilder: (BuildContext context) => [
//                       const PopupMenuItem(value: "edit", child: Text("Edit")),
//                       const PopupMenuItem(value: "delete", child: Text("Hapus")),
//                     ],
//                   ),
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       ),
//     );
//   }

//   void _editUser(BuildContext context, QueryDocumentSnapshot doc) {
//     TextEditingController nameController = TextEditingController(text: doc['name']);
//     TextEditingController numberController = TextEditingController(text: doc['number']);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Pengguna"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama")),
//               TextField(controller: numberController, decoration: const InputDecoration(labelText: "Nomor")),
//             ],
//           ),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseFirestore.instance.collection(NewUser.hrdusers).doc(doc.id).update({
//                   'name': nameController.text,
//                   'number': numberController.text,
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text("Simpan"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
