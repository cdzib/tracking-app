import 'package:flutter/foundation.dart';
import '../../features/auth/domain/models/passenger.dart';
import 'auth_persistence.dart';

class AuthSession extends ChangeNotifier {
  String? _token;
  Passenger? _passenger;

  String? get token => _token;
  Passenger? get passenger => _passenger;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  Future<void> saveSession({
    required String token,
    required Passenger passenger,
  }) async {
    _token = token;
    _passenger = passenger;
    await AuthPersistence.saveSession(token: token, passenger: passenger);
    notifyListeners();
  }

  Future<void> loadSession() async {
    final data = await AuthPersistence.loadSession();
    if (data != null) {
      _token = data['token'] as String;
      _passenger = data['passenger'] as Passenger;
      notifyListeners();
    }
  }

  Future<bool> isLoggedIn() async {
    await loadSession();
    return isAuthenticated;
  }

  Future<void> clear() async {
    _token = null;
    _passenger = null;
    await AuthPersistence.clearSession();
    notifyListeners();
  }
}
