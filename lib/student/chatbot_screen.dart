import 'package:flutter/material.dart';
import '../services/openrouter_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatbotScreen extends StatefulWidget {
  final String rollNo;

  const ChatbotScreen({
    super.key,
    required this.rollNo,
  });

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
final OpenRouterService _openRouterService = OpenRouterService();
final supabase = Supabase.instance.client;
final TextEditingController _controller = TextEditingController();
final ScrollController _scrollController = ScrollController();

bool isLoading = false;

List<Map<String, dynamic>> messages = [
{"text": "Hello! 👋", "isUser": false},
{"text": "How can I help you today?", "isUser": false},
];

@override
void dispose() {
_controller.dispose();
_scrollController.dispose();
super.dispose();
}

// ============================================================
// AUTO-SCROLL TO LATEST MESSAGE (UI helper only)
// ============================================================

void _scrollToBottom() {
WidgetsBinding.instance.addPostFrameCallback((_) {
if (_scrollController.hasClients) {
_scrollController.animateTo(
_scrollController.position.maxScrollExtent,
duration: const Duration(milliseconds: 350),
curve: Curves.easeOut,
);
}
});
}

// ============================================================
// ATTENDANCE MARK
// ============================================================

int _getAttendanceMark(double percentage) {
if (percentage > 95) return 5;
if (percentage > 90) return 4;
if (percentage > 85) return 3;
if (percentage > 80) return 2;
if (percentage > 75) return 1;
return 0;
}

// ============================================================
// BUILD ATTENDANCE SUMMARY
// ============================================================

String _buildAttendanceSummary(
List<dynamic> attendanceData) {

const sem5Subjects = [
'Web Technology',
'Web Technology Lab',
'PCD',
'Advanced Java Programming',
'Advanced Java Lab',
'Mobile Application Development',
'MAD Lab',
];

String attendanceSummary = "";

int overallPresent = 0;
int overallAbsent = 0;

for (final subject in sem5Subjects) {
int present = 0;
int absent = 0;

for (final record in attendanceData) {
if (record['subject'] == subject) {
if (record['status'] == 'Present') {
present++;
} else if (record['status'] == 'Absent' ||
record['status'] == 'Leave') {
absent++;
}
}
}

int total = present + absent;

if (total == 0) {
attendanceSummary +=
"$subject\n"
"No attendance data available\n\n";
} else {
double percentage = (present / total) * 100;

int attendanceMark =
_getAttendanceMark(percentage);

attendanceSummary +=
"$subject\n"
"Present: $present\n"
"Absent: $absent\n"
"Percentage: ${percentage.toStringAsFixed(1)}%\n"
"Attendance Mark: $attendanceMark\n\n";

overallPresent += present;
overallAbsent += absent;
}
}

// ============================================================
// OVERALL SEMESTER 5 ATTENDANCE
// ============================================================

int overallTotal =
overallPresent + overallAbsent;

attendanceSummary +=
"OVERALL SEMESTER 5 ATTENDANCE\n";

if (overallTotal == 0) {
attendanceSummary +=
"No attendance data available\n";
} else {
double overallPercentage =
(overallPresent / overallTotal) * 100;

int overallMark =
_getAttendanceMark(overallPercentage);

attendanceSummary +=
"Present: $overallPresent\n"
"Absent: $overallAbsent\n"
"Percentage: ${overallPercentage.toStringAsFixed(1)}%\n"
"Attendance Mark: $overallMark\n";

if (overallPercentage < 75) {
attendanceSummary +=
"Danger Zone: YES\n";
} else {
attendanceSummary +=
"Danger Zone: NO\n";
}
}

return attendanceSummary;
}

// ============================================================
// UI
// ============================================================

