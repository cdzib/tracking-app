import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle.dart';
import 'package:vagonetas_app/widgets/live_badge.dart';
import '../viewmodel/mapa_tracking_viewmodel.dart';
import '../../../../core/di/injector.dart';

// ── Google Maps dark style JSON ───────────────────────────────────────────────
const String _darkMapStyle = '''
[
  {"elementType":"geometry","stylers":[{"color":"#0d0d0d"}]},
  {"elementType":"labels.text.fill","stylers":[{"color":"#746855"}]},
  {"elementType":"labels.text.stroke","stylers":[{"color":"#242f3e"}]},
  {"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#111a10"}]},
  {"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#2e6a3e"}]},
  {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1a1a2e"}]},
  {"featureType":"road","elementType":"geometry.stroke","stylers":[{"color":"#212a37"}]},
  {"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#9ca5b3"}]},
  {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#1f2d3d"}]},
  {"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#1f2835"}]},
  {"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#f3d19c"}]},
  {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#2f3948"}]},
  {"featureType":"transit.station","elementType":"labels.text.fill","stylers":[{"color":"#d59563"}]},
  {"featureType":"water","elementType":"geometry","stylers":[{"color":"#0a1628"}]},
  {"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#515c6d"}]},
  {"featureType":"water","elementType":"labels.text.stroke","stylers":[{"color":"#17263c"}]}
]
''';

class MapaTrackingPage extends StatefulWidget {
  const MapaTrackingPage({super.key});

  @override
  State<MapaTrackingPage> createState() => _MapaTrackingPageState();
}

class _MapaTrackingPageState extends State<MapaTrackingPage>
    with TickerProviderStateMixin {
  late final MapaTrackingViewModel vm;
  GoogleMapController? _mapController;

  // Pulse animation for the live indicator
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  // Panel slide animation
  late AnimationController _panelController;
  late Animation<Offset> _panelSlide;

  bool _panelExpanded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    vm = Provider.of<MapaTrackingViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.conectarTracking();
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _panelSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _panelController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    vm.desconectarTracking();
    vm.dispose();
    _pulseController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() => _panelExpanded = !_panelExpanded);
    if (_panelExpanded) {
      _panelController.forward();
    } else {
      _panelController.reverse();
    }
  }

  Future<void> _centerOnMyLocation() async {
    if (_mapController == null) return;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          _showSnack('Permiso de ubicación denegado.');
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 14),
      );
    } catch (e) {
      if (mounted) _showSnack('Error obteniendo ubicación: $e');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapaTrackingViewModel>(
        builder: (context, vm, _) {
          final vehicles = vm.viajes
              .where((v) =>
                  v.location != null &&
                  v.location!.longitude != null &&
                  v.location!.latitude != null)
              .toList();
          if (_mapController != null && vehicles.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(vehicles.first.location!.latitude!,
                      vehicles.first.location!.longitude!),
                ),
              );
            });
          }
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: _buildAppBar(vehicles.length),
            body: Stack(
              children: [
                // ── Map ──────────────────────────────────────────────
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(21.1619, -86.8515),
                    zoom: 12,
                  ),
                  markers: vehicles
                      .map((v) => _buildMarker(
                          context,
                          Vehicle(
                            id: v.vehicle.id,
                            plate: v.vehicle.plate,
                            status: v.vehicle.status,
                            location: v.location,
                            device: v.device,
                          )))
                      .toSet(),
                  onMapCreated: (controller) async {
                    _mapController = controller;
                    await controller.setMapStyle(_darkMapStyle);
                    if (vehicles.isNotEmpty) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            LatLng(vehicles.first.location!.latitude!,
                                vehicles.first.location!.longitude!),
                            13,
                          ),
                        );
                      });
                    }
                  },
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  compassEnabled: false,
                ),

                // ── Loading overlay ──────────────────────────────────
                if (vm.isLoading)
                  Container(
                    color: colorScheme.background.withOpacity(0.54),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.amber),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Conectando tracking…',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.6),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Empty state ──────────────────────────────────────
                if (!vm.isLoading && vehicles.isEmpty)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.directions_bus_outlined,
                              color: colorScheme.primary.withOpacity(0.24), size: 40),
                          const SizedBox(height: 12),
                          Text(
                            'Sin vehículos activos',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No hay vehículos en ruta en este momento.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Bottom controls ──────────────────────────────────
                Positioned(
                  right: 16,
                  bottom: 120,
                  child: Column(
                    children: [
                      // My location
                      _MapButton(
                        icon: Icons.my_location_rounded,
                        onTap: _centerOnMyLocation,
                        tooltip: 'Mi ubicación',
                      ),
                      const SizedBox(height: 10),
                      // Zoom in
                      _MapButton(
                        icon: Icons.add_rounded,
                        onTap: () => _mapController?.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Zoom out
                      _MapButton(
                        icon: Icons.remove_rounded,
                        onTap: () => _mapController?.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Vehicle list panel ───────────────────────────────
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _VehiclePanel(
                    vehicles: vehicles.map((v) => Vehicle(id: v.vehicle.id, plate: v.vehicle.plate, status: v.vehicle.status, location: v.location)).toList(),
                    expanded: _panelExpanded,
                    onToggle: _togglePanel,
                    onVehicleTap: (v) {
                      print(v.toJson());
                      _mapController?.animateCamera(
                        CameraUpdate.newLatLngZoom(
                            LatLng(
                                v.location!.latitude!, v.location!.longitude!),
                            15),
                      );
                      Navigator.of(context).pushNamed(
                        '/vehicle/${v.id}',
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

  PreferredSizeWidget _buildAppBar(int count) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.background.withOpacity(0.85),
              Colors.transparent,
            ],
          ),
        ),
      ),
      // leading: Padding(
      //   padding: const EdgeInsets.only(left: 16),
      //   child: Center(
      //     child: GestureDetector(
      //       onTap: () => Navigator.pop(context),
      //       child: Container(
      //         width: 36,
      //         height: 36,
      //         decoration: BoxDecoration(
      //           color: Colors.white.withOpacity(0.08),
      //           borderRadius: BorderRadius.circular(10),
      //           border: Border.all(color: Colors.white12),
      //         ),
      //         child: const Icon(
      //           Icons.arrow_back_ios_new_rounded,
      //           color: Colors.white70,
      //           size: 14,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LiveBadge(
            isConnected: vm.isConnected,
            pulseAnim: _pulseAnim,
            onTap: () {
              if (!vm.isConnected) {
                _showSnack('Intentando reconectar…');
                vm.conectarTracking();
              }
            },
          ),
        ],
      ),
      actions: [
        // Vehicle count badge
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD4A853).withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFD4A853).withOpacity(0.4),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.directions_bus_rounded,
                color: Color(0xFFD4A853),
                size: 14,
              ),
              const SizedBox(width: 5),
              Text(
                '$count activos',
                style: const TextStyle(
                  color: Color(0xFFD4A853),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Marker _buildMarker(BuildContext context, Vehicle v) {
    final id = v.id;
    return Marker(
      markerId: MarkerId(id.toString()),
      position: LatLng(v.location!.latitude!, v.location!.longitude!),
      infoWindow: InfoWindow(
        title: 'Vehículo $id',
        snippet: 'Asientos: ${'N/A'}',
        onTap: () => Navigator.of(context).pushNamed('/vehicle/$id'),
      ),
    );
  }
}

// ── Map control button ────────────────────────────────────────────────────────

class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _MapButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: colorScheme.onSurface, size: 18),
        ),
      ),
    );
  }
}

