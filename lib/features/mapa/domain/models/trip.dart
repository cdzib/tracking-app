class Trip {
  int? id;
  int? vehicleId;
  int? routeId;
  String? status;
  String? datetime;
  String? createdAt;
  String? updatedAt;
  Route? route;
  List<Booking>? bookings;

  Trip(
      {this.id,
      this.vehicleId,
      this.routeId,
      this.status,
      this.datetime,
      this.createdAt,
      this.updatedAt,
      this.route,
      this.bookings});

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    routeId = json['route_id'];
    status = json['status'];
    datetime = json['datetime'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    route = json['route'] != null ? Route.fromJson(json['route']) : null;
    if (json['bookings'] != null) {
      bookings = <Booking>[];
      json['bookings'].forEach((v) {
        bookings!.add(Booking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['vehicle_id'] = vehicleId;
    data['route_id'] = routeId;
    data['status'] = status;
    data['datetime'] = datetime;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (route != null) {
      data['route'] = route!.toJson();
    }
    if (bookings != null) {
      data['bookings'] = bookings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  int? id;
  int? tripId;
  int? passengerId;
  String? createdAt;
  String? updatedAt;

  Booking(
      {this.id,
      this.tripId,
      this.passengerId,
      this.createdAt,
      this.updatedAt});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tripId = json['trip_id'];
    passengerId = json['passenger_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['trip_id'] = tripId;
    data['passenger_id'] = passengerId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
class Route {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;

  Route({this.id, this.name, this.createdAt, this.updatedAt});

  Route.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}