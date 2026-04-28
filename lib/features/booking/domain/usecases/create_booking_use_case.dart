import '../models/booking.dart';
import '../repositories/bookings_repository.dart';

class CreateBookingUseCase {
  CreateBookingUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Booking?> call({
    required int tripId,
    required int passengerId,
    required List<int> seats,
  }) {
    return _repository.createBooking(
      tripId: tripId,
      passengerId: passengerId,
      seats: seats,
    );
  }
}
