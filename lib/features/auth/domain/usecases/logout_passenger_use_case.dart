import '../repositories/auth_repository.dart';

class LogoutPassengerUseCase {
  LogoutPassengerUseCase(this._repository);

  final AuthRepository _repository;

  void call() {
    _repository.logout();
  }
}
