import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/core/utils/utils.dart';
import 'package:vagonetas_app/features/booking/domain/models/trip_summary.dart';
import 'package:vagonetas_app/features/booking/presentation/pages/booking_seats_page.dart';
import 'package:vagonetas_app/features/settings/presentation/pages/settings_page.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';
import 'package:vagonetas_app/widgets/paginate.dart';
import '../viewmodel/booking_viewmodel.dart';

class BookingTripsPage extends StatelessWidget {
  const BookingTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingViewModel>(
      builder: (context, vm, _) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              Positioned.fill(child: CustomPaint(painter: AmbientPainter(colorScheme))),
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
              // El contenido principal ahora usa LayoutBuilder para altura acotada
              SafeArea(
                child: vm.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          return SizedBox(
                            height: constraints.maxHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 26, 24, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Top bar
                                      Row(
                                        children: [
                                          
                                          Expanded(
                                            child: TopBar(title: 'VIAJES', subtitle: 'Selecciona tu próximo recorrido', icon: Icons.route_outlined),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 22),
                                      Text(
                                        'RUTAS DISPONIBLES',
                                        style: TextStyle(
                                          color: colorScheme.onBackground.withOpacity(0.6),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.8,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Paginate<TripSummary>(
                                    fetchPage: (page, pageSize) =>
                                        vm.fetchTripsPage(page, pageSize),
                                    itemBuilder: (context, trip) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: _TripCard(
                                        trip: trip,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BookingSeatsPage(trip: trip),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    pageSize: 10,
                                    loadingWidget: const Center(
                                        child: CircularProgressIndicator()),
                                    emptyWidget: const Center(
                                        child:
                                            Text('No hay viajes disponibles')),
                                    padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 32,
                                        left: 16,
                                        right: 16),
                                    hasMore: vm.hasMoreTrips,
                                  ),
                                ),
                              ],
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

class _TripCard extends StatelessWidget {
  final TripSummary trip;
  final VoidCallback onTap;

  const _TripCard({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.route_outlined,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${trip.route?.name} · ${trip.vehicle?.plate}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (trip.datetime != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: colorScheme.onSurface.withOpacity(0.4),
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Salida: ${DateTimeUtils.formatRelative(trip.datetime)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.4),
                            fontSize: 12.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _SeatBadge(
                        label: '${trip.availableSeats?.length ?? 0} libres',
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      _SeatBadge(
                        label: '${trip.occupiedSeats?.length ?? 0} ocupados',
                        color: colorScheme.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withOpacity(0.3),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SeatBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
