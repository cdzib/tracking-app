import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vagonetas_app/core/di/injector.dart';
import 'package:vagonetas_app/core/utils/utils.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';
import 'package:vagonetas_app/widgets/error_page.dart';
import 'package:vagonetas_app/widgets/empty_page.dart';
import '../viewmodel/home_viewmodel.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => sl<HomeViewModel>()..loadHomeData(),
      child: const _HomeContentBody(),
    );
  }
}

class _HomeContentBody extends StatelessWidget {
  const _HomeContentBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final vm = Provider.of<HomeViewModel>(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
              child: CustomPaint(painter: AmbientPainter(colorScheme))),
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
            child: RefreshIndicator(
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
              onRefresh: vm.loadHomeData,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 26, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(),
                          const SizedBox(height: 22),
                          const _SectionLabel(label: 'PRÓXIMO VIAJE'),
                          const SizedBox(height: 12),
                          if (vm.isLoadingNextTrip)
                            const Center(child: CircularProgressIndicator()),
                          if (vm.errorNextTrip != null)
                            ErrorPage(
                              error: vm.errorNextTrip!,
                              onRetry: () => vm.loadHomeData(),
                            ),
                          if (!vm.isLoadingNextTrip &&
                              vm.errorNextTrip == null &&
                              vm.nextTrip != null)
                            _NextTripCard(trip: vm.nextTrip),
                          if (!vm.isLoadingNextTrip &&
                              vm.errorNextTrip == null &&
                              vm.nextTrip == null)
                            const EmptyPage(
                                message:
                                    'No hay información de tu próximo viaje.'),
                          const SizedBox(height: 22),
                          const _SectionLabel(label: 'ACCESOS RÁPIDOS'),
                          const SizedBox(height: 12),
                          const _QuickAccess(),
                          const SizedBox(height: 22),
                          const _SectionLabel(
                              label: 'VIAJES DISPONIBLES AHORA'),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 140,
                      child: Builder(
                        builder: (_) {
                          if (vm.isLoadingAvailableTrips) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (vm.errorAvailableTrips != null) {
                            return ErrorPage(
                              error: vm.errorAvailableTrips!,
                              onRetry: () => vm.loadHomeData(),
                            );
                          }
                          if (vm.availableTrips.isEmpty) {
                            return const EmptyPage(
                                message:
                                    'No hay viajes disponibles en este momento.');
                          }
                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: vm.availableTrips.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (_, i) =>
                                _AvailableTripCard(trip: vm.availableTrips[i]),
                          );
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _SectionLabel(label: 'ÚLTIMOS VIAJES'),
                          SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    sliver: Builder(
                      builder: (_) {
                        if (vm.isLoadingRecentTrips) {
                          return const SliverToBoxAdapter(
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        if (vm.errorRecentTrips != null) {
                          return SliverToBoxAdapter(
                            child: ErrorPage(
                              error: vm.errorRecentTrips!,
                              onRetry: () => vm.loadHomeData(),
                            ),
                          );
                        }
                        if (vm.recentTrips.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: EmptyPage(
                                message: 'No hay historial de viajes.'),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _RecentTripTile(recent: vm.recentTrips[i]),
                            ),
                            childCount: vm.recentTrips.length,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Buenos días'
        : hour < 18
            ? 'Buenas tardes'
            : 'Buenas noches';

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 1.4),
          ),
          child: Icon(Icons.person_rounded,
              color: Theme.of(context).colorScheme.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                      fontSize: 12.5,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'Juan Pérez',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
          ),
          child: Text(
            'Pasajero',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  letterSpacing: 0.5,
                ),
          ),
        ),
      ],
    );
  }
}

// ── Próximo viaje ───────────────────────────────────────────────────────────

