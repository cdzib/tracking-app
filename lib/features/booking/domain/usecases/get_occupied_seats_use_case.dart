import '../repositories/bookings_repository.dart';

class GetOccupiedSeatsUseCase {
  GetOccupiedSeatsUseCase(this._repository);

  final BookingsRepository _repository;

  Future<List<int>> call(int tripId) {
    return _repository.getOccupiedSeats(tripId);
  }
}
