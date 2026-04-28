import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_tracking_response.dart';

class VehiclesService {
  Future<VehicleDetailResponse> fetchVehicleDetail(int vehicleId) async {
    try {
      print('Iniciando fetch de detalle de vehículo...');
      final response = await _apiClient.get(
          '/api/tracking/vehicles/$vehicleId/current-location', requiresAuth: true);
      print('Respuesta cruda del backend (detalle):');
      print(response);
      var data = response['data'];
      return VehicleDetailResponse.fromJson(data);
    } catch (e) {
      print('Error al obtener detalle de vehículo: $e');
      throw Exception('Error para obtener el detalle del vehículo');
    }
  }

  final ApiClient _apiClient;
  VehiclesService(this._apiClient);

  Future<VehicleTrackingResponse> fetchTracking() async {
    try {
      print('Iniciando fetch de tracking...');
      final response = await _apiClient.get(
        '/api/tracking/vehicles/all-locations', requiresAuth: true);
      print('VehiclesService Respuesta cruda del backend:');
      print(response);

      return VehicleTrackingResponse.fromJson(response);
    } catch (e) {
      print('VehiclesService fetchTracking() Error al obtener el tracking: $e');
      throw Exception('Error para obtener el tracking de vehículos');
    }
  }
}
