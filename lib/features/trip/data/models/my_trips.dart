import 'package:vagonetas_app/features/mapa/domain/models/trip.dart';

class Trips {
  int? bookingId;
  String? status;
  List<Seats>? seats;
  Trip? trip;
  String? createdAt;

  Trips({this.bookingId, this.status, this.seats, this.trip, this.createdAt});

  Trips.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    status = json['status'];
    if (json['seats'] != null) {
      seats = <Seats>[];
      json['seats'].forEach((v) {
        seats!.add(new Seats.fromJson(v));
      });
    }
    trip = json['trip'] != null ? new Trip.fromJson(json['trip']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['status'] = this.status;
    if (this.seats != null) {
      data['seats'] = this.seats!.map((v) => v.toJson()).toList();
    }
    if (this.trip != null) {
      data['trip'] = this.trip!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Seats {
  String? qr;
  int? seat;

  Seats({this.qr, this.seat});

  Seats.fromJson(Map<String, dynamic> json) {
    qr = json['qr'];
    seat = json['seat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qr'] = this.qr;
    data['seat'] = this.seat;
    return data;
  }
}