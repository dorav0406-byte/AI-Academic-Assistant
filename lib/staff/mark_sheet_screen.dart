import 'package:flutter/material.dart';

class MarkSheetScreen extends StatefulWidget {
  const MarkSheetScreen({super.key});

  @override
  State<MarkSheetScreen> createState() => _MarkSheetScreenState();
}

class _MarkSheetScreenState extends State<MarkSheetScreen> {
String selectedClass = "III B.Sc Computer Science";
String selectedSubject = "Computer Networks";

final List<Map<String, dynamic>> students = [
{"regNo": "24BCM001", "name": "Arun Kumar"},
{"regNo": "24BCM002", "name": "Karthik"},
{"regNo": "24BCM003", "name": "Harish"},
{"regNo": "24BCM004", "name": "Rahul"},
{"regNo": "24BCM005", "name": "Ajith"},
];

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),

appBar: AppBar(
backgroundColor: const Color(0xFF6C63FF),
title: const Text(
"Mark Sheet",
style: TextStyle(color: Colors.white),
),
centerTitle: true,
),

body: Padding(
padding: const EdgeInsets.all(16),

child: Column(
children: [

Row(
children: [

Expanded(
child: DropdownButtonFormField(
value: selectedClass,
decoration: const InputDecoration(
labelText: "Class",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(
value: "III B.Sc Computer Science",
child: Text("III B.Sc CS"),
),
],
onChanged: (value) {
setState(() {
selectedClass = value.toString();
});
},
),
),

const SizedBox(width: 10),

Expanded(
child: DropdownButtonFormField(
value: selectedSubject,
decoration: const InputDecoration(
labelText: "Subject",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(
value: "Computer Networks",
child: Text("Computer Networks"),
),
],
onChanged: (value) {
setState(() {
selectedSubject = value.toString();
});
},
),
),

],
),

const SizedBox(height: 20),

Row(
children: const [

Expanded(
flex: 3,
child: Text(
"Student",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

Expanded(
child: Center(
child: Text(
"CA1",
style: TextStyle(fontWeight: FontWeight.bold),
),
),
),

Expanded(
child: Center(
child: Text(
"CA2",
style: TextStyle(fontWeight: FontWeight.bold),
),
),
),

Expanded(
child: Center(
child: Text(
"SEM",
style: TextStyle(fontWeight: FontWeight.bold),
),
),
),

],
),

const Divider(),

Expanded(
child: ListView.builder(
itemCount: students.length,
itemBuilder: (context, index) {

final student = students[index];

return Padding(
padding: const EdgeInsets.symmetric(vertical: 8),

child: Row(
children: [

Expanded(
flex: 3,
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
student["name"],
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),

Text(student["regNo"]),

],
),
),

Expanded(
child: TextField(
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
decoration: const InputDecoration(
hintText: "0",
),
),
),

Expanded(
child: TextField(
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
decoration: const InputDecoration(
hintText: "0",
),
),
),

Expanded(
child: TextField(
keyboardType: TextInputType.number,
textAlign: TextAlign.center,
decoration: const InputDecoration(
hintText: "0",
),
),
),
],
),
  );
},
),
),

  const SizedBox(height: 15),

  SizedBox(
    width: double.infinity,
    height: 55,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6C63FF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Marks Saved Successfully"),
          ),
        );
      },
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
      label: const Text(
        "Save Marks",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

],
),
),
);
}
}
