import '../../domain/models/booking.dart';
import '../../data/model/trip_available_dto.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../bookings_service.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl(this._service);

  final BookingsService _service;

  @override
  Future<TripAvailableResponse> getAvailableTrips({int page = 1, int pageSize = 10}) {
    return _service.getAvailableTrips(page: page, pageSize: pageSize);
  }

  @override
  Future<List<int>> getOccupiedSeats(int tripId) {
    return _service.getOccupiedSeats(tripId);
  }

  @override
  Future<Booking> createBooking({
    required int tripId,
    required int passengerId,
    required List<int> seats,
  }) {
    return _service.createBooking(
      tripId: tripId,
      passengerId: passengerId,
      seats: seats,
    );
  }

  @override
  Future<Booking> updateBooking({
    required int bookingId,
    int? seat,
    String? status,
  }) {
    return _service.updateBooking(
      bookingId: bookingId,
      seat: seat,
      status: status,
    );
  }

  @override
  Future<void> cancelBooking(int bookingId) {
    return _service.cancelBooking(bookingId);
  }
  
  @override
  Future<List<Booking>> getBookings() {
    // TODO: implement getBookings
    throw UnimplementedError();
  }
}
