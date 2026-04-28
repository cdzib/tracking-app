import 'package:vagonetas_app/features/mapa/domain/models/trip.dart';
import 'package:vagonetas_app/features/mapa/domain/models/vehicle.dart';

class TripSummary {
  int? id;
  Vehicle? vehicle;
  Route? route;
  String? datetime;
  String? status;
  int? capacity;
  List<int>? occupiedSeats;
  List<int>? availableSeats;

  TripSummary(
      {this.id,
      this.vehicle,
      this.route,
      this.datetime,
      this.status,
      this.capacity,
      this.occupiedSeats,
      this.availableSeats});

  TripSummary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    route = json['route'] != null ? new Route.fromJson(json['route']) : null;
    datetime = json['datetime'];
    status = json['status'];
    capacity = json['capacity'];
    if (json['occupied_seats'] != null) {
      occupiedSeats = <int>[];
      json['occupied_seats'].forEach((v) {
        occupiedSeats!.add(v as int);
      });
    }
    availableSeats = json['available_seats'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    if (this.route != null) {
      data['route'] = this.route!.toJson();
    }
    data['datetime'] = this.datetime;
    data['status'] = this.status;
    data['capacity'] = this.capacity;
    if (this.occupiedSeats != null) {
      data['occupied_seats'] = this.occupiedSeats;
    }
    data['available_seats'] = this.availableSeats;
    return data;
  }
}

