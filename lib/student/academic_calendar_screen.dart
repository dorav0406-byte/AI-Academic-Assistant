import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AcademicCalendarScreen extends StatefulWidget {
  const AcademicCalendarScreen({super.key});

  @override
  State<AcademicCalendarScreen> createState() =>
      _AcademicCalendarScreenState();
}

class _AcademicCalendarScreenState
    extends State<AcademicCalendarScreen> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> events = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final data = await supabase
        .from('academic_calendar')
        .select();
    List<Map<String, dynamic>> sorted =
    List<Map<String, dynamic>>.from(data);

    sorted.sort((a, b) {
      List<String> d1 = a['Date'].split('/');
      List<String> d2 = b['Date'].split('/');

      DateTime date1 = DateTime(
        int.parse(d1[2]),
        int.parse(d1[1]),
        int.parse(d1[0]),
      );

      DateTime date2 = DateTime(
        int.parse(d2[2]),
        int.parse(d2[1]),
        int.parse(d2[0]),
      );

      return date1.compareTo(date2);
    });

    setState(() {
      events = sorted;
      isLoading = false;
    });

    setState(() {
      events = List<Map<String, dynamic>>.from(data);
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
        title: const Text("Academic Calendar"),
        centerTitle: true,
        backgroundColor: const Color(0xff6C63FF),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: events.length,

        itemBuilder: (context, index) {

          final event = events[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            elevation: 4,

            child: ListTile(

              leading: const CircleAvatar(
                backgroundColor: Color(0xff6C63FF),
                child: Icon(
                  Icons.event,
                  color: Colors.white,
                ),
              ),

              title: Text(
                event['Particulars'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 6),

                  Text("Date : ${event['Date']}"),

                  Text("Day : ${event['Day']}"),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}