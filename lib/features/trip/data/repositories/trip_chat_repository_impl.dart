import '../../domain/repositories/trip_chat_repository.dart';
import '../trip_chat_service.dart';

class TripChatRepositoryImpl implements TripChatRepository {
  TripChatRepositoryImpl(this._service);

  final TripChatService _service;

  @override
  Future<List<Map<String, dynamic>>> getHistory(int tripId) {
    return _service.getHistory(tripId);
  }

  @override
  Future<void> sendMessage({
    required int tripId,
    required int userId,
    required String userName,
    required String message,
  }) {
    return _service.sendMessage(
      tripId: tripId,
      userId: userId,
      userName: userName,
      message: message,
    );
  }
}
