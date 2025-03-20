import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:testing/create/create_login.dart';
import 'package:testing/home/home.dart';
import 'package:testing/reusable/function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi login biasa dengan Firebase Authentication
  void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      showToast("Login berhasil!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuth Error: ${e.code}");

      String errorMessage = "Login gagal. Silakan isi dengan benar.";

      if (e.code == 'user-not-found') {
        // Jika user tidak ditemukan, arahkan ke login Google
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

  // Fungsi login dengan Google
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

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      showToast("Login Google berhasil!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      showToast("Login Google gagal: ${e.toString()}");
      print("Google Sign-In Error: $e");
    }
  }

  // Navigasi ke halaman Create Account
  void _navigateToCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Konfirmasi"),
                  content: Text(
                    "Apakah Anda yakin ingin keluar dari aplikasi?",
                  ),
                  actions: [
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text("OK"),
                      onPressed: () => SystemNavigator.pop(),
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(
          "Login",
          style: TextStyle(color: textBar()),
        ),
       backgroundColor: appBarBG(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg_dark.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.account_circle, size: 100, color: Colors.black),
                    Text(
                      "WELCOME BACK",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _login,
                      icon: Icon(Icons.lock),
                      label: Text("Login"),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _navigateToCreateAccount,
                      icon: Icon(Icons.person_add),
                      label: Text("Create Account"),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _loginWithGoogle,
                      icon: Icon(Icons.login),
                      label: Text("Login with Google"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
