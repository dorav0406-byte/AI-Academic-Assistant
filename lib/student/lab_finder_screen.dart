import 'package:flutter/material.dart';

class LabFinderScreen extends StatelessWidget {
  const LabFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Lab Finder"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6C63FF),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [

          LabCard(
            labName: "Computer Lab - 1",
            floor: "Ground Floor",
            status: "Available",
            color: Colors.green,
          ),

          LabCard(
            labName: "Computer Lab - 2",
            floor: "First Floor",
            status: "Occupied",
            color: Colors.red,
          ),

          LabCard(
            labName: "Programming Lab",
            floor: "Second Floor",
            status: "Available",
            color: Colors.green,
          ),

          LabCard(
            labName: "Networking Lab",
            floor: "Second Floor",
            status: "Maintenance",
            color: Colors.orange,
          ),

          LabCard(
            labName: "Project Lab",
            floor: "Third Floor",
            status: "Available",
            color: Colors.green,
          ),

        ],
      ),
    );
  }
}

class LabCard extends StatelessWidget {
  final String labName;
  final String floor;
  final String status;
  final Color color;

  const LabCard({
    super.key,
    required this.labName,
    required this.floor,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF6C63FF),
          child: const Icon(
            Icons.computer,
            color: Colors.white,
          ),
        ),

        title: Text(
          labName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Text(floor),

        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color,
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
      ),
    );
  }
}