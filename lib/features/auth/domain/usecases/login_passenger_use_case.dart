import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginPassengerUseCase {
  LoginPassengerUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResponse> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
