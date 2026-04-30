// ─── Booking Seats Page ───────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/features/booking/domain/models/trip_summary.dart';
import 'package:vagonetas_app/features/booking/presentation/viewmodel/booking_seats_viewmodel.dart';
import 'package:vagonetas_app/widgets/ambient_painter.dart';
import 'package:vagonetas_app/widgets/custom_back_button.dart';
import 'package:vagonetas_app/widgets/legend_item.dart';
import 'package:vagonetas_app/widgets/seat_selector.dart';

class BookingSeatsPage extends StatefulWidget {
  final TripSummary trip;
  const BookingSeatsPage({super.key, required this.trip});

  @override
  State<BookingSeatsPage> createState() => _BookingSeatsPageState();
}

class _BookingSeatsPageState extends State<BookingSeatsPage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final vm = Provider.of<BookingSeatsViewModel>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        vm.selectTrip(widget.trip);
      });
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingSeatsViewModel>(
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
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar
                          Row(
                            children: [
                              CustomBackButton(onTap: () => Navigator.pop(context)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ASIENTOS',
                                      style: TextStyle(
                                        color: colorScheme.secondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 3.2,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.trip.route?.name ??
                                          'Selecciona tu lugar',
                                      style: TextStyle(
                                        color: colorScheme.onBackground
                                            .withOpacity(0.6),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          // Leyenda
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.background,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: colorScheme.outline),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                LegendItem(
                                    color: colorScheme.onBackground
                                        .withOpacity(0.3),
                                    label: 'Disponible'),
                                LegendItem(
                                    color: colorScheme.primary,
                                    label: 'Seleccionado'),
                                LegendItem(
                                    color: colorScheme.onBackground
                                        .withOpacity(0.7),
                                    label: 'Ocupado'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'MAPA DE ASIENTOS',
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
                      child: vm.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: colorScheme.secondary,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: SeatSelector(
                                totalSeats: vm.selectedTrip.capacity ?? 20,
                                occupiedSeats: vm.occupiedSeats,
                                selectedSeats: vm.selectedSeats,
                                onSeatSelected: vm.toggleSeat,
                              ),
                            ),
                    ),
                    // Error
                    if (vm.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        child: Text(
                          vm.errorMessage!,
                          style: const TextStyle(
                              color: Color(0xFFEAA86C), fontSize: 13),
                        ),
                      ),
                    // Botón reservar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                      child: GestureDetector(
                        onTap: vm.isLoading ? null : vm.createBooking,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorScheme.secondary, colorScheme.tertiary],
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.secondary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: vm.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Confirmar reserva',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
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
