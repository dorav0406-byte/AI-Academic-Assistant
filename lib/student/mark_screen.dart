import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkScreen extends StatefulWidget {
  final String rollNo;

  const MarkScreen({
    super.key,
    required this.rollNo,
  });

  @override
  State<MarkScreen> createState() => _MarkScreenState();
}

class _MarkScreenState extends State<MarkScreen> {
  final supabase = Supabase.instance.client;

  int selectedSemester = 1;

  List<Map<String, dynamic>> marks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMarks();
  }

  Future<void> loadMarks() async {
    final data = await supabase
        .from('student_marks')
        .select()
        .eq('rollno', widget.rollNo)
        .eq('semester', selectedSemester)
        .order('subject_code');

    setState(() {
      marks = List<Map<String, dynamic>>.from(data);
      isLoading = false;
    });
  }

  Future<void> changeSemester(int sem) async {
    setState(() {
      selectedSemester = sem;
      isLoading = true;
    });

    await loadMarks();
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
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: Text("Semester $selectedSemester Marks"),
        centerTitle: true,
        backgroundColor: const Color(0xff6C63FF),
      ),

      body: Column(
        children: [

          const SizedBox(height: 15),

          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (context, index) {
                final sem = index + 1;

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text("Sem $sem"),
                    selected: selectedSemester == sem,
                    onSelected: (_) {
                      changeSemester(sem);
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor:
                  WidgetStateProperty.all(const Color(0xff6C63FF)),
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  columns: const [

                    DataColumn(
                      label: Text("Code"),
                    ),

                    DataColumn(
                      label: Text("Subject"),
                    ),

                    DataColumn(
                      label: Text("Credit"),
                    ),

                    DataColumn(
                      label: Text("CA"),
                    ),

                    DataColumn(
                      label: Text("CE"),
                    ),

                    DataColumn(
                      label: Text("Semester"),
                    ),

                    DataColumn(
                      label: Text("Result"),
                    ),
                  ],

                  rows: marks.map((row) {
                    return DataRow(
                      cells: [

                        DataCell(
                          Text(row['subject_code'].toString()),
                        ),

                        DataCell(
                          Text(row['subject_name'].toString()),
                        ),

                        DataCell(
                          Text(row['credit'].toString()),
                        ),

                        DataCell(
                          Text(row['ca'].toString()),
                        ),

                        DataCell(
                          Text(row['ce'].toString()),
                        ),

                        DataCell(
                          Text(row['semester_mark'].toString()),
                        ),

                        DataCell(
                          Text(row['result'].toString()),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}