import 'passenger.dart';

class AuthResponse {
  AuthResponse({
    required this.passenger,
    required this.token,
  });

  final Passenger passenger;
  final String token;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      passenger: Passenger.fromJson(json['passenger'] as Map<String, dynamic>),
      token: json['token']?.toString() ?? '',
    );
  }
}
