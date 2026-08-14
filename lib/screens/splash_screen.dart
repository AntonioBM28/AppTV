import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_app/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Logo: scale + fade
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // Texto: slide + fade
  late AnimationController _textController;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  // Barra de progreso
  late AnimationController _progressController;

  // Puntos parpadeantes del tagline
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    // ── Logo ──────────────────────────────────────────
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    // ── Texto ─────────────────────────────────────────
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeIn);

    // ── Barra de progreso ─────────────────────────────
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // ── Dots parpadeantes ─────────────────────────────
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // Secuencia de animaciones
    _logoController.forward().then((_) {
      _textController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _progressController.forward();
      });
    });

    // Navegar al home cuando termine la barra
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) context.goNamed(AppRoutes.home);
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Stack(
        children: [
          // ── Fondo: radial gradient sutil ──────────────
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.2),
                radius: 1.2,
                colors: [
                  Color(0xFF1A0A2E), // violeta muy oscuro centro
                  Color(0xFF0A0A0F), // negro profundo bordes
                ],
              ),
            ),
          ),

          // ── Partículas decorativas (círculos difusos) ──
          Positioned(
            top: -80,
            right: -80,
            child: _GlowCircle(
              size: 300,
              color: const Color(0xFF7C3AED).withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: _GlowCircle(
              size: 250,
              color: const Color(0xFF4F46E5).withValues(alpha: 0.12),
            ),
          ),

          // ── Contenido central ──────────────────────────
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animado
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7C3AED).withValues(alpha: 0.5),
                            blurRadius: 40,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Nombre de la app
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Column(
                      children: [
                        Text(
                          'CineTV',
                          style: GoogleFonts.outfit(
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tu cine, en casa',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Colors.white38,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 64),

                // Barra de progreso
                FadeTransition(
                  opacity: _textFade,
                  child: SizedBox(
                    width: 220,
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: _progressController.value,
                                minHeight: 3,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.08),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFF7C3AED),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        AnimatedBuilder(
                          animation: _dotsController,
                          builder: (context2, child2) {
                            return Text(
                              'Cargando${_dots(_dotsController.value)}',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.white24,
                                letterSpacing: 1,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dots(double value) {
    if (value < 0.33) return '.';
    if (value < 0.66) return '..';
    return '...';
  }
}

// ── Widget auxiliar: círculo difuso decorativo ─────────────────────────────
class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
