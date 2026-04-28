import '../repositories/trip_chat_repository.dart';

class SendTripChatMessageUseCase {
  SendTripChatMessageUseCase(this._repository);

  final TripChatRepository _repository;

  Future<void> call({
    required int tripId,
    required int userId,
    required String userName,
    required String message,
  }) {
    return _repository.sendMessage(
      tripId: tripId,
      userId: userId,
      userName: userName,
      message: message,
    );
  }
}
