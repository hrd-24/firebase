import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:testing/rekap/absensi.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool isCheckedIn = false;
  String? currentCheckInTime;
  String? currentCheckOutTime;
  List<Map<String, String?>> attendanceRecords = [];

  void toggleCheckIn() {
    setState(() {
      if (!isCheckedIn) {
        currentCheckInTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        currentCheckOutTime = null;
        isCheckedIn = true;
        
        // Tambahkan data check-in baru ke daftar
        attendanceRecords.add({
          'checkIn': currentCheckInTime,
          'checkOut': null,
        });
      }
    });
  }

  void toggleCheckOut() {
    if (isCheckedIn) {
      setState(() {
        currentCheckOutTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
        isCheckedIn = false;
        
        // Update record check-in terakhir dengan check-out
        if (attendanceRecords.isNotEmpty) {
          attendanceRecords.last['checkOut'] = currentCheckOutTime;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Tambahkan fungsi detail account dan logout nanti
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "detail_account",
                  child: Text("Detail Account"),
                ),
                PopupMenuItem(
                  value: "logout",
                  child: Text("Logout"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: toggleCheckIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn ? Colors.grey : Colors.green,
              ),
              child: Text("Check In"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleCheckOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCheckedIn ? Colors.red : Colors.grey,
              ),
              child: Text("Check Out"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListHadir(attendanceRecords: attendanceRecords),
            ),
          );
        },
        child: Icon(Icons.list),
      ),
    );
  }
}