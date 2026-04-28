import 'booking_seat.dart';

class Booking {
  Booking({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.status,
    required this.seats,
  });

  final int id;
  final int tripId;
  final int passengerId;
  final String status;
  final List<BookingSeat> seats;

  factory Booking.fromJson(Map<String, dynamic> json) {
    final seats = json['seats'] as List<dynamic>? ?? const [];
    return Booking(
      id: json['id'] as int,
      tripId: json['trip_id'] as int,
      passengerId: json['passenger_id'] as int,
      status: json['status']?.toString() ?? '',
      seats: seats
          .whereType<Map<String, dynamic>>()
          .map(BookingSeat.fromJson)
          .toList(),
    );
  }
}
