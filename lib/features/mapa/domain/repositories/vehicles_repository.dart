import '../models/vehicle_tracking_response.dart';
import '../models/vehicle_detail_response.dart';

abstract class VehiclesRepository {
  Future<VehicleTrackingResponse> fetchTracking();
  Future<VehicleDetailResponse> fetchVehicleDetail(int vehicleId);
}
