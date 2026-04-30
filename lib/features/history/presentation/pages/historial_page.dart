import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/core/utils/utils.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import 'package:vagonetas_app/features/settings/presentation/pages/settings_page.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';
import 'package:vagonetas_app/widgets/custom_back_button.dart';
import 'package:vagonetas_app/widgets/paginate.dart';
import '../viewmodel/historial_viewmodel.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  Key _paginateKey = UniqueKey();

  Future<void> _reload() async {
    setState(() => _paginateKey = UniqueKey());
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomBackButton(
                                onTap: () => Navigator.pop(context),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TopBar(
                                  title: 'Historial',
                                  subtitle:
                                      ' ${vm.total > 0 ? vm.total : vm.historial.length} viajes registrados',
                                  icon: Icons.history_rounded),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          // _HistoryHeroCard(
                          // //     items: vm.historial, context: context),
                          // const SizedBox(height: 22),
                          const _SectionLabel(label: 'REGISTRO DE VIAJES'),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Paginate<History>(
                        key: _paginateKey,
                        pageSize: 10,
                        fetchPage: vm.fetchHistorialPage,
                        hasMore: vm.hasMoreHistorial,
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                        loadingWidget: const _LoadingState(),
                        emptyWidget: _EmptyState(onReload: _reload),
                        errorBuilder: (error, retry) => _ErrorState(
                          message: vm.error ?? error.toString(),
                          onRetry: retry,
                        ),
                        itemBuilder: (context, item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _TripHistoryCard(item: item),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HistoryHeroCard extends StatelessWidget {
  final List<History> items;
  final BuildContext context;
  const _HistoryHeroCard({required this.items, required this.context});

  int get completedCount => items
      .where((item) =>
          _tripStatus(item.trip!.status!, context).label == 'Completado')
      .length;

  int get canceledCount => items
      .where((item) =>
          _tripStatus(item.trip!.status!, context).label == 'Cancelado')
      .length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
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
            style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          Text(
            'Consulta reservas completadas y canceladas con una vista mas clara y profesional.',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
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
                    valueColor: colorScheme.secondary,
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
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
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
  final History item;

  const _TripHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final status = _tripStatus(item.trip!.status!, context);
    final route = _extractRoute(item.trip!.route!.name ?? 'Viaje registrado');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF161616),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
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
                        item.trip!.status ?? '',
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
                      value: DateTimeUtils.formatShortDate(item.createdAt),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(color: Colors.white10),
                  ),
                  Expanded(
                    child: _InfoColumn(
                      label: 'Hora',
                      value: DateTimeUtils.formatTime(item.createdAt),
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(color: Colors.white10),
                  ),
                  Expanded(
                    child: _InfoColumn(
                      label: 'Folio',
                      value: '#${item.bookingId}',
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.secondary),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
                child: Text(
                  'Reintentar',
                  style: TextStyle(
                    color: colorScheme.secondary,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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
              color: colorScheme.secondary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_toggle_off_rounded,
              color: colorScheme.secondary,
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
            child: Text(
              'Actualizar',
              style: TextStyle(
                color: colorScheme.secondary,
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

_TripStatus _tripStatus(String descripcion, BuildContext context) {
  final text = descripcion.toLowerCase();
  final colorScheme = Theme.of(context).colorScheme;

  if (text.contains('cancel')) {
    return _TripStatus(
      label: 'Cancelado',
      color: Color(0xFF7EA1FF),
      icon: Icons.close_rounded,
    );
  }

  return _TripStatus(
    label: 'Completado',
    color: colorScheme.secondary,
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
