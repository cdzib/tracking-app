import '../repositories/trip_chat_repository.dart';

class GetTripChatHistoryUseCase {
  GetTripChatHistoryUseCase(this._repository);

  final TripChatRepository _repository;

  Future<List<Map<String, dynamic>>> call(int tripId) {
    return _repository.getHistory(tripId);
  }
}
