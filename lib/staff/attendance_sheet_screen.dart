import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceSheetScreen extends StatefulWidget {
  final String staffId;

  const AttendanceSheetScreen({
    super.key,
    required this.staffId,
  });

  @override
  State<AttendanceSheetScreen> createState() =>
      _AttendanceSheetScreenState();
}

class _AttendanceSheetScreenState extends State<AttendanceSheetScreen> {
final supabase = Supabase.instance.client;

// ----------------------------------------------------------
// CLASS SELECTION
// ----------------------------------------------------------

String selectedYear = "III";
String selectedSection = "A";
String selectedDepartment = "Computer Science";

DateTime selectedDate = DateTime.now();

// Selected class from timetable
String? selectedClassTime;
String? selectedSubject;

// ----------------------------------------------------------
// DATA
// ----------------------------------------------------------

List<Map<String, dynamic>> students = [];

List<Map<String, dynamic>> todayClasses = [];

bool isLoading = true;
bool isSaving = false;
bool isCheckingTimetable = false;

String searchText = "";

final TextEditingController searchController =
TextEditingController();

// ----------------------------------------------------------
// STAFF SUBJECT ASSIGNMENTS
// ----------------------------------------------------------

final Map<String, List<String>> staffSubjects = {
'S1': [
'Web Technology',
'Web Technology Lab',
],
'S2': [
'PCD',
],
'S3': [
'Advanced Java Programming',
'Advanced Java Lab',
],
'S4': [
'Mobile Application Development',
'MAD Lab',
],
};

// ----------------------------------------------------------
// INIT
// ----------------------------------------------------------

@override
void initState() {
super.initState();

loadForSelectedDate();
}

// ----------------------------------------------------------
// MAIN LOAD
// ----------------------------------------------------------
  Future<void> loadForSelectedDate() async {
    setState(() {
      isLoading = true;
      isCheckingTimetable = true;
      todayClasses = [];
      selectedClassTime = null;
      selectedSubject = null;
      students = [];
    });

    try {
      // 1. Get Day order from Academic Calendar
      final dayOrder = await getDayOrderFromCalendar();

      if (dayOrder == null) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          isCheckingTimetable = false;
        });

        showMessage(
          "No academic calendar entry found for this date",
          Colors.orange,
        );

        return;
      }

      debugPrint("DAY ORDER RESULT: $dayOrder");

      // 2. Get staff timetable for that day
      await loadTodayClasses(dayOrder);

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isCheckingTimetable = false;
      });

      // 3. Automatically select first class
      if (todayClasses.isNotEmpty) {
        final firstClass = todayClasses.first;

        setState(() {
          selectedClassTime = firstClass['time'];
          selectedSubject = firstClass['subject'];
        });

        await loadStudents();
      }
    } catch (e) {
      debugPrint("LOAD ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
        isCheckingTimetable = false;
      });

      showMessage(
        "Unable to load attendance: $e",
        Colors.red,
      );
    }
  }

// ----------------------------------------------------------
// GET DAY ORDER FROM ACADEMIC CALENDAR
// ----------------------------------------------------------

  Future<String?> getDayOrderFromCalendar() async {
    final date = selectedDate.toIso8601String().split('T')[0];

    final data = await supabase
        .from('dayorder')
        .select('*')
        .eq('date', date)
        .maybeSingle();

    debugPrint("ACADEMIC CALENDAR DATA: $data");

    if (data == null) {
      return null;
    }

    // Exact column name from CSV
    final dayValue = data['day_order'] ?? data['dayorder'];

    if (dayValue == null || dayValue.toString().trim().isEmpty) {
      return null;
    }

    String day = dayValue.toString().trim().toUpperCase();

    // Convert Roman numerals from spreadsheet to integer strings
    switch (day) {
      case 'I':
      case 'DAY I':
      case 'DAY 1':
        return '1';

      case 'II':
      case 'DAY II':
      case 'DAY 2':
        return '2';

      case 'III':
      case 'DAY III':
      case 'DAY 3':
        return '3';

      case 'IV':
      case 'DAY IV':
      case 'DAY 4':
        return '4';

      case 'V':
      case 'DAY V':
      case 'DAY 5':
        return '5';

      case 'VI':
      case 'DAY VI':
      case 'DAY 6':
        return '6';

      default:
        return day;
    }
  }

