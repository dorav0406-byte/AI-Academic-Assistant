import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'student_dashboard_screen.dart';
import 'change_password_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() =>
      _StudentLoginScreenState();
}

class _StudentLoginScreenState
    extends State<StudentLoginScreen> {

  final TextEditingController rollNoController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Login"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 30),

            const Icon(
              Icons.school,
              size: 90,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 20),

            const Text(
              "Academic Assistant",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Welcome Back",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 35),

            TextField(
              controller: rollNoController,
              decoration: InputDecoration(
                labelText: "Roll Number",
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "DD/MM/YYYY",
                prefixIcon: const Icon(Icons.lock),

                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword =
                      !obscurePassword;
                    });
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(15),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text("Forgot Password?"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {                  try {
                  final supabase = Supabase.instance.client;

                  final student = await supabase
                      .from('students')
                      .select('email, password_changed')
                      .eq(
                    'rollno',
                    rollNoController.text.trim(),
                  )
                      .maybeSingle();

                  if (student == null) {
                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Roll Number not found"),
                      ),
                    );
                    return;
                  }

                  final String email = student['email'];

                  final bool passwordChanged =
                      student['password_changed'] ?? false;

                  await supabase.auth.signInWithPassword(
                    email: email,
                    password: passwordController.text.trim(),
                  );

                  if (!mounted) return;

                  if (!passwordChanged) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangePasswordScreen(
                          rollNo: rollNoController.text.trim(),
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StudentDashboardScreen(
                              rollNo: rollNoController.text.trim(),
                            ),
                      ),
                    );
                  }
                } on AuthException catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                } on PostgrestException catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}