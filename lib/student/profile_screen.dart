import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:academic_assistant/screens/student_login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String rollNo;

  const ProfileScreen({
    super.key,
    required this.rollNo,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
final supabase = Supabase.instance.client;

Map<String, dynamic>? student;

bool isLoading = true;

@override
void initState() {
super.initState();
loadStudent();
}

Future<void> loadStudent() async {
final data = await supabase
.from('students')
.select()
.eq('rollno', widget.rollNo)
.single();

setState(() {
student = data;
isLoading = false;
});
}

@override
Widget build(BuildContext context) {
if (isLoading) {
return const Scaffold(
body: Center(
child: CircularProgressIndicator(),
),
);
}

return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),

appBar: AppBar(
title: const Text("Profile"),
centerTitle: true,
backgroundColor: const Color(0xFF6C63FF),
),

body: SingleChildScrollView(
child: Column(
children: [

Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(vertical: 30),
decoration: const BoxDecoration(
color: Color(0xFF6C63FF),
borderRadius: BorderRadius.only(
bottomLeft: Radius.circular(35),
bottomRight: Radius.circular(35),
),
),
child: Column(
children: [

const CircleAvatar(
radius: 45,
backgroundColor: Colors.white,
child: Icon(
Icons.person,
size: 50,
color: Color(0xFF6C63FF),
),
),

const SizedBox(height: 15),

Text(
student!['name'],
style: const TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 5),

Text(
student!['rollno'],
style: const TextStyle(
color: Colors.white70,
),
),

],
),
),

const SizedBox(height: 20),

profileTile(
Icons.school,
"Department",
student!['department'],
),

profileTile(
Icons.calendar_today,
"Year",
student!['year'],
),profileTile(
    Icons.groups,
    "Section",
    student!['section'],
  ),

  profileTile(
    Icons.cake,
    "Date of Birth",
    student!['dob'],
  ),

  profileTile(
    Icons.email,
    "Email",
    student!['email'],
  ),

  profileTile(
    Icons.phone,
    "Phone",
    student!['phone'],
  ),

  profileTile(
    Icons.home,
    "Address",
    student!['address'],
  ),

  const SizedBox(height: 30),

  SizedBox(
    width: 220,
    height: 50,
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () async {
        await supabase.auth.signOut();

        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const StudentLoginScreen(),
          ),
              (route) => false,
        );
      },
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      label: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 30),

],
),
),
);
}

static Widget profileTile(
    IconData icon,
    String title,
    dynamic value,
    ) {
  return Card(
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF6C63FF),
      ),
      title: Text(title),
      subtitle: Text(value?.toString() ?? ""),
    ),
  );
}
}