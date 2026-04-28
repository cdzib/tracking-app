import '../../../core/network/api_client.dart';

class TripChatService {
  TripChatService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> getHistory(int tripId) async {
    final response = await _apiClient.get(
      '/api/trips/$tripId/chat',
      requiresAuth: true,
    );

    final items = response as List<dynamic>? ?? const [];
    return items.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> sendMessage({
    required int tripId,
    required int userId,
    required String userName,
    required String message,
  }) async {
    await _apiClient.post(
      '/api/trips/$tripId/chat',
      body: {
        'user_id': userId,
        'user_name': userName,
        'message': message,
      },
      requiresAuth: true,
    );
  }
}
