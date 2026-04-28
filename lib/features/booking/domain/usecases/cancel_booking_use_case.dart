import '../repositories/bookings_repository.dart';

class CancelBookingUseCase {
  CancelBookingUseCase(this._repository);

  final BookingsRepository _repository;

  Future<void> call(int bookingId) {
    return _repository.cancelBooking(bookingId);
  }
}