// ----------------------------------------------------------
// LOAD STAFF TIMETABLE
// ----------------------------------------------------------

  Future<void> loadTodayClasses(String dayOrder) async {
    final dayInt = int.tryParse(dayOrder);

    if (dayInt == null) {
      debugPrint("Invalid day order: $dayOrder");
      return;
    }

    try {
      // Get timetable for selected Year + Section + Day Order
      final data = await supabase
          .from('timetable')
          .select(
        'day_order, period1, period2, period3, period4, period5',
      )
          .eq('year', selectedYear)
          .eq('section', selectedSection)
          .eq('day_order', dayInt)
          .maybeSingle();

      debugPrint("STUDENT TIMETABLE: $data");

      if (data == null) {
        if (!mounted) return;

        setState(() {
          todayClasses = [];
        });

        return;
      }

      // Period timings
      final periodTimes = {
        'period1': '10:00 AM – 11:00 AM',
        'period2': '11:00 AM – 12:00 PM',
        'period3': '12:15 PM – 1:15 PM',
        'period4': '2:00 PM – 3:00 PM',
        'period5': '3:00 PM – 4:00 PM',
      };

      // Subjects handled by each staff
      final assignedSubjects = staffSubjects[widget.staffId] ?? [];

      // Convert staff subjects to timetable codes
      final subjectCodes = assignedSubjects.map((subject) {
        switch (subject.toUpperCase()) {
          case 'WEB TECHNOLOGY':
            return 'WT';
          case 'WEB TECHNOLOGY LAB':
            return 'WT LAB';
          case 'ADVANCED JAVA PROGRAMMING':
            return 'AJAVA';
          case 'ADVANCED JAVA LAB':
            return 'AJAVA LAB';
          case 'MOBILE APPLICATION DEVELOPMENT':
            return 'MAD';
          case 'MAD LAB':
            return 'MAD LAB';
          case 'PCD':
            return 'PCD';
          default:
            return subject.toUpperCase();
        }
      }).toSet();

      final List<Map<String, dynamic>> classes = [];

      for (final period in periodTimes.keys) {
        final subjectCode =
        data[period]?.toString().trim().toUpperCase();

        if (subjectCode == null || subjectCode.isEmpty) {
          continue;
        }

        // Only show subjects belonging to this staff
        if (!subjectCodes.contains(subjectCode)) {
          continue;
        }

        String displaySubject;

        switch (subjectCode) {
          case 'WT':
            displaySubject = 'Web Technology';
            break;

          case 'WT LAB':
            displaySubject = 'Web Technology Lab';
            break;

          case 'AJAVA':
            displaySubject = 'Advanced Java Programming';
            break;

          case 'AJAVA LAB':
            displaySubject = 'Advanced Java Lab';
            break;

          case 'MAD':
            displaySubject = 'Mobile Application Development';
            break;

          case 'MAD LAB':
            displaySubject = 'MAD Lab';
            break;

          case 'PCD':
            displaySubject = 'PCD';
            break;

          default:
            displaySubject = subjectCode;
        }

        classes.add({
          'time': periodTimes[period],
          'subject': displaySubject,
        });
      }

      if (!mounted) return;

      setState(() {
        todayClasses = classes;
      });

      debugPrint("TODAY CLASSES: $todayClasses");
    } catch (e) {
      debugPrint("TIMETABLE ERROR: $e");

      if (!mounted) return;

      setState(() {
        todayClasses = [];
      });
    }
  }

