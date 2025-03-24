import 'package:flutter/material.dart';


class ListHadir extends StatelessWidget {
  final List<Map<String, String?>> attendanceRecords;

  ListHadir({required this.attendanceRecords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Hadir"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: attendanceRecords.length,
          itemBuilder: (context, index) {
            final record = attendanceRecords[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Check In: ${record['checkIn']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("Check Out: ${record['checkOut'] ?? 'Belum Check Out'}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: record['checkOut'] == null ? Colors.red : Colors.black)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