@override
Widget build(BuildContext context) {
return Scaffold(
resizeToAvoidBottomInset: true,
backgroundColor: const Color(0xFFF3F4FA),

appBar: PreferredSize(
preferredSize: const Size.fromHeight(70),
child: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xFF6C63FF),
Color(0xFF897BFF),
],
),
boxShadow: [
BoxShadow(
color: Color(0x336C63FF),
blurRadius: 16,
offset: Offset(0, 6),
),
],
),
child: SafeArea(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 8),
child: Row(
children: [
IconButton(
onPressed: () => Navigator.pop(context),
icon: const Icon(
Icons.arrow_back_ios_new_rounded,
color: Colors.white,
size: 20,
),
),
const CircleAvatar(
radius: 19,
backgroundColor: Colors.white24,
child: Icon(
Icons.smart_toy_rounded,
color: Colors.white,
size: 20,
),
),
const SizedBox(width: 10),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"Academic AI Assistant",
style: TextStyle(
color: Colors.white,
fontSize: 16,
fontWeight: FontWeight.w800,
),
),
SizedBox(height: 2),
Text(
"Ask anything about your academics",
style: TextStyle(
color: Color(0xFFEDEBFF),
fontSize: 11.5,
fontWeight: FontWeight.w500,
),
),
],
),
),
Container(
width: 9,
height: 9,
margin: const EdgeInsets.only(right: 12),
decoration: const BoxDecoration(
color: Color(0xFF4CE07A),
shape: BoxShape.circle,
),
),
],
),
),
),
),
),

body: SafeArea(
child: Column(
children: [
Expanded(
child: messages.isEmpty
? const SizedBox.shrink()
: ListView.builder(
controller: _scrollController,
padding: const EdgeInsets.fromLTRB(14, 18, 14, 10),
physics: const BouncingScrollPhysics(
parent: AlwaysScrollableScrollPhysics(),
),
itemCount: messages.length + (isLoading ? 1 : 0),
itemBuilder: (context, index) {
if (index >= messages.length) {
return _typingIndicator();
}
final msg = messages[index];
return chatBubble(msg["text"], msg["isUser"]);
},
),
),

// ---- Input bar ----
Container(
padding: EdgeInsets.fromLTRB(
12,
10,
12,
MediaQuery.of(context).padding.bottom + 10,
),
decoration: BoxDecoration(
color: Colors.white,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.06),
blurRadius: 12,
offset: const Offset(0, -3),
),
],
),
child: Row(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Expanded(
child: Container(
constraints: const BoxConstraints(maxHeight: 120),
decoration: BoxDecoration(
color: const Color(0xFFF1F2F9),
borderRadius: BorderRadius.circular(24),
),
child: TextField(
controller: _controller,
minLines: 1,
maxLines: 5,
textCapitalization: TextCapitalization.sentences,
onSubmitted: (_) => sendMessage(),
decoration: const InputDecoration(
hintText: "Type your message...",
hintStyle: TextStyle(
color: Colors.grey,
fontSize: 14.5,
),
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(
horizontal: 18,
vertical: 14,
),
),
),
),
),
const SizedBox(width: 10),
Container(
decoration: BoxDecoration(
shape: BoxShape.circle,
gradient: const LinearGradient(
colors: [Color(0xFF6C63FF), Color(0xFF897BFF)],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
boxShadow: [
BoxShadow(
color: const Color(0xFF6C63FF).withOpacity(0.35),
blurRadius: 10,
offset: const Offset(0, 4),
),
],
),
child: IconButton(
onPressed: isLoading ? null : sendMessage,
icon: Icon(
isLoading ? Icons.hourglass_top_rounded : Icons.send_rounded,
color: Colors.white,
size: 22,
),
),
),
],
),
),
],
),
),
);
}

// ============================================================
// TYPING INDICATOR (UI only)
// ============================================================

Widget _typingIndicator() {
return Align(
alignment: Alignment.centerLeft,
child: Container(
margin: const EdgeInsets.only(bottom: 10, left: 2),
padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: const BorderRadius.only(
topLeft: Radius.circular(4),
topRight: Radius.circular(18),
bottomLeft: Radius.circular(18),
bottomRight: Radius.circular(18),
),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 8,
offset: const Offset(0, 3),
),
],
),
child: const SizedBox(
height: 14,
child: _TypingDots(),
),
),
);
}

