abstract class TripPresenceRepository {
  Future<void> syncPresence({
    required int tripId,
    required List<Map<String, dynamic>> users,
    required String type,
  });
}
