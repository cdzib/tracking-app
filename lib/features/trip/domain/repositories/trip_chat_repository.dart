abstract class TripChatRepository {
  Future<List<Map<String, dynamic>>> getHistory(int tripId);

  Future<void> sendMessage({
    required int tripId,
    required int userId,
    required String userName,
    required String message,
  });
}
