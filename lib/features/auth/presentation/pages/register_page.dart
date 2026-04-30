import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';

import '../../../../core/di/injector.dart';
import '../viewmodel/auth_viewmodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

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
    return ChangeNotifierProvider(
      create: (_) => sl<AuthViewModel>(),
      child: Consumer<AuthViewModel>(
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
                                // Back button + brand
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                    // Back button
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.06),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white54,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 36),

                                // Step indicator
                                Row(
                                  children: [
                                    _StepDot(active: true),
                                    _StepLine(),
                                    _StepDot(active: true),
                                    _StepLine(),
                                    _StepDot(active: false),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // Headline
                                const Text(
                                  'Crea tu cuenta.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                    letterSpacing: -1.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Empieza a reservar en segundos.',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 13,
                                    letterSpacing: 0.2,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // ── Form card ─────────────────────────────
                          DraggableScrollableSheet(
                              initialChildSize: 0.70,
                              minChildSize: 0.70,
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
                                    padding: const EdgeInsets.fromLTRB(
                                        28, 28, 28, 32),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // Drag handle
                                        Center(
                                          child: Container(
                                            width: 36,
                                            height: 3,
                                            margin: const EdgeInsets.only(
                                                bottom: 24),
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),

                                        // ── Name field ────────────────
                                        _FieldLabel(label: 'NOMBRE COMPLETO'),
                                        const SizedBox(height: 8),
                                        _StyledTextField(
                                          controller: vm.nameController,
                                          hint: 'María García',
                                          icon: Icons.person_outline_rounded,
                                        ),

                                        const SizedBox(height: 18),

                                        // ── Email field ───────────────
                                        _FieldLabel(
                                            label: 'CORREO ELECTRÓNICO'),
                                        const SizedBox(height: 8),
                                        _StyledTextField(
                                          controller: vm.emailController,
                                          hint: 'tu@correo.com',
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          icon: Icons.alternate_email_rounded,
                                        ),

                                        const SizedBox(height: 18),

                                        // ── Phone field ───────────────
                                        _FieldLabel(label: 'TELÉFONO'),
                                        const SizedBox(height: 8),
                                        _StyledTextField(
                                          controller: vm.phoneController,
                                          hint: '+34 600 000 000',
                                          keyboardType: TextInputType.phone,
                                          icon: Icons.phone_outlined,
                                        ),

                                        const SizedBox(height: 18),

                                        // ── Divider ───────────────────
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: Colors.white10),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12),
                                              child: Text(
                                                'seguridad',
                                                style: TextStyle(
                                                  color: Colors.white24,
                                                  fontSize: 10,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                  height: 1,
                                                  color: Colors.white10),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 18),

                                        // ── Password field ────────────
                                        _FieldLabel(label: 'CONTRASEÑA'),
                                        const SizedBox(height: 8),
                                        _StyledTextField(
                                          controller: vm.passwordController,
                                          hint: '••••••••',
                                          obscureText: true,
                                          icon: Icons.lock_outline_rounded,
                                        ),

                                        const SizedBox(height: 18),

                                        // ── Confirm password ──────────
                                        _FieldLabel(
                                            label: 'CONFIRMAR CONTRASEÑA'),
                                        const SizedBox(height: 8),
                                        _StyledTextField(
                                          controller:
                                              vm.passwordConfirmationController,
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
                                          label: 'Crear cuenta',
                                          onPressed: () async {
                                            await vm.register();
                                            if (!context.mounted ||
                                                !vm.isAuthenticated) return;
                                            Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              '/reservas',
                                              (_) => false,
                                            );
                                          },
                                        ),

                                        const SizedBox(height: 16),

                                        // ── Login link ────────────────
                                        TextButton(
                                          onPressed: vm.isLoading
                                              ? null
                                              : () => Navigator.pop(context),
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
                                                  text: '¿Ya tienes cuenta?  ',
                                                  style: TextStyle(
                                                      color: Colors.white38),
                                                ),
                                                TextSpan(
                                                  text: 'Inicia sesión',
                                                  style: TextStyle(
                                                    color:
                                                        colorScheme.secondary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Supporting widgets ────────────────────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final bool active;
  const _StepDot({required this.active});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: active ? 8 : 6,
      height: active ? 8 : 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? colorScheme.secondary : Colors.white12,
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Colors.white12,
    );
  }
}

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
          hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
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
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.isLoading,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
              : Text(
                  label,
                  style: const TextStyle(
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
