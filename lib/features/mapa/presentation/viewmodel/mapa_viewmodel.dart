import 'dart:convert';

import 'package:vagonetas_app/features/mapa/data/tracking_service.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';
import 'package:vagonetas_app/features/mapa/domain/usecases/fetch_vehicles_tracking_use_case.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vagonetas_app/core/config/api_config.dart';

class MapaViewModel extends ChangeNotifier {
  bool isConnected = false;
  VehicleDetailResponse? vehicleDetail;
  FetchVehicleDetailUseCase fetchVehicleDetailUseCase;
  double? latitud;
  double? longitud;
  String? errorMessage;
  bool isLoading = false;
  ReverbSocketService socketService = ReverbSocketService();
  MapaViewModel(this.fetchVehicleDetailUseCase);

  Future<void> fetchVehicleDetail(String vehicleId) async {
    // Limpiar estado previo
    vehicleDetail = null;
    latitud = null;
    longitud = null;
    errorMessage = null;
    isLoading = true;
    notifyListeners();
    try {
      vehicleDetail = await fetchVehicleDetailUseCase(int.parse(vehicleId));
      latitud = vehicleDetail?.device.latitude;
      longitud = vehicleDetail?.device.longitude;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'No se pudo cargar el detalle del vehículo';
      notifyListeners();
    }
  }

  Future<void> conectarWebSocket(String vehicleId) async {
    isLoading = true;
    // Limpiar estado previo
    vehicleDetail = null;
    latitud = null;
    longitud = null;
    errorMessage = null;
    notifyListeners();

    await fetchVehicleDetail(vehicleId);

    isLoading = false;
    notifyListeners();

    _connectRealtimeTracking(vehicleId);
  }

  Future<void> _connectRealtimeTracking(String vehicleId) async {
    final url = '${ApiConfig.wsBaseUrl}/app/xscamr41r2pxrs5zqtv0?protocol=7&client=flutter&version=1.0.0';
    print("Intentando conectar al WebSocket en: $url");
    try {
      bool connected = await socketService.connect();
      if(connected) {
        print("✅ Conexión WebSocket establecida");
        isConnected = true;
        notifyListeners();
        socketService.subscribe("vehicle.$vehicleId");
        socketService.stream.listen((data) {
          print("Datos recibidos del WebSocket: $data");
          if (data['event'] == 'vehicle.tracking.updated') {
            dynamic payload = data['data'];
            if (payload is String) {
              payload = jsonDecode(payload);
            }
            final updatedVehicle = VehicleDetailResponse.fromJson(payload);
            isLoading = false;
            _applyVehicle(updatedVehicle);
          }
        });
        socketService.statusStream.listen((status) {
          print("Estado del WebSocket: $status");
          if (status == SocketStatus.error || status == SocketStatus.disconnected) {
            errorMessage = 'Conexión WebSocket perdida. Intentando reconectar...';
            isConnected = false;
            notifyListeners();
          }
          if (status == SocketStatus.connected) {
            errorMessage = null;
            isConnected = true;
            notifyListeners();
          }
        });
        
      } else {
        throw Exception("No se pudo establecer la conexión WebSocket");
      }
    } catch (e) {
      errorMessage = 'No se pudo conectar al canal de seguimiento. $e';
      print(errorMessage);
      isLoading = false;
      notifyListeners();
    }
  }

  void _applyVehicle(VehicleDetailResponse nextVehicle) {
    vehicleDetail = nextVehicle;
    latitud = nextVehicle.device.latitude;
    longitud = nextVehicle.device.longitude;
    errorMessage = null;
    notifyListeners();
  }

  void desconectarWebSocket() {
    socketService.close();
    isConnected = false;
  }

  Future<void> obtenerUbicacionActual() async {
    final permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      errorMessage = 'No se concedio permiso de ubicacion.';
      notifyListeners();
      return;
    }
    final pos = await Geolocator.getCurrentPosition();
    latitud = pos.latitude;
    longitud = pos.longitude;
    notifyListeners();
  }
}
