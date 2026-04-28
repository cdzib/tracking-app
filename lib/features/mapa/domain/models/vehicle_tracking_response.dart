import 'package:vagonetas_app/features/mapa/domain/models/vehicle_detail_response.dart';

class VehicleTrackingResponse {
  bool? success;
  int? count;
  List<VehicleDetailResponse>? data;

  VehicleTrackingResponse({this.success, this.count, this.data});

  VehicleTrackingResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    if (json['data'] != null) {
      data = <VehicleDetailResponse>[];
      json['data'].forEach((v) {
        data!.add(new VehicleDetailResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
