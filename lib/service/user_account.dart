import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing/reusable/function.dart';

class UserCreate {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk membuat akun dan menyimpan data ke Firestore
  Future<String?> createAccount({
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
  }) async {
    try {
      // Buat akun di Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Dapatkan UID pengguna yang baru dibuat
      String uid = userCredential.user!.uid;

      // Simpan informasi tambahan ke Firestore
      await _firestore.collection(NewUser.hrdpage).doc(uid).set({
        "email": email,
        "phone_number": phoneNumber,
        "gender": gender,
        "created_at": DateTime.now(),
      });

      return null; // Berarti sukses
    } on FirebaseAuthException catch (e) {
      return e.message; // Jika error, kembalikan pesan error
    }
  }
}