// ── Vehicle list bottom panel ─────────────────────────────────────────────────

class _VehiclePanel extends StatelessWidget {
  final List<Vehicle> vehicles;
  final bool expanded;
  final VoidCallback onToggle;
  final Function(Vehicle) onVehicleTap;

  const _VehiclePanel({
    required this.vehicles,
    required this.expanded,
    required this.onToggle,
    required this.onVehicleTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      height: expanded ? 320 : 76,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 30,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Handle / header ──────────────────────────────────────
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Column(
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 3,
                      decoration: BoxDecoration(
                        color: colorScheme.onBackground.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                       Text(
                      'Vehículos en ruta',
                        style: TextStyle(
                          color: colorScheme.onBackground.withOpacity(0.87),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const Spacer(),
                      if (vehicles.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4A853).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${vehicles.length}',
                            style: const TextStyle(
                              color: Color(0xFFD4A853),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        color: colorScheme.onBackground.withOpacity(0.38),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Vehicle list ─────────────────────────────────────────
          if (expanded)
            Expanded(
              child: vehicles.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay vehículos activos.',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: vehicles.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final v = vehicles[i];
                        final id = v.id;
                        final plata = v.plate;
                        final seats = 0;

                        return GestureDetector(
                          onTap: () => onVehicleTap(v),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: colorScheme.outline),
                            ),
                            child: Row(
                              children: [
                                // Vehicle icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD4A853)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.directions_bus_rounded,
                                    color: Color(0xFFD4A853),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$plata',
                                        style: TextStyle(
                                          color: colorScheme.onBackground,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        seats != null
                                            ? '$seats asientos disponibles'
                                            : 'Asientos: N/A',
                                        style: TextStyle(
                                          color: colorScheme.onBackground.withOpacity(0.38),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Live badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CD964)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'EN RUTA',
                                    style: TextStyle(
                                      color: Color(0xFF4CD964),
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white24,
                                  size: 18,
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
  }
}
