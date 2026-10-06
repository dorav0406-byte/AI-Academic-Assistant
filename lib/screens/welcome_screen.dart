import 'package:flutter/material.dart';
import 'portal_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4B3FE4),
                  Color(0xFF6C63FF),
                  Color(0xFF9B8CFF),
                ],
              ),
            ),
          ),

          // Decorative soft glow circles for depth
          Positioned(
            top: -80,
            left: -60,
            child: _GlowCircle(size: 220, opacity: 0.16),
          ),
          Positioned(
            bottom: -100,
            right: -70,
            child: _GlowCircle(size: 260, opacity: 0.14),
          ),
          Positioned(
            top: 140,
            right: -40,
            child: _GlowCircle(size: 120, opacity: 0.12),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ---- Logo badge ----
                      Container(
                        height: 108,
                        width: 108,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 52,
                            ),
                            Positioned(
                              bottom: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFC857),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF4B3FE4),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.auto_awesome_rounded,
                                  color: Color(0xFF4B3FE4),
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ---- Project name ----
                      const Text(
                        "AI Academic\nAssistant",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .3,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ---- Tagline chip ----
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.14),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chat_bubble_rounded,
                              color: Color(0xFFFFC857),
                              size: 15,
                            ),
                            SizedBox(width: 7),
                            Text(
                              "Smart Chatbot for Your Campus",
                              style: TextStyle(
                                color: Color(0xFFF3F2FF),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      const Text(
                        "Marks, attendance, timetable and more —\n"
                            "ask your assistant anything, anytime.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFE3E1FF),
                          fontSize: 15,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 42),

                      // ---- Feature highlights row ----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          _FeatureDot(
                            icon: Icons.grade_rounded,
                            label: "Marks",
                          ),
                          SizedBox(width: 22),
                          _FeatureDot(
                            icon: Icons.event_available_rounded,
                            label: "Attendance",
                          ),
                          SizedBox(width: 22),
                          _FeatureDot(
                            icon: Icons.schedule_rounded,
                            label: "Timetable",
                          ),
                        ],
                      ),

                      const SizedBox(height: 46),

                      // ---- CTA button ----
                      SizedBox(
                        width: 240,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PortalScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1B33),
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shadowColor: Colors.black.withOpacity(0.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Get Started",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Built for students. Powered by AI.",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft blurred glow circle used as a background decoration.
class _GlowCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

/// Small icon + label used to preview key features on the welcome screen.
class _FeatureDot extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureDot({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.14),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Icon(icon, color: Colors.white, size: 21),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE3E1FF),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}