
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';

import 'vehicles_service.dart';
import '../domain/repositories/vehicles_repository.dart';
import '../domain/models/vehicle_tracking_response.dart';

class VehiclesRepositoryImpl implements VehiclesRepository {
  final VehiclesService service;
  

  VehiclesRepositoryImpl(this.service);

  @override
  Future<VehicleTrackingResponse> fetchTracking() async {
    final respone = await service.fetchTracking();
    print('Datos recibidos del servicio: $respone');
    return respone;
  }
  
  @override
  Future<VehicleDetailResponse> fetchVehicleDetail(int vehicleId) async {
    return await service.fetchVehicleDetail(vehicleId);
  }
}
