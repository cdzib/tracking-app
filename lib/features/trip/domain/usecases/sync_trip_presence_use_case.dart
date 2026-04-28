import '../repositories/trip_presence_repository.dart';

class SyncTripPresenceUseCase {
  SyncTripPresenceUseCase(this._repository);

  final TripPresenceRepository _repository;

  Future<void> call({
    required int tripId,
    required List<Map<String, dynamic>> users,
    required String type,
  }) {
    return _repository.syncPresence(
      tripId: tripId,
      users: users,
      type: type,
    );
  }
}