Future<void> loadStudents() async {
if (selectedSubject == null) {
return;
}

setState(() {
isLoading = true;
});

try {
final data = await supabase
.from('students')
.select(
'rollno, name, department, section, year',
)
.eq('department', selectedDepartment)
.eq('year', selectedYear)
.eq('section', selectedSection)
.order('rollno');

debugPrint("FILTERED STUDENTS: $data");

final studentList = data.map<Map<String, dynamic>>(
(student) {
return {
'rollno': student['rollno'],
'name': student['name'],

// null = Not Entered
// true = Present
// false = Absent
'status': null,
};
},
).toList();

if (!mounted) return;

setState(() {
students = studentList;
isLoading = false;
});

await loadAttendance();
} catch (e) {
debugPrint("STUDENT LOAD ERROR: $e");

if (!mounted) return;

setState(() {
isLoading = false;
});

showMessage(
"Unable to load students: $e",
Colors.red,
);
}
}

// ----------------------------------------------------------
// LOAD EXISTING ATTENDANCE
// ----------------------------------------------------------

Future<void> loadAttendance() async {
if (selectedSubject == null ||
selectedClassTime == null) {
return;
}

try {
// IMPORTANT:
// Reset every student to Not Entered first.
for (final student in students) {
student['status'] = null;
}

final date =
selectedDate.toIso8601String().split('T')[0];

final data = await supabase
.from('attendance')
.select('rollno, status, class_time')
.eq('subject', selectedSubject!)
.eq('attendance_date', date)
.eq('class_time', selectedClassTime!);

debugPrint("ATTENDANCE RECORDS: $data");

for (final record in data) {
final rollNo = record['rollno'];

final index = students.indexWhere(
(student) => student['rollno'] == rollNo,
);

if (index != -1) {
final status = record['status'];

if (status == 'Present') {
students[index]['status'] = true;
} else if (status == 'Absent') {
students[index]['status'] = false;
}
}
}

if (!mounted) return;

setState(() {});
} catch (e) {
debugPrint("ATTENDANCE LOAD ERROR: $e");
}
}

// ----------------------------------------------------------
// SAVE ATTENDANCE
// ----------------------------------------------------------

Future<void> saveAttendance() async {
if (selectedSubject == null ||
selectedClassTime == null) {
showMessage(
"Please select a class",
Colors.orange,
);

return;
}

if (students.isEmpty) {
showMessage(
"No students to save attendance",
Colors.orange,
);

return;
}

setState(() {
isSaving = true;
});

try {
final date =
selectedDate.toIso8601String().split('T')[0];

final className =
"$selectedYear B.Sc $selectedDepartment - Sec $selectedSection";

// Save ONLY Present / Absent.
//
// Not Entered students are NOT inserted.
final records = students
.where((student) => student['status'] != null)
.map<Map<String, dynamic>>((student) {
return {
'rollno': student['rollno'],
'student_name': student['name'],
'class_name': className,
'subject': selectedSubject,
'attendance_date': date,
'class_time': selectedClassTime,
'status': student['status'] == true
? 'Present'
: 'Absent',
};
}).toList();

if (records.isEmpty) {
showMessage(
"No attendance marked. Nothing to save.",
Colors.orange,
);

setState(() {
isSaving = false;
});

return;
}

await supabase
.from('attendance')
.upsert(
records,
onConflict:
'rollno,subject,attendance_date,class_time',
);

if (!mounted) return;

showMessage(
"Attendance saved successfully",
Colors.green,
);

await loadAttendance();
} catch (e) {
debugPrint("SAVE ERROR: $e");

if (!mounted) return;

showMessage(
"Error saving attendance: $e",
Colors.red,
);
}

if (mounted) {
setState(() {
isSaving = false;
});
}
}

// ----------------------------------------------------------
// DATE PICKER
// ----------------------------------------------------------

Future<void> pickDate() async {
final picked = await showDatePicker(
context: context,
initialDate: selectedDate,
firstDate: DateTime(2025, 1, 1),
lastDate: DateTime(2030, 12, 31),
);

if (picked == null) {
return;
}

setState(() {
selectedDate = picked;
});

await loadForSelectedDate();
}

