import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/mapa/data/vehicles_service.dart';
import 'package:vagonetas_app/features/mapa/data/vehicles_repository_impl.dart';
import 'package:vagonetas_app/features/mapa/domain/repositories/vehicles_repository.dart';
import 'package:vagonetas_app/features/mapa/domain/usecases/fetch_vehicles_tracking_use_case.dart';
import 'package:vagonetas_app/features/mapa/presentation/viewmodel/mapa_tracking_viewmodel.dart';
import 'package:vagonetas_app/features/mapa/presentation/viewmodel/mapa_viewmodel.dart';

void setupMapaLocator(GetIt sl) {
  // Servicios
  sl.registerLazySingleton<VehiclesService>(() => VehiclesService(sl<ApiClient>()));

  // Repositorios
  sl.registerLazySingleton<VehiclesRepository>(
    () => VehiclesRepositoryImpl(sl<VehiclesService>()),
  );

  // Casos de uso
  sl.registerLazySingleton<FetchVehiclesTrackingUseCase>(
    () => FetchVehiclesTrackingUseCase(sl<VehiclesRepository>()),
  );
  sl.registerLazySingleton<FetchVehicleDetailUseCase>(
    () => FetchVehicleDetailUseCase(sl<VehiclesRepository>()),
  );
  // ViewModels
  sl.registerFactory(() => MapaViewModel(
    sl<FetchVehicleDetailUseCase>(),
  ));
  sl.registerFactory(() => MapaTrackingViewModel(sl<FetchVehiclesTrackingUseCase>()));
}