// ============================================================
// SEND MESSAGE
// ============================================================

Future<void> sendMessage() async {
if (_controller.text.trim().isEmpty) return;

String userMessage =
_controller.text.trim();

setState(() {
messages.add({
"text": userMessage,
"isUser": true
});

isLoading = true;
});
_scrollToBottom();

_controller.clear();

try {
// ========================================================
// 1. GET STUDENT SUBJECT MARKS
// ========================================================

final marks = await supabase
.from('student_marks')
.select(
'semester,subject_name,semester_mark')
.eq('rollno', widget.rollNo)
.order('semester');

String studentMarks = "";

for (var mark in marks) {
studentMarks +=
"Semester ${mark['semester']} - "
"${mark['subject_name']}: "
"${mark['semester_mark']}\n";
}

// ========================================================
// 2. GET STUDENT SEMESTER PERCENTAGES
// ========================================================

final percentageData = await supabase
.from('student_semester_percentage')
.select()
.eq('rollno', widget.rollNo)
.single();

String semesterPercentages = "";

for (int sem = 1; sem <= 6; sem++) {
final value =
percentageData['sem${sem}_percentage'];

if (value != null) {
semesterPercentages +=
"Semester $sem: $value%\n";
}
}

// ========================================================
// 3. GET STUDENT ATTENDANCE
// ========================================================

final attendanceData = await supabase
.from('attendance')
.select(
'subject,status,attendance_date,class_time')
.eq('rollno', widget.rollNo);

String attendanceSummary =
_buildAttendanceSummary(attendanceData);

// ========================================================
// 4. SEMESTER 5 SUBJECTS
// ========================================================

const sem5Subjects = '''
Web Technology
Web Technology Lab
PCD
Advanced Java Programming
Advanced Java Lab
Mobile Application Development
MAD Lab
''';

// ========================================================
// 5. SEND EVERYTHING TO AI
// ========================================================

String prompt = '''
You are an Academic AI Assistant for a college student.

Logged-in Student Roll Number:
${widget.rollNo}

--------------------------------------------------
STUDENT'S SUBJECT MARKS
--------------------------------------------------

$studentMarks

--------------------------------------------------
STUDENT'S SEMESTER PERCENTAGES
--------------------------------------------------

$semesterPercentages

--------------------------------------------------
SEMESTER 5 SUBJECTS
--------------------------------------------------

$sem5Subjects

--------------------------------------------------
STUDENT'S SEMESTER 5 ATTENDANCE
--------------------------------------------------

$attendanceSummary

--------------------------------------------------
STUDENT QUESTION
--------------------------------------------------

$userMessage

--------------------------------------------------
IMPORTANT RULES
--------------------------------------------------

1. EXISTING MARK QUESTIONS

If the student asks about their marks, use ONLY the
student's subject marks provided above.

Do not invent marks.

Keep the answer simple.

Example:

Student asks:
"What is my Java mark?"

Answer:

Your Java Programming mark is 87.

Do NOT show the entire database table unless the
student specifically asks for all marks.

--------------------------------------------------

2. SEMESTER PERCENTAGE QUESTIONS

If the student asks for their Semester 1, Semester 2,
Semester 3, etc. percentage, use the semester percentage
data above.

Example:

Student asks:
"What's my Sem 3 percentage?"

Answer:

Your Sem 3 percentage is 82.8%.

--------------------------------------------------

3. OVERALL PERCENTAGE QUESTIONS

If the student asks:

"What is my overall percentage?"
"What is my current overall?"
"What's my average percentage?"

Calculate the average using only the completed
semester percentages available above.

Ignore empty or null future semesters.

--------------------------------------------------

4. NEXT SEMESTER TARGET

If the student asks:

"What should I score in Sem 5 to get 80% overall?"

Calculate the required Sem 5 percentage.

Use:

Required Sem 5 =
(Target Overall × (number of completed semesters + 1))
- sum of completed semester percentages

If the required percentage is above 100%,
tell the student that the target is mathematically
not possible in one semester.

If it is 100% or below, tell the student how much
they need approximately.

--------------------------------------------------

5. ATTENDANCE QUESTIONS

If the student asks about attendance, use ONLY the
attendance data provided above.

For a particular subject, show the information
in this format:

Your Attendance

Present: 12
Absent: 2
Percentage: 85.7%
Attendance Mark: 3

For overall Semester 5 attendance, show:

Overall Semester 5 Attendance

Present: 60
Absent: 10
Percentage: 85.7%
Attendance Mark: 3
Danger Zone: NO

--------------------------------------------------

6. ATTENDANCE SUBJECTS

The current semester is Semester 5.

Semester 5 attendance subjects are:

Web Technology
Web Technology Lab
PCD
Advanced Java Programming
Advanced Java Lab
Mobile Application Development
MAD Lab

Do not use attendance from other subjects.

Do not use attendance from another semester.

--------------------------------------------------

7. ATTENDANCE STATUS

Present counts as Present.

Absent counts as Absent.

Leave counts as Absent.

--------------------------------------------------

8. ATTENDANCE MARK

Use these exact rules:

Above 95% = 5
Above 90% = 4
Above 85% = 3
Above 80% = 2
Above 75% = 1
75% or below = 0

Important:

95% exactly = 4
90% exactly = 3
85% exactly = 2
80% exactly = 1
75% exactly = 0

--------------------------------------------------

9. DANGER ZONE

If overall Semester 5 attendance is below 75%:

Danger Zone: YES

If overall Semester 5 attendance is 75% or above:

Danger Zone: NO

--------------------------------------------------

10. MISSING ATTENDANCE DATA

If attendance data for a subject is not available,
say:

No attendance data available.

Do not invent attendance.

Do not include a subject with no attendance data
when calculating the overall attendance percentage.

--------------------------------------------------

11. DO NOT CHANGE EXISTING MARK BEHAVIOUR

Continue answering existing mark questions using
student_marks.

Do not mix semester percentage data with individual
subject marks.

--------------------------------------------------

12. DO NOT INVENT DATA

If required information is missing, say that the data
is not available.

--------------------------------------------------

13. RESPONSE STYLE

Keep answers short, clear and easy to understand.

Use plain text only.

Do NOT use Markdown symbols.

Do NOT use:

*
**
#
-
_

Do not show SQL.

Do not show JSON.

Do not show database column names.

Do not show unnecessary technical information.

Keep the answer clean and properly aligned.

Student Question:
$userMessage
''';

  // ========================================================
  // 6. SEND TO OPENROUTER
  // ========================================================

  String response =
  await _openRouterService
      .sendMessage(prompt);

  setState(() {
    messages.add({
      "text": response,
      "isUser": false,
    });

    isLoading = false;
  });
  _scrollToBottom();

} catch (e) {
  setState(() {
    messages.add({
      "text": "Something went wrong: $e",
      "isUser": false,
    });

    isLoading = false;
  });
  _scrollToBottom();
}
}

  // ============================================================
  // CHAT BUBBLE
  // ============================================================

  Widget chatBubble(
      String text,
      bool isUser) {

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF6C63FF),
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 15,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              constraints: const BoxConstraints(
                maxWidth: 280,
              ),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF897BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isUser ? null : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isUser ? 18 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isUser
                        ? const Color(0xFF6C63FF).withOpacity(0.25)
                        : Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : const Color(0xFF2B2B33),
                  fontSize: 14.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SMALL ANIMATED "TYPING" DOTS (UI only, no logic involved)
// ============================================================

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_controller.value - (i * 0.2)) % 1.0;
            final scale = 0.6 + (0.4 * (t < 0.5 ? t * 2 : (1 - t) * 2));
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Transform.scale(
                scale: scale.clamp(0.6, 1.0),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6C63FF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}