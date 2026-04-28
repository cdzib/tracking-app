import 'package:vagonetas_app/features/mapa/domain/models/battery.dart';

class Device {
  int? id;
  String? imei;
  String? status;
  double? latitude;
  double? longitude; 
  Battery? battery;

  Device({this.id, this.imei, this.status, this.latitude, this.longitude, this.battery});

  Device.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  imei = json['imei'];
  status = json['status'];
  latitude = json['latitude'];
  longitude = json['longitude'];
  battery = json['battery'] != null && json['battery'] is Map<String, dynamic>
    ? Battery.fromJson(json['battery'])
    : null;
  signalStrength = json['signal_strength'];
  lastUpdate = json['last_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imei'] = this.imei;
    data['status'] = this.status;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['battery'] = this.battery != null ? this.battery!.toJson() : null;
    data['signal_strength'] = this.signalStrength;
    data['last_update'] = this.lastUpdate;
    return data;
  }
  int? signalStrength;
  String? lastUpdate;
}
