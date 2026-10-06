import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceScreen extends StatefulWidget {
  final String rollNo;

  const AttendanceScreen({
    super.key,
    required this.rollNo,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
final supabase = Supabase.instance.client;

// Sem 5 subjects
final List<String> subjects = [
'Web Technology',
'Web Technology Lab',
'PCD',
'Advanced Java Programming',
'Advanced Java Lab',
'Mobile Application Development',
'MAD Lab',
];

late String selectedSubject;

StreamSubscription<List<Map<String, dynamic>>>?
_attendanceSubscription;

bool isLoading = true;

// Selected subject attendance
int presentCount = 0;
int absentCount = 0;

List<Map<String, dynamic>> attendanceRecords = [];

// Overall semester attendance
int overallPresentCount = 0;
int overallAbsentCount = 0;

double get attendancePercentage {
final total = presentCount + absentCount;

if (total == 0) return 0;

return (presentCount / total) * 100;
}

double get overallAttendancePercentage {
final total =
overallPresentCount + overallAbsentCount;

if (total == 0) return 0;

return (overallPresentCount / total) * 100;
}

@override
void initState() {
super.initState();

selectedSubject = subjects.first;

_subscribeToAttendance();
}

// ----------------------------------------------------------
// REAL-TIME ATTENDANCE
// ----------------------------------------------------------

void _subscribeToAttendance() {
_attendanceSubscription?.cancel();

setState(() {
isLoading = true;
});

_attendanceSubscription = supabase
.from('attendance')
.stream(primaryKey: ['id'])
.eq('rollno', widget.rollNo)
.order('attendance_date', ascending: false)
.listen(
(data) {
// =====================================================
// OVERALL SEMESTER ATTENDANCE
// =====================================================

int overallPresent = 0;
int overallAbsent = 0;

for (final record in data) {
final subject =
record['subject']?.toString() ?? '';

final status =
record['status']?.toString() ?? '';

// Only count our current semester subjects
if (!subjects.contains(subject)) {
continue;
}

if (status == 'Present') {
overallPresent++;
} else if (
status == 'Absent' ||
status == 'Leave') {
overallAbsent++;
}
}

// =====================================================
// SELECTED SUBJECT ATTENDANCE
// =====================================================

final filteredData = data
.where(
(record) =>
record['subject'] == selectedSubject,
)
.toList();

int present = 0;
int absent = 0;

for (final record in filteredData) {
final status =
record['status']?.toString() ?? '';

if (status == 'Present') {
present++;
} else if (
status == 'Absent' ||
status == 'Leave') {
absent++;
}
}

if (!mounted) return;

setState(() {
// Subject
attendanceRecords = filteredData;
presentCount = present;
absentCount = absent;

// Overall
overallPresentCount = overallPresent;
overallAbsentCount = overallAbsent;

isLoading = false;
});
},
onError: (error) {
if (!mounted) return;

setState(() {
isLoading = false;
});

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(
'Failed to load real-time attendance: $error',
),
),
);
},
);
}

@override
void dispose() {
_attendanceSubscription?.cancel();
super.dispose();
}

// ----------------------------------------------------------
// BUILD
// ----------------------------------------------------------

@override
Widget build(BuildContext context) {
final total = presentCount + absentCount;

final overallTotal =
overallPresentCount + overallAbsentCount;

return Scaffold(
backgroundColor: const Color(0xFFF5F7FB),

appBar: AppBar(
title: const Text(
'Attendance',
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
centerTitle: true,
backgroundColor: const Color(0xFF6C63FF),
foregroundColor: Colors.white,
),

body: isLoading
? const Center(
child: CircularProgressIndicator(),
)
: SingleChildScrollView(
physics:
const AlwaysScrollableScrollPhysics(),

padding: const EdgeInsets.all(16),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

// =================================================
// OVERALL SEMESTER ATTENDANCE
// =================================================

Container(
width: double.infinity,
padding: const EdgeInsets.all(20),

decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(20),

boxShadow: [
BoxShadow(
color:
Colors.black.withOpacity(0.06),
blurRadius: 10,
offset:
const Offset(0, 4),
),
],
),

child: Column(
children: [

const Text(
'Overall Semester Attendance',
style: TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 8),

const Text(
'All subjects',
style: TextStyle(
fontSize: 14,
color: Colors.grey,
),
),

const SizedBox(height: 10),

Text(
'${overallAttendancePercentage.toStringAsFixed(1)}%',
style: const TextStyle(
fontSize: 36,
fontWeight:
FontWeight.bold,
color:
Color(0xFF6C63FF),
),
),

const SizedBox(height: 20),

SizedBox(
height: 220,

child: overallTotal == 0
? const Center(
child: Text(
'No attendance recorded yet',
style: TextStyle(
color:
Colors.grey,
fontSize: 16,
),
),
)

: PieChart(
PieChartData(
sectionsSpace: 4,
centerSpaceRadius: 45,

sections: [

// PRESENT
PieChartSectionData(
value:
overallPresentCount
.toDouble(),

title:
'$overallPresentCount',

color:
Colors.green,

radius: 65,

titleStyle:
const TextStyle(
color:
Colors.white,
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),

// ABSENT
if (overallAbsentCount >
0)
PieChartSectionData(
value:
overallAbsentCount
.toDouble(),

title:
'$overallAbsentCount',

color:
Colors.red,

radius: 65,

titleStyle:
const TextStyle(
color:
Colors.white,
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),
],
),
),
),

const SizedBox(height: 15),

Row(
mainAxisAlignment:
MainAxisAlignment.center,

children: [
_legend(
Colors.green,
'Present',
overallPresentCount,
),

const SizedBox(width: 25),

_legend(
Colors.red,
'Absent',
overallAbsentCount,
),
],
),
],
),
),

const SizedBox(height: 30),

// =================================================
// SUBJECT ATTENDANCE
// =================================================

const Text(
'Subject Attendance',
style: TextStyle(
fontSize: 20,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 15),

const Text(
'Select Subject',
style: TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 12),

Container(
width: double.infinity,
padding:
const EdgeInsets.symmetric(
horizontal: 16,
),

decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(14),

boxShadow: [
BoxShadow(
color:
Colors.black.withOpacity(0.06),
blurRadius: 8,
offset:
const Offset(0, 3),
),
],
),

child:
DropdownButtonHideUnderline(
child:
DropdownButton<String>(
value: selectedSubject,

isExpanded: true,

items: subjects.map(
(subject) {
return DropdownMenuItem<
String>(
value: subject,

child: Text(
subject,
),
);
},
).toList(),

onChanged: (value) {
if (value == null) {
return;
}

setState(() {
selectedSubject = value;
});

// Refresh selected subject
// from the current stream
_subscribeToAttendance();
},
),
),
),

const SizedBox(height: 24),

// =================================================
// SELECTED SUBJECT PIE CHART
// =================================================

Container(
width: double.infinity,
padding:
const EdgeInsets.all(20),

decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(20),

boxShadow: [
BoxShadow(
color:
Colors.black.withOpacity(0.06),
blurRadius: 10,
offset:
const Offset(0, 4),
),
],
),

child: Column(
children: [

Text(
selectedSubject,
textAlign:
TextAlign.center,

style:
const TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 10),

Text(
'${attendancePercentage.toStringAsFixed(1)}%',
style:
const TextStyle(
fontSize: 36,
fontWeight:
FontWeight.bold,
color:
Color(0xFF6C63FF),
),
),

const SizedBox(height: 20),

SizedBox(
height: 220,

child: total == 0
? const Center(
child: Text(
'No attendance recorded yet',
style:
TextStyle(
color:
Colors.grey,
fontSize: 16,
),
),
)

: PieChart(
PieChartData(
sectionsSpace:
4,

centerSpaceRadius:
45,

sections: [

PieChartSectionData(
value:
presentCount
.toDouble(),

title:
'$presentCount',

color:
Colors.green,

radius: 65,

titleStyle:
const TextStyle(
color:
Colors.white,
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),

if (absentCount >
0)
PieChartSectionData(
value:
absentCount
.toDouble(),

title:
'$absentCount',

color:
Colors.red,

radius: 65,

titleStyle:
const TextStyle(
color:
Colors.white,
fontWeight:
FontWeight.bold,
fontSize: 16,
),
),
],
),
),
),

const SizedBox(height: 15),

Row(
mainAxisAlignment:
MainAxisAlignment.center,

children: [
_legend(
Colors.green,
'Present',
presentCount,
),

  const SizedBox(width: 25),

  _legend(
    Colors.red,
    'Absent',
    absentCount,
  ),
],
),
],
),
),

  const SizedBox(height: 24),

  // =================================================
  // ATTENDANCE RECORDS
  // =================================================

  const Text(
    'Attendance Records',
    style: TextStyle(
      fontSize: 18,
      fontWeight:
      FontWeight.bold,
    ),
  ),

  const SizedBox(height: 12),

  if (attendanceRecords.isEmpty)

    Container(
      width: double.infinity,
      padding:
      const EdgeInsets.all(25),

      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(16),
      ),

      child: const Column(
        children: [

          Icon(
            Icons.event_busy,
            size: 50,
            color: Colors.grey,
          ),

          SizedBox(height: 10),

          Text(
            'No attendance records found',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    )

  else

    ListView.builder(
      itemCount:
      attendanceRecords.length,

      shrinkWrap: true,

      physics:
      const NeverScrollableScrollPhysics(),

      itemBuilder:
          (context, index) {

        final record =
        attendanceRecords[index];

        final status =
            record['status'] ?? '';

        final date =
            record[
            'attendance_date'
            ] ??
                '';

        final isPresent =
            status == 'Present';

        return Card(
          margin:
          const EdgeInsets.only(
            bottom: 10,
          ),

          elevation: 2,

          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(
              14,
            ),
          ),

          child: ListTile(

            leading:
            CircleAvatar(
              backgroundColor:
              isPresent
                  ? Colors.green
                  .withOpacity(
                0.15,
              )
                  : Colors.red
                  .withOpacity(
                0.15,
              ),

              child: Icon(
                isPresent
                    ? Icons.check
                    : Icons.close,

                color:
                isPresent
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            title: Text(
              status,

              style:
              TextStyle(
                fontWeight:
                FontWeight.bold,

                color:
                isPresent
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            subtitle:
            Text(
              date.toString(),
            ),
          ),
        );
      },
    ),

  const SizedBox(height: 20),
],
),
),
);
}

  // ----------------------------------------------------------
  // LEGEND
  // ----------------------------------------------------------

  Widget _legend(
      Color color,
      String title,
      int count,
      ) {
    return Row(
      children: [

        Container(
          width: 14,
          height: 14,

          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          '$title ($count)',

          style: const TextStyle(
            fontWeight:
            FontWeight.w500,
          ),
        ),
      ],
    );
  }
}