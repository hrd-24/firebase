import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/reusable/function.dart';

class HrdPageService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk menyimpan UID dan data user ke "HrdPage"
  Future<void> saveUserToHrdPage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;

      // Mengambil data user dari Firestore berdasarkan UID
      DocumentSnapshot userDoc = await _firestore.collection(NewUser.hrdpage).doc(uid).get();

      if (userDoc.exists) {
        String email = userDoc['email'] ?? 'No email';
        String phoneNumber = userDoc['phone_number'] ?? 'No phone number';
        String gender = userDoc['gender'] ?? 'No gender';

        // Menyimpan ke koleksi "HrdPage"
        await _firestore.collection(NewUser.hrdpage).doc(uid).set({
          'uid': uid,
          'email': email,
          'phone_number': phoneNumber,
          'gender': gender,
          'registered_at': FieldValue.serverTimestamp(), // Timestamp saat pertama kali masuk ke HrdPage
        }, SetOptions(merge: true));
      }
    }
  }

  // Fungsi untuk mengambil data user dari koleksi "HrdPage"
  Future<Map<String, dynamic>?> getUserFromHrdPage() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot hrdPageDoc = await _firestore.collection(NewUser.hrdpage).doc(uid).get();

      if (hrdPageDoc.exists) {
        return hrdPageDoc.data() as Map<String, dynamic>;
      }
    }
    return null;
  }
}
