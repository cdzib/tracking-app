import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/auth/auth_session.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/auth/data/auth_service.dart';
import 'package:vagonetas_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:vagonetas_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:vagonetas_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vagonetas_app/features/auth/domain/usecases/login_passenger_use_case.dart';
import 'package:vagonetas_app/features/auth/domain/usecases/logout_passenger_use_case.dart';
import 'package:vagonetas_app/features/auth/domain/usecases/register_passenger_use_case.dart';
import 'package:vagonetas_app/features/auth/presentation/viewmodel/auth_viewmodel.dart';

void setupAuthLocator(GetIt sl, {required bool useMockup}) {
  sl.registerLazySingleton(AuthSession.new);
  sl.registerLazySingleton(() => ApiClient(sl<AuthSession>()));

  sl.registerLazySingleton(
      () => AuthService(sl<ApiClient>(), sl<AuthSession>()));
  if (useMockup) {
    sl.registerLazySingleton<AuthRepository>(() => FakeAuthRepository());
  } else {
    sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl<AuthService>()));
  }
  sl.registerLazySingleton(() => LoginPassengerUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(
      () => RegisterPassengerUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutPassengerUseCase(sl<AuthRepository>()));
  sl.registerFactory(
    () => AuthViewModel(
      sl<LoginPassengerUseCase>(),
      sl<RegisterPassengerUseCase>(),
      sl<AuthSession>(),
    ),
  );
}
