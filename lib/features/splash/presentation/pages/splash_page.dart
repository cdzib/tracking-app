import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vagonetas_app/features/home/presentation/pages/navigation_page.dart';
import 'package:vagonetas_app/features/auth/presentation/pages/login_page.dart';
import 'package:vagonetas_app/core/auth/auth_session.dart';
import 'package:get_it/get_it.dart';
import 'dart:math' as math;

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressWidth;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0D0D0D),
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _logoScale =
        CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack)
            .drive(Tween(begin: 0.4, end: 1.0));
    _logoOpacity =
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn)
            .drive(Tween(begin: 0.0, end: 1.0));
    _textOpacity =
        CurvedAnimation(parent: _textController, curve: Curves.easeIn)
            .drive(Tween(begin: 0.0, end: 1.0));
    _textSlide =
        CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic)
            .drive(Tween(begin: const Offset(0, 0.4), end: Offset.zero));
    _progressWidth =
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut)
            .drive(Tween(begin: 1.0, end: 1.0));
    _pulse = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut)
        .drive(Tween(begin: 0.95, end: 1.05));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _progressController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _checkSession();
  }

  Future<void> _checkSession() async {
    final authSession = GetIt.I<AuthSession>();
    final isLoggedIn = await authSession.isLoggedIn();
    await _progressController.forward();
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 300));
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const NavigationPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const LoginPage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── Ambient background ─────────────────────────────────────────
          Positioned.fill(
            child: CustomPaint(painter: _SplashAmbientPainter()),
          ),

          // ── Línea dorada superior ──────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color(0xFFD4A853),
                    Color(0xFFF0C97A),
                    Color(0xFFD4A853),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Anillos decorativos ────────────────────────────────────────
          Positioned(
            top: size.height * 0.12,
            right: -60,
            child: _DecorativeRing(size: 180, opacity: 0.06),
          ),
          Positioned(
            bottom: size.height * 0.18,
            left: -40,
            child: _DecorativeRing(size: 140, opacity: 0.05),
          ),

          // ── Contenido principal ────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo
                AnimatedBuilder(
                  animation:
                      Listenable.merge([_logoController, _pulseController]),
                  builder: (_, __) => Opacity(
                    opacity: _logoOpacity.value,
                    child: Transform.scale(
                      scale: _logoScale.value * _pulse.value,
                      child: _LogoWidget(),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Nombre + tagline
                AnimatedBuilder(
                  animation: _textController,
                  builder: (_, __) => Opacity(
                    opacity: _textOpacity.value,
                    child: SlideTransition(
                      position: _textSlide,
                      child: Column(
                        children: [
                          const Text(
                            'VAGONETAS',
                            style: TextStyle(
                              color: Color(0xFFD4A853),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 6,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tu viaje, tu destino',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.38),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Barra de progreso
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Column(
                      children: [
                        _AnimatedDots(controller: _progressController, dotCount: 4),
                        const SizedBox(height: 14),
                        Text(
                          'Iniciando sesión...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.25),
                            fontSize: 11,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Version
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.15),
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logo widget ──────────────────────────────────────────────────────────────

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF161616),
        border: Border.all(
            color: const Color(0xFFD4A853).withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A853).withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 4,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 62,
          height: 62,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.directions_bus_rounded,
            size: 52,
            color: Color(0xFFD4A853),
          ),
        ),
      ),
    );
  }
}

// ── Anillo decorativo ────────────────────────────────────────────────────────

class _DecorativeRing extends StatelessWidget {
  final double size;
  final double opacity;
  const _DecorativeRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD4A853).withOpacity(opacity),
          width: 1,
        ),
      ),
    );
  }
}

// ── Ambient painter ──────────────────────────────────────────────────────────

class _SplashAmbientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFD4A853).withOpacity(0.14),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.5, size.height * 0.38),
          radius: size.width * 0.7,
        )),
    );
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFF1A2A4A).withOpacity(0.6),
            Colors.transparent,
          ],
        ).createShader(Rect.fromCircle(
          center: Offset(size.width * 0.1, size.height * 0.85),
          radius: size.width * 0.8,
        )),
    );
  }

  @override
  bool shouldRepaint(_SplashAmbientPainter old) => false;
}

class _AnimatedDots extends StatefulWidget {
  final AnimationController controller;
  final int dotCount;
  const _AnimatedDots({required this.controller, this.dotCount = 3});

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotOpacities;

  @override
  void initState() {
    super.initState();
    _dotControllers = List.generate(
      widget.dotCount,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _dotOpacities = _dotControllers.map((c) {
      return CurvedAnimation(parent: c, curve: Curves.easeInOut)
          .drive(Tween(begin: 0.2, end: 1.0));
    }).toList();

    _startLoop();
  }

  Future<void> _startLoop() async {
    while (mounted) {
      for (int i = 0; i < _dotControllers.length; i++) {
        if (!mounted) break;
        await _dotControllers[i].forward();
        await _dotControllers[i].reverse();
        await Future.delayed(const Duration(milliseconds: 80));
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }

  @override
  void dispose() {
    for (final c in _dotControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.dotCount, (i) {
        return AnimatedBuilder(
          animation: _dotControllers[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  const Color(0xFFD4A853).withOpacity(_dotOpacities[i].value),
            ),
          ),
        );
      }),
    );
  }
}
