import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/core/theme/theme_provider.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: AmbientPainter(colorScheme)),
          ),
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
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopBar(title: 'AJUSTES', subtitle: 'Ajustes y accesos de tu cuenta', icon: Icons.tune_rounded),
                  const SizedBox(height: 28),
                  const _SettingsHeroCard(),
                  const SizedBox(height: 22),
                  const _SectionLabel(label: 'PREFERENCIAS PRINCIPALES'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.person_outline_rounded,
                        title: 'Perfil',
                        subtitle:
                            'Consulta y administra tu informacion personal.',
                        accent: colorScheme.secondary,
                        onTap: () => Navigator.pushNamed(context, '/perfil'),
                      ),
                      const _CardDivider(),
                      _SettingsTile(
                        icon: Icons.route_outlined,
                        title: 'Mis viajes',
                        subtitle:
                            'Consulta y administra tus reservas y recorridos.',
                        accent: const Color(0xFF7EA1FF),
                        onTap: () => Navigator.pushNamed(context, '/historial'),
                      ),
                      const _CardDivider(),
                      _SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: 'Notificaciones',
                        subtitle:
                            'Configura avisos y recordatorios del servicio.',
                        accent: const Color(0xFF8ED1A5),
                        onTap: () => _showComingSoon(
                          context,
                          'Notificaciones estara disponible en una siguiente version.',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'APARIENCIA'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _ThemeModeTile(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'MAS OPCIONES'),
                  const SizedBox(height: 12),
                  _SettingsCard(
                    children: [
                      _SettingsTile(
                        icon: Icons.security_rounded,
                        title: 'Privacidad y seguridad',
                        subtitle:
                            'Controles de acceso y proteccion de tu cuenta.',
                        accent: const Color(0xFFEAA86C),
                        trailingLabel: 'Proximamente',
                        onTap: () => _showComingSoon(
                          context,
                          'Privacidad y seguridad se definira mas adelante.',
                        ),
                      ),
                      const _CardDivider(),
                      _SettingsTile(
                        icon: Icons.support_agent_rounded,
                        title: 'Ayuda y soporte',
                        subtitle:
                            'Canales de atencion y seguimiento de incidencias.',
                        accent: const Color(0xFFB090FF),
                        trailingLabel: 'Proximamente',
                        onTap: () => _showComingSoon(
                          context,
                          'Ayuda y soporte se agregara en futuras iteraciones.',
                        ),
                      ),
                      const _CardDivider(),
                      _SettingsTile(
                        icon: Icons.tune_rounded,
                        title: 'Mas opciones a definir',
                        subtitle:
                            'Espacio reservado para nuevas configuraciones.',
                        accent: const Color(0xFF5FC9C2),
                        trailingLabel: 'Editable',
                        onTap: () => _showComingSoon(
                          context,
                          'Este bloque queda listo para que agreguemos nuevas opciones.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1C1C1C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final String title;
  final String subtitle ;
  final IconData icon;
  TopBar({required this.title, required this.subtitle, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.4),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 3.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsHeroCard extends StatelessWidget {
  const _SettingsHeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.18),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Controla tu experiencia',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Centraliza accesos rapidos para tu perfil, tus viajes y nuevas configuraciones dentro de una sola vista.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 20),
          _HeroStatusRow(),
        ],
      ),
    );
  }
}

class _HeroStatusRow extends StatelessWidget {
  const _HeroStatusRow();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          const Expanded(
            child: _MetricBlock(
              label: 'Accesos',
              value: '3 activos',
            ),
          ),
          SizedBox(
            height: 34,
            child: VerticalDivider(color: Theme.of(context).dividerColor),
          ),
          const Expanded(
            child: _MetricBlock(
              label: 'Estado',
              value: 'Listo',
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final String label;
  final String value;

  const _MetricBlock({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.onSurface.withOpacity(0.4),
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final String? trailingLabel;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
    this.trailingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (trailingLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            trailingLabel!,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.chevron_right_rounded,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Theme.of(context).dividerColor, height: 1),
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        Icon(Icons.brightness_6_rounded, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Tema',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            )
          ),
        ),
        DropdownButton<ThemeMode>(
          value: themeProvider.themeMode,
          dropdownColor: const Color(0xFF161616),
          style: const TextStyle(color: Colors.white),
          underline: Container(),
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('Sistema'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Claro'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Oscuro'),
            ),
          ],
          onChanged: (mode) {
            if (mode != null) themeProvider.setThemeMode(mode);
          },
        ),
      ],
    );
  }
}
