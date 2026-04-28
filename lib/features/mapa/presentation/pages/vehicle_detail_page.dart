import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/widgets/circule_action_button.dart';
import 'package:vagonetas_app/widgets/live_badge.dart';

import '../../../../core/di/injector.dart';
import '../viewmodel/mapa_viewmodel.dart';

const String _detailDarkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0d0d0d"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#111a10"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1a1a2e"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#1f2d3d"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0a1628"}]}
]
''';

class VehicleDetailPage extends StatefulWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> with SingleTickerProviderStateMixin {
  late final MapaViewModel vm;
  GoogleMapController? _mapController;
  double? _lastLat;
  double? _lastLng;
  // Pulse animation for the live indicator
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    vm = sl<MapaViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.conectarWebSocket(widget.vehicleId);
    });
     _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    vm.desconectarWebSocket();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<MapaViewModel>(
        builder: (context, vm, _) {
          final hasLocation = vm.latitud != null && vm.longitud != null;
          final vehicle = vm.vehicleDetail;

          // Mueve la cámara automáticamente solo si la posición cambió
          if (_mapController != null && hasLocation) {
            if (_lastLat != vm.latitud || _lastLng != vm.longitud) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLng(LatLng(vm.latitud!, vm.longitud!)),
                );
                _lastLat = vm.latitud;
                _lastLng = vm.longitud;
              });
            }
          }

          return Scaffold(
            backgroundColor: colorScheme.background,
            body: Stack(
              children: [
                // Mapa siempre en el árbol, visible solo cuando hay ubicación
                if (hasLocation)
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(vm.latitud!, vm.longitud!),
                      zoom: 15.5,
                    ),
                    onMapCreated: (controller) async {
                      _mapController = controller;
                      await controller.setMapStyle(_detailDarkMapStyle);
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLng(
                          LatLng(vm.latitud!, vm.longitud!),
                        ),
                      );
                    },
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    compassEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId(widget.vehicleId),
                        position: LatLng(vm.latitud!, vm.longitud!),
                        infoWindow: InfoWindow(
                          title:
                              'Vehiculo ${vehicle?.vehicle.id ?? widget.vehicleId}',
                          snippet: 'Tracking activo',
                        ),
                      ),
                    },
                  )
                else
                  Container(color: colorScheme.background),

                // Gradiente visual, pero no intercepta gestos
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          colorScheme.surface.withOpacity(0.78),
                          Colors.transparent,
                          colorScheme.surface.withOpacity(0.18),
                          colorScheme.surface.withOpacity(0.72),
                        ],
                      ),
                    ),
                  ),
                ),

                // UI overlays (no bloquean el mapa)
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            CircleActionButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => Navigator.pop(context),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TRACKING',
                                    style: TextStyle(
                                      color: Color(0xFFD4A853),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Detalle del vehiculo en ruta',
                                    style: TextStyle(
                                      color: colorScheme.onBackground
                                          .withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            LiveBadge(
                                isConnected: vm.isConnected,
                                pulseAnim: _pulseAnim,
                                onTap: () {
                                  if (!vm.isConnected) {
                                    vm.conectarWebSocket(widget.vehicleId);
                                  }
                                }),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (vm.errorMessage != null && !hasLocation)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _StateCard(
                            icon: Icons.error_outline_rounded,
                            title: 'No pudimos cargar el tracking',
                            subtitle: vm.errorMessage!,
                          ),
                        )
                      else if (vm.isLoading && !hasLocation)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: _LoadingCard(),
                        )
                      else if (hasLocation)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                          child: _VehicleInfoCard(
                            vehicleId: widget.vehicleId,
                            internalId: vehicle?.vehicle.id,
                            tripId: 0,
                            seatsCount: 0,
                            lat: vm.latitud!,
                            lng: vm.longitud!,
                          ),
                        ),
                    ],
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


class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.3,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4A853)),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Cargando tracking del vehiculo...',
            style: TextStyle(
              color: colorScheme.onBackground.withOpacity(0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _StateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
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
          Icon(icon, color: const Color(0xFFD4A853), size: 30),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: colorScheme.onBackground.withOpacity(0.54),
              fontSize: 13,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _VehicleInfoCard extends StatelessWidget {
  final String vehicleId;
  final int? internalId;
  final int? tripId;
  final int? seatsCount;
  final double lat;
  final double lng;

  const _VehicleInfoCard({
    required this.vehicleId,
    required this.internalId,
    required this.tripId,
    required this.seatsCount,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4A853).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Color(0xFFD4A853),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehiculo ${internalId ?? vehicleId}',
                      style: TextStyle(
                        color: colorScheme.onBackground,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tripId != null
                          ? 'Viaje asociado #$tripId'
                          : 'Tracking activo',
                      style: TextStyle(
                        color: colorScheme.onBackground.withOpacity(0.7),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _InfoMetric(
                  label: 'Asientos',
                  value: seatsCount?.toString() ?? 'N/A',
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: _InfoMetric(
                  label: 'Estado',
                  value: 'En ruta',
                ),
              ),
            ],
          ),
          // const SizedBox(height: 14),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _InfoMetric(
          //         label: 'Latitud',
          //         value: lat.toStringAsFixed(5),
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: _InfoMetric(
          //         label: 'Longitud',
          //         value: lng.toStringAsFixed(5),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class _InfoMetric extends StatelessWidget {
  final String label;
  final String value;

  const _InfoMetric({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: colorScheme.onBackground.withOpacity(0.3),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: colorScheme.onBackground,
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
