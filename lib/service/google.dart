import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:testing/home/home.dart';
import 'package:testing/reusable/function.dart';

class GoogleLoginScreen extends StatefulWidget {
  @override
  _GoogleLoginScreenState createState() => _GoogleLoginScreenState();
}

class _GoogleLoginScreenState extends State<GoogleLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      showToast("Login berhasil!");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error: ${e.code}");

      String errorMessage = "Login gagal. Silakan isi dengan benar.";

      if (e.code == 'user-not-found') {
        showToast("Akun tidak ditemukan. Silakan login dengan Google.");
        _loginWithGoogle();
        return;
      } else if (e.code == 'wrong-password') {
        errorMessage = "Sandi salah. Coba lagi.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Format email tidak valid.";
      } else if (e.code == 'user-disabled') {
        errorMessage = "Akun ini telah dinonaktifkan.";
      } else if (e.code == 'too-many-requests') {
        errorMessage = "Terlalu banyak percobaan login. Coba lagi nanti.";
      }

      showToast(errorMessage);
    }
  }
  
  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        showToast("Login dengan Google dibatalkan.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);

      showToast("Login Google berhasil!");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      showToast("Login Google gagal: ${e.toString()}");
      print("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            ElevatedButton(
              onPressed: _loginWithGoogle,
              child: Text("Login dengan Google"),
            ),
          ],
        ),
      ),
    );
  }
}
