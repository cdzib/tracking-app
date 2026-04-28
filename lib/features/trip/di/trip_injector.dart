import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:vagonetas_app/features/trip/data/service/trip_service.dart';
import 'package:vagonetas_app/features/trip/data/trip_chat_service.dart';
import 'package:vagonetas_app/features/trip/data/trip_presence_service.dart';
import 'package:vagonetas_app/features/trip/data/repositories/trip_chat_repository_impl.dart';
import 'package:vagonetas_app/features/trip/data/repositories/trip_presence_repository_impl.dart';
import 'package:vagonetas_app/features/trip/domain/repositories/trip_chat_repository.dart';
import 'package:vagonetas_app/features/trip/domain/repositories/trip_presence_repository.dart';
import 'package:vagonetas_app/features/trip/domain/usecases/get_trip_chat_history_use_case.dart';
import 'package:vagonetas_app/features/trip/domain/usecases/send_trip_chat_message_use_case.dart';
import 'package:vagonetas_app/features/trip/domain/usecases/sync_trip_presence_use_case.dart';

void setupTripLocator(GetIt sl) {
  sl.registerLazySingleton(() => TripChatService(sl<ApiClient>()));
  sl.registerLazySingleton(() => TripPresenceService(sl<ApiClient>()));
  sl.registerLazySingleton<TripService>(() => TripService(sl<ApiClient>()));
  sl.registerLazySingleton<TripChatRepository>(
      () => TripChatRepositoryImpl(sl<TripChatService>()));
  sl.registerLazySingleton<TripPresenceRepository>(
      () => TripPresenceRepositoryImpl(sl<TripPresenceService>()));
  sl.registerLazySingleton(
      () => GetTripChatHistoryUseCase(sl<TripChatRepository>()));
  sl.registerLazySingleton(
      () => SendTripChatMessageUseCase(sl<TripChatRepository>()));
  sl.registerLazySingleton(
      () => SyncTripPresenceUseCase(sl<TripPresenceRepository>()));
  sl.registerLazySingleton(() => TripRepositoryImpl(sl<TripService>()));
}
