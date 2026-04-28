import 'package:vagonetas_app/features/mapa/domain/models/device.dart';
import 'package:vagonetas_app/features/mapa/domain/models/location.dart';
import 'package:vagonetas_app/features/mapa/domain/models/trip.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle.dart';

class VehicleDetailResponse {
  final Vehicle vehicle;
  final Device device;
  final Location location;
  final Trip? trip;

  VehicleDetailResponse({
    required this.vehicle,
    required this.device,
    required this.location,
    this.trip,
  });

  factory VehicleDetailResponse.fromJson(Map<String, dynamic> json) {
    return VehicleDetailResponse(
      vehicle: Vehicle.fromJson(json['vehicle']),
      device: Device.fromJson(json['device']),
      location: Location.fromJson(json['location']),
      trip: json['trip'] != null ? Trip.fromJson(json['trip']) : null,
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'vehicle': vehicle.toJson(),
      'device': device.toJson(),
      'location': location.toJson(),
      'trip': trip?.toJson(),
    };
  }
}
