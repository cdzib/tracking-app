import 'package:vagonetas_app/features/booking/data/model/trip_available_dto.dart';

import '../models/booking.dart';

abstract class BookingsRepository {
  Future<TripAvailableResponse> getAvailableTrips({int page = 1, int pageSize = 10});

  Future<List<int>> getOccupiedSeats(int tripId);

  Future<Booking?> createBooking({
    required int tripId,
    required int passengerId,
    required List<int> seats,
  });

  Future<Booking> updateBooking({
    required int bookingId,
    int? seat,
    String? status,
  });

  Future<void> cancelBooking(int bookingId);

  Future<List<Booking>> getBookings();
}
