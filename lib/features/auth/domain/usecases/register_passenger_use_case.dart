import '../models/auth_response.dart';
import '../repositories/auth_repository.dart';

class RegisterPassengerUseCase {
  RegisterPassengerUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResponse> call({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) {
    return _repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
    );
  }
}
