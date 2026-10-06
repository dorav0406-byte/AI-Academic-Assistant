import 'package:flutter/material.dart';
import 'package:academic_assistant/staff/attendance_sheet_screen.dart';
import 'package:academic_assistant/staff/mark_sheet_screen.dart';
import 'package:academic_assistant/student/academic_calendar_screen.dart';
import 'package:academic_assistant/staff/staff_profile_screen.dart';

class StaffDashboardScreen extends StatefulWidget {
  final String staffName;
  final String department;
  final String staffId;

  const StaffDashboardScreen({
    super.key,
    required this.staffId,
    required this.staffName,
    required this.department,
  });

  @override
  State<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();
}

class _StaffDashboardScreenState
    extends State<StaffDashboardScreen> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: const Text(
          "Staff Dashboard",
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

            // HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(
                color: Color(0xFF6C63FF),

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
                          color: Color(0xFF6C63FF),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [

                            const Text(
                              "Welcome",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              widget.staffName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              widget.department,
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

                      prefixIcon: const Icon(
                        Icons.search,
                      ),

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

            // DASHBOARD CARDS
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),

              child: GridView.count(
                shrinkWrap: true,

                physics:
                const NeverScrollableScrollPhysics(),

                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,

                childAspectRatio: 1.1,

                children: [

                  dashboardCard(
                    Icons.how_to_reg,
                    "Attendance Sheet",
                    Colors.blue,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceSheetScreen(
                            staffId: widget.staffId,
                          ),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.grading,
                    "Mark Sheet",
                    Colors.green,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const MarkSheetScreen(),
                        ),
                      );
                    },
                  ),

                  dashboardCard(
                    Icons.calendar_month,
                    "Academic Calendar",
                    Colors.orange,
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
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        selectedItemColor:
        const Color(0xFF6C63FF),

        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const StaffProfileScreen(),
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
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            CircleAvatar(
              radius: 26,

              backgroundColor:
              color.withOpacity(0.15),

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