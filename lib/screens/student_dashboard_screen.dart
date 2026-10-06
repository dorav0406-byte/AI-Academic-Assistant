import 'package:flutter/material.dart';

import 'package:academic_assistant/student/attendance_screen.dart';
import 'package:academic_assistant/student/mark_screen.dart';
import 'package:academic_assistant/student/timetable_screen.dart';
import 'package:academic_assistant/student/assignment_screen.dart';
import 'package:academic_assistant/student/academic_calendar_screen.dart';
import 'package:academic_assistant/student/syllabus_screen.dart';
import 'package:academic_assistant/student/lab_finder_screen.dart';
import 'package:academic_assistant/student/announcement_screen.dart';
import 'package:academic_assistant/student/chatbot_screen.dart';
import 'package:academic_assistant/student/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StudentDashboardScreen extends StatefulWidget {
  final String rollNo;
  const StudentDashboardScreen({super.key,required this.rollNo,});

  @override
  State<StudentDashboardScreen> createState() =>
      _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int currentIndex = 0;
  final supabase=Supabase.instance.client;
  Map<String,dynamic>? student;
  bool isLoading=true;

  @override
  void initState(){
    super.initState();
    loadStudent();
  }
  Future<void> loadStudent() async{
    final data =await supabase
        .from('students')
        .select()
        .eq('rollno', widget.rollNo)
        .single();
    setState(() {
      student=data;
      isLoading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xff6C63FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          "Academic Assistant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xff6C63FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [

                  Row(
                    children: [

                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 36,
                          color: Color(0xff6C63FF),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Good Morning 👋",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              student!['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "${student!['year']} ${student!['department']} ${student!['section']}",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                children: [

                  dashboardCard(
                    Icons.fact_check,
                    "Attendance",
                    Colors.blue,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>  AttendanceScreen(
                            rollNo:  widget.rollNo,
                          ),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.bar_chart,
                    "Marks",
                    Colors.green,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MarkScreen(
                            rollNo:widget.rollNo,
                          ),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.schedule,
                    "Timetable",
                    Colors.orange,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                           TimetableScreen(
                             year: student!['year'],
                             section: student!['section'],
                           ),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.assignment,
                    "Assignments",
                    Colors.deepPurple,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AssignmentScreen(),
                        ),
                      );
                    },
                  ),
                  dashboardCard(
                    Icons.calendar_month,
                    "Calendar",
                    Colors.red,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AcademicCalendarScreen(),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.menu_book,
                    "Syllabus",
                    Colors.teal,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const SyllabusScreen(),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.meeting_room,
                    "Lab Finder",
                    Colors.indigo,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LabFinderScreen(),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.campaign,
                    "Announcements",
                    Colors.deepOrange,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const AnnouncementScreen(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xff6C63FF),
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatbotScreen(
                  rollNo:widget.rollNo,
                ),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>ProfileScreen(rollNo: widget.rollNo,),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: "AI Chat",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),

        ],
      ),
    );
  }

  Widget dashboardCard(
      IconData icon,
      String title,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 26,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),

          ],
        ),
      ),
    );
  }
}