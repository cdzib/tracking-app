import 'package:vagonetas_app/features/booking/data/model/trip_available_dto.dart';
import 'package:vagonetas_app/features/booking/domain/models/trip_summary.dart';

import '../../domain/models/booking.dart';
import '../../domain/repositories/bookings_repository.dart';

class FakeBookingsRepository implements BookingsRepository {
  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Booking(
        id: 1,
        tripId: 1,
        passengerId: 1,
        status: 'completado',
        seats: List.empty()
      ),
      Booking(
        id: 2,
        tripId: 2,
        passengerId: 1,
        status: 'cancelado',
        seats: List.empty()
      ),
    ];
  }

  @override
  Future<void> cancelBooking(int bookingId) {
    // TODO: implement cancelBooking
    throw UnimplementedError();
  }

  @override
  Future<Booking> createBooking({required int tripId, required int passengerId, required List<int> seats}) {
    // TODO: implement createBooking
    throw UnimplementedError();
  }

  @override
  Future<TripAvailableResponse> getAvailableTrips({int page = 1, int pageSize = 10}) async {
    // TODO: implement getAvailableTrips
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getOccupiedSeats(int tripId) {
    // TODO: implement getOccupiedSeats
    throw UnimplementedError();
  }

  @override
  Future<Booking> updateBooking({required int bookingId, int? seat, String? status}) {
    // TODO: implement updateBooking
    throw UnimplementedError();
  }
}