// ----------------------------------------------------------
// DATE LIST
// ----------------------------------------------------------

List<DateTime> getDates() {
return List.generate(
15,
(index) {
return DateTime.now().subtract(
Duration(days: 7 - index),
);
},
);
}

// ----------------------------------------------------------
// SELECT CLASS
// ----------------------------------------------------------

Future<void> selectClass(
Map<String, dynamic> classData,
) async {
setState(() {
selectedClassTime = classData['time'];
selectedSubject = classData['subject'];

// Reset before loading another session
for (final student in students) {
student['status'] = null;
}
});

await loadStudents();
}

// ----------------------------------------------------------
// MESSAGE
// ----------------------------------------------------------

void showMessage(
String message,
Color color,
) {
if (!mounted) return;

ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: Text(message),
backgroundColor: color,
),
);
}

// ----------------------------------------------------------
// BUILD
// ----------------------------------------------------------

@override
Widget build(BuildContext context) {
final filteredStudents = students.where((student) {
final name =
student['name'].toString().toLowerCase();

final rollNo =
student['rollno'].toString().toLowerCase();

return name.contains(
searchText.toLowerCase(),
) ||
rollNo.contains(
searchText.toLowerCase(),
);
}).toList();

return Scaffold(
backgroundColor: const Color(0xffF5F7FB),

// ------------------------------------------------------
// APP BAR
// ------------------------------------------------------

appBar: AppBar(
backgroundColor: const Color(0xff6C63FF),
foregroundColor: Colors.white,
centerTitle: true,
title: Text(
"Attendance Sheet - ${widget.staffId}",
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
),

// ------------------------------------------------------
// BODY
// ------------------------------------------------------

body: Column(
children: [

// --------------------------------------------------
// DATE SELECTOR
// --------------------------------------------------

SizedBox(
height: 85,
child: ListView.builder(
scrollDirection: Axis.horizontal,
padding: const EdgeInsets.symmetric(
horizontal: 12,
),
itemCount: getDates().length + 1,
itemBuilder: (context, index) {

// Calendar button
if (index == getDates().length) {
return GestureDetector(
onTap: pickDate,
child: Container(
width: 60,
margin: const EdgeInsets.symmetric(
horizontal: 5,
vertical: 5,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(15),
border: Border.all(
color: const Color(0xff6C63FF),
),
),
child: const Icon(
Icons.calendar_month,
color: Color(0xff6C63FF),
),
),
);
}

final date = getDates()[index];

final selected =
date.year == selectedDate.year &&
date.month == selectedDate.month &&
date.day == selectedDate.day;

return GestureDetector(
onTap: () async {
setState(() {
selectedDate = date;
});

await loadForSelectedDate();
},
child: Container(
width: 65,
margin: const EdgeInsets.symmetric(
horizontal: 5,
vertical: 5,
),
decoration: BoxDecoration(
color: selected
? const Color(0xff6C63FF)
: Colors.white,
borderRadius:
BorderRadius.circular(15),
boxShadow: [
BoxShadow(
color:
Colors.black.withOpacity(0.08),
blurRadius: 5,
),
],
),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Text(
dayName(date),
style: TextStyle(
color: selected
? Colors.white70
: Colors.grey,
fontSize: 12,
),
),
Text(
"${date.day}",
style: TextStyle(
color: selected
? Colors.white
: Colors.black,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
Text(
monthName(date),
style: TextStyle(
color: selected
? Colors.white70
: Colors.grey,
fontSize: 11,
),
),
],
),
),
);
},
),
),

// --------------------------------------------------
// DATE INFORMATION
// --------------------------------------------------

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 5,
),
child: Align(
alignment: Alignment.centerLeft,
child: Text(
"Attendance for "
"${selectedDate.day}/"
"${selectedDate.month}/"
"${selectedDate.year}",
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
),
),
),
),

// --------------------------------------------------
// YEAR + SECTION
// --------------------------------------------------

Padding(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 5,
),
child: Row(
children: [

Expanded(
child: DropdownButtonFormField<String>(
value: selectedYear,
decoration:
const InputDecoration(
labelText: "Year",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(
value: "I",
child: Text("I Year"),
),
DropdownMenuItem(
value: "II",
child: Text("II Year"),
),
DropdownMenuItem(
value: "III",
child: Text("III Year"),
),
],
onChanged: (value) async {
if (value == null) return;

setState(() {
selectedYear = value;
});

await loadStudents();
},
),
),

const SizedBox(width: 8),

Expanded(
child: DropdownButtonFormField<String>(
value: selectedSection,
decoration:
const InputDecoration(
labelText: "Section",
border: OutlineInputBorder(),
),
items: const [
DropdownMenuItem(
value: "A",
child: Text("Sec A"),
),
DropdownMenuItem(
value: "B",
child: Text("Sec B"),
),
DropdownMenuItem(
value: "C",
child: Text("Sec C"),
),
],
onChanged: (value) async {
if (value == null) return;

setState(() {
selectedSection = value;
});

await loadStudents();
},
),
),
],
),
),

// --------------------------------------------------
// TODAY'S CLASSES
// --------------------------------------------------

if (isCheckingTimetable)
const Padding(
padding: EdgeInsets.all(15),
child: CircularProgressIndicator(),
)
else if (todayClasses.isEmpty)
Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Colors.white,
borderRadius:
BorderRadius.circular(15),
),
child: Column(
children: [
const Icon(
Icons.event_busy,
size: 45,
color: Colors.grey,
),
const SizedBox(height: 8),
const Text(
"No classes scheduled today",
style: TextStyle(
fontSize: 16,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
"No class assigned to ${widget.staffId}",
style: const TextStyle(
color: Colors.grey,
),
),
],
),
)
else
SizedBox(
height: 80,
child: ListView.builder(
scrollDirection: Axis.horizontal,
padding:
const EdgeInsets.symmetric(
horizontal: 12,
),
itemCount: todayClasses.length,
itemBuilder: (context, index) {
final classData =
todayClasses[index];

final isSelected =
selectedClassTime ==
classData['time'] &&
selectedSubject ==
classData['subject'];

return GestureDetector(
onTap: () {
selectClass(classData);
},
child: Container(
width: 190,
margin:
const EdgeInsets.symmetric(
horizontal: 5,
vertical: 5,
),
padding:
const EdgeInsets.all(10),
decoration: BoxDecoration(
color: isSelected
? const Color(0xff6C63FF)
: Colors.white,
borderRadius:
BorderRadius.circular(15),
boxShadow: [
BoxShadow(
color: Colors.black
.withOpacity(0.08),
blurRadius: 5,
),
],
),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
classData['time'],
style: TextStyle(
color: isSelected
? Colors.white
: Colors.grey,
fontSize: 12,
fontWeight:
FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
classData['subject'],
overflow:
TextOverflow.ellipsis,
style: TextStyle(
color: isSelected
? Colors.white
: Colors.black,
fontSize: 14,
fontWeight:
FontWeight.bold,
),
),
],
),
),
);
},
),
),

