import 'package:flutter/material.dart';

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Assignments"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          AssignmentCard(
            subject: "Computer Networks",
            title: "OSI Model Report",
            dueDate: "25 July 2026",
            status: "Pending",
            statusColor: Colors.orange,
          ),

          AssignmentCard(
            subject: "Java Programming",
            title: "Mini Project",
            dueDate: "28 July 2026",
            status: "Submitted",
            statusColor: Colors.green,
          ),

          AssignmentCard(
            subject: "Operating System",
            title: "CPU Scheduling",
            dueDate: "30 July 2026",
            status: "Pending",
            statusColor: Colors.red,
          ),

          AssignmentCard(
            subject: "DBMS",
            title: "Normalization",
            dueDate: "01 August 2026",
            status: "Submitted",
            statusColor: Colors.green,
          ),
        ],
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final String subject;
  final String title;
  final String dueDate;
  final String status;
  final Color statusColor;

  const AssignmentCard({
    super.key,
    required this.subject,
    required this.title,
    required this.dueDate,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              subject,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  "Due: $dueDate",
                  style: const TextStyle(color: Colors.grey),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }
}