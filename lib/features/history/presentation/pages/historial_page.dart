import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';

import '../../domain/models/historial_item.dart';
import '../viewmodel/historial_viewmodel.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HistorialViewModel>(
      builder: (context, vm, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: AmbientPainter()),
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
                child: Builder(
                  builder: (context) {
                    if (vm.isLoading) {
                      return const _LoadingState();
                    }

                    if (vm.error != null) {
                      return _ErrorState(
                        message: vm.error!,
                        onRetry: vm.loadHistorial,
                      );
                    }

                    return RefreshIndicator(
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.surface,
                      onRefresh: vm.loadHistorial,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HistoryTopBar(totalTrips: vm.historial.length),
                            const SizedBox(height: 28),
                            _HistoryHeroCard(items: vm.historial),
                            const SizedBox(height: 22),
                            const _SectionLabel(label: 'REGISTRO DE VIAJES'),
                            const SizedBox(height: 12),
                            if (vm.historial.isEmpty)
                              _EmptyState(onReload: vm.loadHistorial)
                            else
                              ...vm.historial.asMap().entries.map(
                                (entry) {
                                  final index = entry.key;
                                  final item = entry.value;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: index == vm.historial.length - 1
                                          ? 0
                                          : 14,
                                    ),
                                    child: _TripHistoryCard(item: item),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryTopBar extends StatelessWidget {
  final int totalTrips;

  const _HistoryTopBar({required this.totalTrips});

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
            Icons.route_outlined,
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
                'HISTORIAL',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 3.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$totalTrips viajes registrados',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryHeroCard extends StatelessWidget {
  final List<HistorialItem> items;

  const _HistoryHeroCard({required this.items});

  int get completedCount => items
      .where((item) => _tripStatus(item.descripcion).label == 'Completado')
      .length;

  int get canceledCount => items
      .where((item) => _tripStatus(item.descripcion).label == 'Cancelado')
      .length;

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
            color: Colors.black.withOpacity(0.24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tus movimientos recientes',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Consulta reservas completadas y canceladas con una vista mas clara y profesional.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricBlock(
                    label: 'Total',
                    value: items.length.toString(),
                  ),
                ),
                const SizedBox(
                  height: 34,
                  child: VerticalDivider(color: Colors.white10),
                ),
                Expanded(
                  child: _MetricBlock(
                    label: 'Completados',
                    value: completedCount.toString(),
                    valueColor: const Color(0xFFD4A853),
                  ),
                ),
                const SizedBox(
                  height: 34,
                  child: VerticalDivider(color: Colors.white10),
                ),
                Expanded(
                  child: _MetricBlock(
                    label: 'Cancelados',
                    value: canceledCount.toString(),
                    valueColor: const Color(0xFF7EA1FF),
                  ),
                ),
              ],
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
  final Color? valueColor;

  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _TripHistoryCard extends StatelessWidget {
  final HistorialItem item;

  const _TripHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = _tripStatus(item.descripcion);
    final route = _extractRoute(item.descripcion);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: status.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    status.icon,
                    color: status.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        route,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.descripcion,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12.5,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _StatusPill(status: status),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1D1D1D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoColumn(
                      label: 'Fecha',
                      value: DateFormat('dd MMM yyyy').format(item.fecha),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(color: Colors.white10),
                  ),
                  Expanded(
                    child: _InfoColumn(
                      label: 'Hora',
                      value: DateFormat('HH:mm').format(item.fecha),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(color: Colors.white10),
                  ),
                  Expanded(
                    child: _InfoColumn(
                      label: 'Folio',
                      value: '#${item.id}',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white30,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  final _TripStatus status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: status.color.withOpacity(0.22)),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

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

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A853)),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando historial de viajes...',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF453A).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xFFFF453A),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'No pudimos cargar tu historial',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.white12),
                  ),
                ),
                child: const Text(
                  'Reintentar',
                  style: TextStyle(
                    color: Color(0xFFD4A853),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onReload;

  const _EmptyState({required this.onReload});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFD4A853).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.history_toggle_off_rounded,
              color: Color(0xFFD4A853),
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aun no hay viajes registrados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Cuando completes o canceles una reserva, aparecera aqui con su detalle.',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 13,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: onReload,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: Colors.white12),
              ),
            ),
            child: const Text(
              'Actualizar',
              style: TextStyle(
                color: Color(0xFFD4A853),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TripStatus {
  final String label;
  final Color color;
  final IconData icon;

  const _TripStatus({
    required this.label,
    required this.color,
    required this.icon,
  });
}

_TripStatus _tripStatus(String descripcion) {
  final text = descripcion.toLowerCase();

  if (text.contains('cancel')) {
    return const _TripStatus(
      label: 'Cancelado',
      color: Color(0xFF7EA1FF),
      icon: Icons.close_rounded,
    );
  }

  return const _TripStatus(
    label: 'Completado',
    color: Color(0xFFD4A853),
    icon: Icons.check_rounded,
  );
}

String _extractRoute(String descripcion) {
  final match = RegExp(r'de\s+(.+?)\s+a\s+(.+)$', caseSensitive: false)
      .firstMatch(descripcion);

  if (match == null) return 'Viaje registrado';

  final from = match.group(1)?.trim();
  final to = match.group(2)?.trim();

  if (from == null || to == null || from.isEmpty || to.isEmpty) {
    return 'Viaje registrado';
  }

  return '$from -> $to';
}