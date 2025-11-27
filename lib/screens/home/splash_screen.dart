import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );

    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.elasticOut)),
    );

    _pulse = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0, curve: Curves.easeInOut)),
    );

    _controller.forward();

    // Navigate after 3.3 seconds — feels luxurious
    Future.delayed(const Duration(milliseconds: 3300), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/wrapper');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C), // Deep cosmic purple
      body: Stack(
        children: [
          // Animated gradient background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2 + (_controller.value * 0.5),
                    colors: [
                      const Color(0xFF6B3EFF).withOpacity(0.25),
                      const Color(0xFF4A22FF).withOpacity(0.15),
                      const Color(0xFF0F0A2C),
                    ],
                  ),
                ),
              );
            },
          ),

          // Floating particles (pure magic)
          ...List.generate(8, (i) => _buildParticle(i)),

          // Main content
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing logo with pulse effect
                  AnimatedBuilder(
                    animation: _pulse,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scale.value * _pulse.value,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA855F7), Color(0xFF7C3AED)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9D4EDD).withOpacity(0.6),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                              BoxShadow(
                                color: const Color(0xFF6B3EFF).withOpacity(0.4),
                                blurRadius: 100,
                                spreadRadius: 30,
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                "assets/CareerLiftLogo.png",
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // CareerLift text with gradient
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFD946EF), Color(0xFF8B5CF6), Color(0xFFEC4899)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      "CareerLift",
                      style: GoogleFonts.jomhuria(
                        fontSize: 96,
                        fontWeight: FontWeight.w400,
                        height: 0.8,
                        foreground: Paint()..style = PaintingStyle.fill,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Unlock Your Dream Career",
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      color: Colors.white70,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  const SizedBox(height: 100),

                  // Premium loading dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          double delay = index * 0.1;
                          double opacity = ((-_controller.value + delay + 1) % 1).abs();
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.lerp(
                                Colors.white.withOpacity(0.3),
                                const Color(0xFFD946EF),
                                opacity,
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticle(int index) {
    final random = DateTime.now().millisecondsSinceEpoch + index;
    final size = (random % 30) + 10.0;
    final left = (random % 100) * 3.0;
    final top = (random % 200) * 2.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top - (_controller.value * 300),
          child: Opacity(
            opacity: 1 - _controller.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF9D4EDD).withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}