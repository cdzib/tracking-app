import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_tracking_response.dart';
import '../repositories/vehicles_repository.dart';

class FetchVehicleDetailUseCase {
  final VehiclesRepository repository;
  FetchVehicleDetailUseCase(this.repository);

  Future<VehicleDetailResponse> call(int vehicleId) async {
    return await repository.fetchVehicleDetail(vehicleId);
  }
}


class FetchVehiclesTrackingUseCase {
  final VehiclesRepository repository;
  FetchVehiclesTrackingUseCase(this.repository);

  Future<VehicleTrackingResponse> call() async {
    return await repository.fetchTracking();
  }
}
