import 'package:vagonetas_app/features/home/di/home_injector.dart';
import 'package:vagonetas_app/features/mapa/di/mapa_injector.dart';
import 'package:vagonetas_app/features/auth/di/auth_injector.dart';
import 'package:vagonetas_app/features/booking/di/booking_injector.dart';
import 'package:vagonetas_app/features/history/di/historial_injector.dart';
import 'package:vagonetas_app/features/trip/di/trip_injector.dart';
import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/auth/auth_session.dart';
import 'package:vagonetas_app/features/auth/domain/usecases/logout_passenger_use_case.dart';
import 'package:vagonetas_app/features/profile/presentation/viewmodel/perfil_viewmodel.dart';

final sl = GetIt.instance;

/// Cambia este valor para activar/desactivar mockups globalmente
const bool useMockup = false;

class DI {
  static void setupLocator() {
    // Inyección de dependencias por feature
    setupAuthLocator(sl, useMockup: useMockup);
    setupMapaLocator(sl);
    setupBookingLocator(sl, useMockup: useMockup);
    setupHistorialLocator(sl, useMockup: useMockup);
    setupTripLocator(sl);
    setupHomeLocator(sl, useMockup: useMockup);
    
    sl.registerFactory(
      () => PerfilViewModel(
        sl<LogoutPassengerUseCase>(),
        sl<AuthSession>(),
      ),
    );
  }
}
