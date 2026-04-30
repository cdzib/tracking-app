import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';

import '../../../../core/config/api_config.dart';
import '../viewmodel/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = Provider.of<AuthViewModel>(context, listen: false);
    if (vm.isAuthenticated) {
      // Redirigir automáticamente al home si ya está autenticado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Consumer<AuthViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              // ── Atmospheric background ──────────────────────────
              Positioned.fill(
                child: CustomPaint(painter: AmbientPainter(colorScheme)),
              ),

              // ── Decorative top accent line ───────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        colorScheme.primary,
                        colorScheme.secondary,
                        colorScheme.primary,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // ── Main content ─────────────────────────────────────
              SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Stack(
                      children: [
                        // ── Header section ────────────────────────
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 40, 32, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo / brand mark
                              Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: colorScheme.secondary,
                                        width: 1.5,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.explore_outlined,
                                      color: colorScheme.secondary,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'VIAJA',
                                    style: TextStyle(
                                      color: colorScheme.secondary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 4,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 48),

                              // Headline
                              Text(
                                'Accede a\ntu viaje.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 44,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                  letterSpacing: -1.5,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Tus reservas te están esperando.',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 14,
                                  letterSpacing: 0.2,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // ── Form card ─────────────────────────────
                        DraggableScrollableSheet(
                          initialChildSize: 0.65,
                          minChildSize: 0.65,
                          maxChildSize: 1.0,
                          builder: (context, scrollController) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF161616),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(32),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x40000000),
                                    blurRadius: 40,
                                    offset: Offset(0, -8),
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.fromLTRB(28, 32, 28, 24),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // ── Drag handle ───────────────
                                    Center(
                                      child: Container(
                                        width: 36,
                                        height: 3,
                                        margin:
                                            const EdgeInsets.only(bottom: 28),
                                        decoration: BoxDecoration(
                                          color: Colors.white12,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                    ),

                                    // ── Email field ───────────────
                                    _FieldLabel(label: 'CORREO ELECTRÓNICO'),
                                    const SizedBox(height: 8),
                                    _StyledTextField(
                                      controller: vm.emailController,
                                      hint: 'tu@correo.com',
                                      keyboardType: TextInputType.emailAddress,
                                      icon: Icons.alternate_email_rounded,
                                    ),

                                    const SizedBox(height: 20),

                                    // ── Password field ────────────
                                    _FieldLabel(label: 'CONTRASEÑA'),
                                    const SizedBox(height: 8),
                                    _StyledTextField(
                                      controller: vm.passwordController,
                                      hint: '••••••••',
                                      obscureText: true,
                                      icon: Icons.lock_outline_rounded,
                                    ),

                                    // ── Error message ─────────────
                                    if (vm.errorMessage != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF453A)
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFFF453A)
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.error_outline_rounded,
                                              color: Color(0xFFFF453A),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                vm.errorMessage!,
                                                style: const TextStyle(
                                                  color: Color(0xFFFF453A),
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    const SizedBox(height: 28),

                                    // ── Primary CTA ───────────────
                                    _PrimaryButton(
                                      isLoading: vm.isLoading,
                                      onPressed: () async {
                                        await vm.login();
                                        if (!context.mounted ||
                                            !vm.isAuthenticated) return;
                                        Navigator.pushReplacementNamed(
                                            context, '/home');
                                      },
                                    ),

                                    const SizedBox(height: 16),

                                    // ── Divider ───────────────────
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: Colors.white10,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Text(
                                            'o',
                                            style: TextStyle(
                                              color: Colors.white24,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: Colors.white10,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    // ── Register link ─────────────
                                    TextButton(
                                      onPressed: vm.isLoading
                                          ? null
                                          : () => Navigator.pushNamed(
                                              context, '/register'),
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          side: const BorderSide(
                                            color: Colors.white12,
                                          ),
                                        ),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(fontSize: 13.5),
                                          children: [
                                            TextSpan(
                                              text: '¿Sin cuenta?  ',
                                              style: TextStyle(
                                                  color: Colors.white38),
                                            ),
                                            TextSpan(
                                              text: 'Regístrate gratis',
                                              style: TextStyle(
                                                color: colorScheme.secondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // ── Backend note ──────────────
                                    Center(
                                      child: Text(
                                        ApiConfig.baseUrl,
                                        style: const TextStyle(
                                          color: Colors.white12,
                                          fontSize: 10,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData icon;

  const _StyledTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          letterSpacing: 0.3,
        ),
        cursorColor: colorScheme.secondary,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.white30, size: 18),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: isLoading
              ? const LinearGradient(
                  colors: [Color(0xFF2A2A2A), Color(0xFF2A2A2A)],
                )
              : LinearGradient(
                  colors: [colorScheme.secondary, colorScheme.tertiary],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: colorScheme.secondary.withOpacity(0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colorScheme.secondary),
                  ),
                )
              : const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}