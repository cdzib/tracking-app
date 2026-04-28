
import 'package:vagonetas_app/features/mapa/domain/models/device.dart';
import 'package:vagonetas_app/features/mapa/domain/models/driver.dart';
import 'package:vagonetas_app/features/mapa/domain/models/location.dart';

class Vehicle {
  int? id;
  String? plate;
  String? vehicleType;
  String? status;
  Driver? driver;
  Device? device;
  Location? location;

  Vehicle(
      {this.id,
      this.plate,
      this.vehicleType,
      this.status,
      this.driver,
      this.device,
      this.location});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plate = json['plate'];
    vehicleType = json['vehicle_type'];
    status = json['status'];
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    device =
        json['device'] != null ? new Device.fromJson(json['device']) : null;
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plate'] = this.plate;
    data['vehicle_type'] = this.vehicleType;
    data['status'] = this.status;
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    if (this.device != null) {
      data['device'] = this.device!.toJson();
    }
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    return data;
  }
}