// --------------------------------------------------
// SELECTED CLASS
// --------------------------------------------------

if (selectedSubject != null &&
selectedClassTime != null)
Container(
width: double.infinity,
margin: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 5,
),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: const Color(0xff6C63FF)
.withOpacity(0.1),
borderRadius:
BorderRadius.circular(15),
),
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
selectedSubject!,
style: const TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 4),
Text(
selectedClassTime!,
style: const TextStyle(
color: Colors.grey,
),
),
],
),
),

// --------------------------------------------------
// SEARCH
// --------------------------------------------------

if (selectedSubject != null)
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 6,
),
child: TextField(
controller: searchController,
onChanged: (value) {
setState(() {
searchText = value;
});
},
decoration: InputDecoration(
hintText:
"Search Student Name or Roll No",
prefixIcon:
const Icon(Icons.search),
border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(15),
),
filled: true,
fillColor: Colors.white,
),
),
),

// --------------------------------------------------
// STUDENT LIST
// --------------------------------------------------

Expanded(
child: isLoading
? const Center(
child:
CircularProgressIndicator(),
)
: selectedSubject == null
? const Center(
child: Text(
"Select a class to mark attendance",
style: TextStyle(
color: Colors.grey,
fontSize: 16,
),
),
)
: filteredStudents.isEmpty
? const Center(
child: Text(
"No students found",
style: TextStyle(
color: Colors.grey,
),
),
)
: ListView.builder(
padding:
const EdgeInsets
.symmetric(
horizontal: 16,
),
itemCount:
filteredStudents.length,
itemBuilder:
(context, index) {
final student =
filteredStudents[index];

final status =
student['status'];

return Card(
margin:
const EdgeInsets.only(
bottom: 10,
),
shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius
.circular(15),
),
child: Padding(
padding:
const EdgeInsets
.all(14),
child: Column(
crossAxisAlignment:
CrossAxisAlignment
.start,
children: [

Text(
student['name'],
style:
const TextStyle(
fontSize: 17,
fontWeight:
FontWeight
.bold,
),
),

const SizedBox(
height: 2,
),

Text(
student['rollno'],
style:
const TextStyle(
color: Colors
.grey,
),
),

const SizedBox(
height: 10,
),

Row(
children: [

// PRESENT
Expanded(
child:
ElevatedButton(
style:
ElevatedButton
.styleFrom(
backgroundColor:
status ==
true
? Colors
.green
: Colors
.grey
.shade300,
foregroundColor:
status ==
true
? Colors
.white
: Colors
.black,
),
onPressed:
() {
setState(() {
student[
'status'] =
true;
});
},
child:
const Text(
"Present",
),
),
),

const SizedBox(
width: 8,
),

// ABSENT
Expanded(
child:
ElevatedButton(
style:
ElevatedButton
.styleFrom(
backgroundColor:
status ==
false
? Colors
.red
: Colors
.grey
.shade300,
foregroundColor:
status ==
false
? Colors
.white
: Colors
.black,
),
onPressed:
() {
setState(() {
student[
'status'] =
false;
});
},
child:
const Text(
"Absent",
),
),
),

],
),

const SizedBox(
height: 5,
),

// NOT ENTERED
if (status == null)
const Text(
"Not Entered",
style:
TextStyle(
color:
Colors.grey,
fontSize: 12,
),
),

],
),
),
);
},
),
),

