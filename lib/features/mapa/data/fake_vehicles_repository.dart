import 'package:vagonetas_app/features/mapa/domain/models/device.dart';
import 'package:vagonetas_app/features/mapa/domain/models/location.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';

import '../domain/models/vehicle_tracking_response.dart';
import '../domain/repositories/vehicles_repository.dart';

class FakeVehiclesRepository implements VehiclesRepository {
  @override
  Future<VehicleTrackingResponse> fetchTracking() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return VehicleTrackingResponse(
      success: true,
      count: 4,
      data: [
        VehicleDetailResponse(
          vehicle: Vehicle(id: 1, plate: 'ABC123', status: 'active'),
          device: Device(id: 1, imei: 'Device 1'),
          location: Location(latitude: 19.4326, longitude: -99.1332),
        ),
        VehicleDetailResponse(
          vehicle: Vehicle(id: 2, plate: 'DEF456', status: 'inactive'),
          device: Device(id: 2, imei: 'Device 2'),
          location: Location(latitude: 19.4270, longitude: -99.1677),
        ),
        VehicleDetailResponse(
          vehicle: Vehicle(id: 3, plate: 'GHI789', status: 'active'),
          device: Device(id: 3, imei: 'Device 3'),
          location: Location(latitude: 19.4190, longitude: -99.1400),
        ),
        VehicleDetailResponse(
          vehicle: Vehicle(id: 4, plate: 'JKL012', status: 'inactive'),
          device: Device(id: 4, imei: 'Device 4'),
          location: Location(latitude: 19.4100, longitude: -99.1200),
        ),
      ],
    );    
  }

  @override
  Future<VehicleDetailResponse> fetchVehicleDetail(int vehicleId) {
    // TODO: implement fetchVehicleDetail
    throw UnimplementedError();
  }
}
