import 'package:flutter/material.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Announcements"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          AnnouncementCard(
            title: "Internal Assessment - I",
            message: "Internal Assessment I starts from 05 August 2026.",
            date: "20 Jul 2026",
            color: Colors.red,
          ),

          AnnouncementCard(
            title: "Assignment Submission",
            message: "Submit Java Mini Project before 28 July 2026.",
            date: "18 Jul 2026",
            color: Colors.orange,
          ),

          AnnouncementCard(
            title: "Holiday Notice",
            message: "College will remain closed on Friday due to a public holiday.",
            date: "15 Jul 2026",
            color: Colors.green,
          ),

          AnnouncementCard(
            title: "Seminar",
            message: "AI & Cloud Computing Seminar will be held in Seminar Hall at 10:00 AM.",
            date: "12 Jul 2026",
            color: Colors.blue,
          ),

        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String message;
  final String date;
  final Color color;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            Icons.campaign,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(message),
        trailing: Text(
          date,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}