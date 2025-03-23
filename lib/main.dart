import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testing/create/create_login.dart';
import 'package:testing/home/home.dart';
import 'package:testing/reusable/function.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Gunakan ini, bukan FirebaseAuth.ensureInitialized()

  runApp(const MyApp());
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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Konfirmasi"),
                  content: const Text(
                    "Apakah Anda yakin ingin keluar dari aplikasi?",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () => SystemNavigator.pop(),
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text("Login", style: TextStyle(color: textBar())),
        backgroundColor: appBarBG(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/bg_dark.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      size: 100,
                      color: Colors.black,
                    ),
                    const Text(
                      "WELCOME BACK",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const TextField(
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    const SizedBox(height: 8),
                    const TextField(
                      decoration: InputDecoration(labelText: "Password"),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ), // Panggil halaman yang benar
                        );
                      },
                      icon: const Icon(Icons.lock),
                      label: const Text("Login"),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountPage(),
                          ), // Panggil halaman yang benar
                        );
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text("Create Account"),
                    ),

                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        // GoogleAuthService().signInWithGoogle();
                      },
                      icon: const Icon(Icons.login),
                      label: const Text("Login with Google"),
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
