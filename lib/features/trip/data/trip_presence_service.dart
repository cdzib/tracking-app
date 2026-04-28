import '../../../core/network/api_client.dart';

class TripPresenceService {
  TripPresenceService(this._apiClient);

  final ApiClient _apiClient;

  Future<void> syncPresence({
    required int tripId,
    required List<Map<String, dynamic>> users,
    required String type,
  }) async {
    await _apiClient.post(
      '/api/trips/$tripId/presence/sync',
      body: {
        'users': users,
        'type': type,
      },
      requiresAuth: true,
    );
  }
}
