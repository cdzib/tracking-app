import '../models/booking.dart';
import '../repositories/bookings_repository.dart';

class UpdateBookingUseCase {
  UpdateBookingUseCase(this._repository);

  final BookingsRepository _repository;

  Future<Booking> call({
    required int bookingId,
    int? seat,
    String? status,
  }) {
    return _repository.updateBooking(
      bookingId: bookingId,
      seat: seat,
      status: status,
    );
  }
}
