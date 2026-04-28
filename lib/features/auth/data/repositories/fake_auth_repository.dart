import 'package:vagonetas_app/features/auth/domain/models/auth_response.dart';

import '../../domain/models/passenger.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthResponse> login({
    required String email, 
    required String password
    }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email == 'test@correo.com' && password == '123456') {
      return AuthResponse(passenger: Passenger(id: 1, name: 'Test User', email: email, phone: ""), token: 'fake_token');
    }
    return AuthResponse(passenger: Passenger(id: 0, name: 'Invalid User', email: email, phone: ""), token: '');
  }

  @override
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AuthResponse(passenger: Passenger(id: 2, name: name, email: email, phone: phone ), token: 'fake_token');
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
