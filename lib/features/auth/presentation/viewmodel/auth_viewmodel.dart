import 'package:flutter/material.dart';

import '../../../../core/auth/auth_session.dart';
import '../../../../core/network/api_exception.dart';
import '../../domain/usecases/login_passenger_use_case.dart';
import '../../domain/usecases/register_passenger_use_case.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(
    this._loginPassengerUseCase,
    this._registerPassengerUseCase,
    this._session,
  );

  final LoginPassengerUseCase _loginPassengerUseCase;
  final RegisterPassengerUseCase _registerPassengerUseCase;
  final AuthSession _session;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  bool get isAuthenticated => _session.isAuthenticated;

  Future<void> login() async {
    await _perform(() async {
      final response = await _loginPassengerUseCase(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (response.token.isNotEmpty) {
        await _session.saveSession(token: response.token, passenger: response.passenger);
      }
    });
  }

  Future<void> register() async {
    await _perform(() async {
      final response = await _registerPassengerUseCase(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: passwordConfirmationController.text,
        phone: phoneController.text.trim(),
      );
      if (response.token.isNotEmpty) {
        await _session.saveSession(token: response.token, passenger: response.passenger);
      }
    });
  }

  Future<void> _perform(Future<void> Function() action) async {
    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      await action();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'No se pudo completar la solicitud.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }
}
