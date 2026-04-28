import '../../../core/auth/auth_session.dart';
import '../../../core/network/api_client.dart';
import '../domain/models/auth_response.dart';

class AuthService {
  AuthService(this._apiClient, this._session);

  final ApiClient _apiClient;
  final AuthSession _session;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    print('Attempting login with email: $email');
    final response = await _apiClient.post(
      '/api/auth/passenger/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    print('Login response: $response');
    final auth = AuthResponse.fromJson(response as Map<String, dynamic>);
    await _session.saveSession(token: auth.token, passenger: auth.passenger);
    return auth;
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    final response = await _apiClient.post(
      '/api/auth/passenger/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'phone': phone,
      },
    );

    final auth = AuthResponse.fromJson(response as Map<String, dynamic>);
    await _session.saveSession(token: auth.token, passenger: auth.passenger);
    return auth;
  }

  Future<void> logout() async {
    await _session.clear();
  }
}
