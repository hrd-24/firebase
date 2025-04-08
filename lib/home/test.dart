import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing/detail/detail.dart';
import 'package:testing/rekap/absensi.dart';
import 'package:testing/reusable/function.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isCheckedIn = false;
  String? currentCheckInTime;
  String? currentCheckOutTime;

  @override
  void initState() {
    super.initState();
    _loadAttendanceStatus();
  }

  // Fungsi untuk memuat status Check In dari Firestore
  Future<void> _loadAttendanceStatus() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot doc =
          await _firestore.collection(NewUser.hrdpage).doc(uid).get();

      if (doc.exists) {
        setState(() {
          isCheckedIn = doc['isCheckedIn'] ?? false;
          currentCheckInTime = doc['checkIn'];
          currentCheckOutTime = doc['checkOut'];
        });
      }
    }
  }

  // Fungsi untuk Check In
  Future<void> toggleCheckIn() async {
    User? user = _auth.currentUser;
    if (user != null && !isCheckedIn) {
      String uid = user.uid;
      String checkInTime = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      await _firestore.collection(NewUser.hrdpage).doc(uid).set({
        'uid': uid,
        'email': user.email,
        'checkIn': checkInTime,
        'checkOut': null,
        'isCheckedIn': true,
      }, SetOptions(merge: true));

      setState(() {
        currentCheckInTime = checkInTime;
        currentCheckOutTime = null;
        isCheckedIn = true;
      });
    }
  }

  // Fungsi untuk Check Out
  Future<void> toggleCheckOut() async {
    User? user = _auth.currentUser;
    if (user != null && isCheckedIn) {
      String uid = user.uid;
      String checkOutTime = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      await _firestore.collection(NewUser.hrdpage).doc(uid).set({
        'checkOut': checkOutTime,
        'isCheckedIn': false,
      }, SetOptions(merge: true));

      setState(() {
        currentCheckOutTime = checkOutTime;
        isCheckedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Page'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'List Hadir') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen()),
                );
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'List Hadir',
                    child: Text('Detail Account'),
                  ),
                ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 20),
            AnimatedAnalogClock(
              location: 'Asia/Jakarta',
              backgroundColor: Color(0xff1E1E26),
              hourHandColor: Colors.lightBlueAccent,
              minuteHandColor: Colors.lightBlueAccent,
              secondHandColor: Colors.amber,
              centerDotColor: Colors.amber,
              hourDashColor: Colors.lightBlue,
              minuteDashColor: Colors.blueAccent,
            ),
            Text(
              "Check In: ${currentCheckInTime ?? '-'}",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "Check Out: ${currentCheckOutTime ?? '-'}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            isCheckedIn
                ? ElevatedButton.icon(
                  onPressed: toggleCheckOut,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  icon: Icon(Icons.logout),
                  label: Text("Check Out"),
                )
                : ElevatedButton.icon(
                  onPressed: toggleCheckIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: Icon(Icons.login),
                  label: Text("Check In"),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListHadir()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.list),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
