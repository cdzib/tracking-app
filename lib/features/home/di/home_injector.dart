import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:vagonetas_app/features/home/data/service/home_service.dart';
import 'package:vagonetas_app/features/home/domain/repositories/home_repository.dart';
import 'package:vagonetas_app/features/home/domain/usecases/get_available_trips_usecase.dart';
import 'package:vagonetas_app/features/home/domain/usecases/get_next_trip_usecase.dart';
import 'package:vagonetas_app/features/home/domain/usecases/get_recent_trips_usecase.dart';
import 'package:vagonetas_app/features/home/presentation/viewmodel/home_viewmodel.dart';

void setupHomeLocator(GetIt sl, {required bool useMockup}) {
  
  sl.registerLazySingleton(() => HomeService(sl<ApiClient>()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl<HomeService>()));

  sl.registerLazySingleton(() => GetNextTripUseCase(sl<HomeRepository>()));
  sl.registerLazySingleton(() => GetAvailableTripsUseCase(sl<HomeRepository>())); 
  sl.registerLazySingleton(() => GetRecentTripsUseCase(sl<HomeRepository>()));

  
  sl.registerFactory(
    () => HomeViewModel(
      getNextTripUseCase: sl<GetNextTripUseCase>(),
      getAvailableTripsUseCase: sl<GetAvailableTripsUseCase>(),
      getRecentTripsUseCase: sl<GetRecentTripsUseCase>(),
    ),
  );
}