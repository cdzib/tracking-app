import 'package:vagonetas_app/features/mapa/data/tracking_service.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';
import 'package:vagonetas_app/features/mapa/domain/usecases/fetch_vehicles_tracking_use_case.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

class MapaTrackingViewModel extends ChangeNotifier {
  final List<VehicleDetailResponse> viajes = [];
  final FetchVehiclesTrackingUseCase fetchTrackingUseCase;

  ReverbSocketService _channel = ReverbSocketService();
  StreamSubscription? _wsSubscription;
  bool isLoading = false;
  String? errorMessage;

  VehicleDetailResponse? vehicleDetail;

  MapaTrackingViewModel(this.fetchTrackingUseCase);

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> fetchInitialData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      print('Fetching initial tracking data...');
      final data = await fetchTrackingUseCase();
      print('Initial tracking data fetched: $data');
      final vehicles = data.data;
      viajes
        ..clear()
        ..addAll(vehicles!);
    } catch (e) {
      errorMessage = 'Error de red: $e';
      print(errorMessage);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> conectarTracking() async {
    await fetchInitialData();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    try {
      _channel.connect();
      _channel.subscribe("vehicles.tracking");
      _wsSubscription = _channel.stream.listen(
        (data) {
          final msg = data;
          if (msg['event'] == 'vehicle.tracking.updated' &&
              msg['data'] != null) {
            print(jsonDecode(msg['data']));
            VehicleDetailResponse updatedVehicle =
                VehicleDetailResponse.fromJson(jsonDecode(msg['data']));
            _actualizarViaje(updatedVehicle);

            notifyListeners();
          }
        },
        onError: (error) {
          errorMessage = 'Tracking en tiempo real no disponible.';
          notifyListeners();
        },
      );
      _channel.statusStream.listen((status) {
        if (status == SocketStatus.error || status == SocketStatus.disconnected) {
          errorMessage = 'Conexión WebSocket perdida. Intentando reconectar...';
          _isConnected = false;
          notifyListeners();
        }
        if (status == SocketStatus.connected) {
          errorMessage = null;
          _isConnected = true;
          notifyListeners();
        }
      });
    } catch (_) {
      errorMessage = 'Tracking en tiempo real no disponible.';
      notifyListeners();
    }
  }

  void _actualizarViaje(VehicleDetailResponse updatedVehicle) {
    final data = updatedVehicle;
    print('Actualizando viaje con datos: $data');

    final idx =
        viajes.indexWhere((v) => v.vehicle.id == updatedVehicle.vehicle.id);

    if (idx >= 0) {
      print(
          'Actualizando viaje existente con ID: ${updatedVehicle.vehicle.id}');
      viajes[idx] = updatedVehicle;
    } else {
      print('Agregando nuevo viaje con ID: ${updatedVehicle.vehicle.id}');
      viajes.add(updatedVehicle);
    }
  }

  void desconectarTracking() {
    _wsSubscription?.cancel();
    _channel.close();
  }

  @override
  void dispose() {
    desconectarTracking();
    super.dispose();
  }
}
