import 'package:flutter/material.dart';

import '../../../../core/auth/auth_session.dart';
import '../../../auth/domain/usecases/logout_passenger_use_case.dart';

class PerfilViewModel extends ChangeNotifier {
  PerfilViewModel(this._logoutPassengerUseCase, this._session);

  final LogoutPassengerUseCase _logoutPassengerUseCase;
  final AuthSession _session;

  String get name => _session.passenger?.name ?? 'Invitado';
  String get email => _session.passenger?.email ?? 'Sin correo';
  String get phone => _session.passenger?.phone ?? 'Sin teléfono';

  void logout() {
    _logoutPassengerUseCase();
    notifyListeners();
  }
}
