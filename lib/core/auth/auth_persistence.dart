import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/domain/models/passenger.dart';

class AuthPersistence {
  static const _tokenKey = 'auth_token';
  static const _passengerIdKey = 'passenger_id';
  static const _passengerNameKey = 'passenger_name';
  static const _passengerEmailKey = 'passenger_email';
  static const _passengerPhoneKey = 'passenger_phone';

  static Future<void> saveSession({required String token, required Passenger passenger}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_passengerIdKey, passenger.id);
    await prefs.setString(_passengerNameKey, passenger.name);
    await prefs.setString(_passengerEmailKey, passenger.email);
    await prefs.setString(_passengerPhoneKey, passenger.phone);
  }

  static Future<Map<String, dynamic>?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    if (token == null || token.isEmpty) return null;
    final id = prefs.getInt(_passengerIdKey);
    final name = prefs.getString(_passengerNameKey);
    final email = prefs.getString(_passengerEmailKey);
    final phone = prefs.getString(_passengerPhoneKey);
    if (id == null || name == null || email == null || phone == null) return null;
    return {
      'token': token,
      'passenger': Passenger(id: id, name: name, email: email, phone: phone),
    };
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_passengerIdKey);
    await prefs.remove(_passengerNameKey);
    await prefs.remove(_passengerEmailKey);
    await prefs.remove(_passengerPhoneKey);
  }
}
