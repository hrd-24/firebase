import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/reusable/function.dart';
import 'package:testing/service/user_collection.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HrdPageService _hrdPageService = HrdPageService(); // Instance dari class HrdPageService

  String? _userEmail;
  String? _userPhone;
  String? _userGender;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _hrdPageService.saveUserToHrdPage(); // Simpan ke HrdPage saat pertama login
  }

  Future<void> _getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection(NewUser.hrdpage).doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userEmail = userDoc['email'];
          _userPhone = userDoc['phone_number'];
          _userGender = userDoc['gender'];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen"), backgroundColor: Colors.blueGrey),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Email: $_userEmail"),
                  Text("Phone: $_userPhone"),
                  Text("Gender: $_userGender"),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      var userData = await _hrdPageService.getUserFromHrdPage();
                      if (userData != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Data HRD: ${userData['email']}"),
                        ));
                      }
                    },
                    child: Text("Get HRD Data"),
                  ),
                ],
              ),
            ),
    );
  }
}
