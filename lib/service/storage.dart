// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';

// class StorageService {
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<String?> uploadImage(File image, String userId) async {
//     try {
//       final ref = _storage.ref().child('profile_pictures/$userId.jpg');
//       await ref.putFile(image);
//       return await ref.getDownloadURL();
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null;
//     }
//   }
// }