// --------------------------------------------------
// SAVE BUTTON
// --------------------------------------------------

if (selectedSubject != null)
Padding(
padding:
const EdgeInsets.all(16),
child: SizedBox(
width: double.infinity,
height: 52,
child: ElevatedButton.icon(
style:
ElevatedButton.styleFrom(
backgroundColor:
const Color(0xff6C63FF),
foregroundColor:
Colors.white,
shape:
RoundedRectangleBorder(
borderRadius:
BorderRadius.circular(15),
),
),
onPressed:isSaving
    ? null
    : saveAttendance,
  icon: isSaving
      ? const SizedBox(
    height: 20,
    width: 20,
    child:
    CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 2,
    ),
  )
      : const Icon(Icons.save),
  label: Text(
    isSaving
        ? "Saving..."
        : "Save Attendance",
    style:
    const TextStyle(
      fontSize: 16,
      fontWeight:
      FontWeight.bold,
    ),
  ),
),
),
),
],
),
);
}

  // ----------------------------------------------------------
  // HELPERS
  // ----------------------------------------------------------

  String dayName(DateTime date) {
    const days = [
      "Mon",
      "Tue",
      "Wed",
      "Thu",
      "Fri",
      "Sat",
      "Sun",
    ];

    return days[date.weekday - 1];
  }

  String monthName(DateTime date) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    return months[date.month - 1];
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}