import '../../domain/repositories/trip_presence_repository.dart';
import '../trip_presence_service.dart';

class TripPresenceRepositoryImpl implements TripPresenceRepository {
  TripPresenceRepositoryImpl(this._service);

  final TripPresenceService _service;

  @override
  Future<void> syncPresence({
    required int tripId,
    required List<Map<String, dynamic>> users,
    required String type,
  }) {
    return _service.syncPresence(
      tripId: tripId,
      users: users,
      type: type,
    );
  }
}
