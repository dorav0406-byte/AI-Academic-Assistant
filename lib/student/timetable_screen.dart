import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimetableScreen extends StatefulWidget {
  final String year;
  final String section;

  const TimetableScreen({
    super.key,
    required this.year,
    required this.section,
  });

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> timetable = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTimetable();
  }

  Future<void> loadTimetable() async {
    final data = await supabase
        .from('timetable')
        .select()
        .eq('year', widget.year)
        .eq('section', widget.section)
        .order('day_order',
    ascending:true);

    setState(() {
      timetable = List<Map<String, dynamic>>.from(data);
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
      appBar: AppBar(
        title: Text(
          "${widget.year} B.Sc Computer Science ${widget.section}",
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),

      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(
              color: Colors.black,
              width: 1.5,
            ),

            defaultColumnWidth:
            const FixedColumnWidth(110),

            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                children:  [

                  tableHeader("DAY"),

                  tableHeader("10-11"),

                  tableHeader("11-12"),

                  tableHeader("BREAK"),

                  tableHeader("12:15-1:15"),

                  tableHeader("LUNCH"),

                  tableHeader("2-3"),

                  tableHeader("3-4"),
                ],
              ),
              ...timetable.map(
                    (row) => TableRow(
                  children: [

                    tableCell(row['day_order']),

                    tableCell(row['period1']),

                    tableCell(row['period2']),

                    tableBreakCell("BREAK"),

                    tableCell(row['period3']),

                    tableBreakCell("LUNCH"),

                    tableCell(row['period4']),

                    tableCell(row['period5']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget tableHeader(String text) {
    return Container(
      height: 55,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  static Widget tableCell(dynamic text) {
    return Container(
      height: 65,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      child: Text(
        text?.toString() ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static Widget tableBreakCell(String text) {
    return Container(
      height: 65,
      alignment: Alignment.center,
      color: Colors.grey.shade200,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
    );
  }
}