class _NextTripCard extends StatelessWidget {
  final Map<String, dynamic>? trip;
  const _NextTripCard({this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    if (trip == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: colorScheme.primary.withOpacity(0.25)),
        ),
        child: Text('No tienes viajes próximos',
            style: theme.textTheme.bodyMedium),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                  border:
                      Border.all(color: colorScheme.secondary.withOpacity(0.3)),
                ),
                child: Text(
                  trip!['status'] ?? '● Confirmado',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                trip!['seat'] != null ? 'Asiento #${trip!['seat']}' : '',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            trip!['route'] ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.directions_bus_rounded,
                  color: colorScheme.onSurface.withOpacity(0.4), size: 14),
              const SizedBox(width: 6),
              Text(trip!['vehicle'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 13)),
              const SizedBox(width: 16),
              Icon(Icons.access_time_rounded,
                  color: colorScheme.onSurface.withOpacity(0.4), size: 14),
              const SizedBox(width: 6),
              Text(trip!['time'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.4),
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Ver en mapa',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
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

// ── Accesos rápidos ─────────────────────────────────────────────────────────

class _QuickAccess extends StatelessWidget {
  const _QuickAccess();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final items = [
      _QuickItem(
          icon: Icons.directions_bus_rounded,
          label: 'Reservar',
          color: colorScheme.secondary,
          route: '/reservar'),
      _QuickItem(
          icon: Icons.map_rounded,
          label: 'Ver mapa',
          color: const Color(0xFF7EA1FF),
          route: '/tracking'),
      _QuickItem(
          icon: Icons.receipt_long_rounded,
          label: 'Mis reservas',
          color: const Color(0xFF8ED1A5),
          route: '/mis_reservas'),
      _QuickItem(
          icon: Icons.person_outline_rounded,
          label: 'Mi perfil',
          color: const Color(0xFFEAA86C),
          route: '/perfil'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items
          .map((item) => Expanded(
                child: _QuickAccessTile(
                  item: item,
                  onTap: () {
                    Navigator.pushNamed(context, item.route);
                  },
                ),
              ))
          .toList(),
    );
  }
}

class _QuickItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _QuickItem(
      {required this.icon,
      required this.label,
      required this.color,
      required this.route});
}

class _QuickAccessTile extends StatelessWidget {
  final _QuickItem item;
  final VoidCallback? onTap;
  const _QuickAccessTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      constraints: const BoxConstraints(minHeight: 70, maxHeight: 90),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: item.color.withOpacity(0.25)),
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              item.label,
              style: TextStyle(
                  color: colorScheme.onBackground.withOpacity(0.54),
                  fontSize: 11),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Viajes disponibles ──────────────────────────────────────────────────────

class _AvailableTripCard extends StatelessWidget {
  final History trip;
  const _AvailableTripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.route_outlined,
                    color: colorScheme.secondary, size: 17),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    DateTimeUtils.formatDateRelative(
                        trip.trip?.datetime?.toString()),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateTimeUtils.formatTime(trip.trip?.datetime?.toString()),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            trip.trip?.route?.name ?? '',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${trip.seats?.length ?? 0} asientos libres',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Últimos viajes ──────────────────────────────────────────────────────────

class _RecentTripTile extends StatelessWidget {
  final Recents recent;
  const _RecentTripTile({required this.recent});

  @override
  Widget build(BuildContext context) {
    final isCompleted = recent.status == 'completado';
    final statusColor =
        isCompleted ? const Color(0xFF8ED1A5) : const Color(0xFFEAA86C);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check_circle_outline_rounded
                  : Icons.cancel_outlined,
              color: statusColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recent.trip?.route?.name ?? '',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateTimeUtils.formatRelative(
                      recent.trip?.datetime?.toString()),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: statusColor.withOpacity(0.3)),
            ),
            child: Text(
              recent.status ?? '',
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mock data ───────────────────────────────────────────────────────────────

const _mockTrips = [
  {'route': 'Centro → Aeropuerto', 'time': '07:30', 'seats': 8},
  {'route': 'Norte → Sur Terminal', 'time': '08:00', 'seats': 3},
  {'route': 'Plaza → Universidad', 'time': '08:45', 'seats': 12},
  {'route': 'Mercado → Hospital', 'time': '09:15', 'seats': 5},
];

const _mockRecent = [
  {
    'route': 'Centro → Aeropuerto',
    'date': 'Hoy, 06:30 AM',
    'status': 'completado'
  },
  {
    'route': 'Norte → Sur Terminal',
    'date': 'Ayer, 08:00 AM',
    'status': 'completado'
  },
  {
    'route': 'Plaza → Universidad',
    'date': '24 Abr, 07:45 AM',
    'status': 'cancelado'
  },
  {
    'route': 'Mercado → Hospital',
    'date': '22 Abr, 09:00 AM',
    'status': 'completado'
  },
];

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Text(
      label,
      style: TextStyle(
        color: colorScheme.onBackground.withOpacity(0.38),
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
      ),
    );
  }
}
