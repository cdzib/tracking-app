import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/core/auth/auth_session.dart';
import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/booking/data/bookings_service.dart';
import 'package:vagonetas_app/features/booking/data/repositories/bookings_repository_impl.dart';
import 'package:vagonetas_app/features/booking/data/repositories/fake_bookings_repository.dart';
import 'package:vagonetas_app/features/booking/domain/repositories/bookings_repository.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/get_available_trips_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/get_occupied_seats_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/update_booking_use_case.dart';
import 'package:vagonetas_app/features/booking/presentation/viewmodel/booking_seats_viewmodel.dart';
import 'package:vagonetas_app/features/booking/presentation/viewmodel/booking_viewmodel.dart';

void setupBookingLocator(GetIt sl, {required bool useMockup}) {
  if (useMockup) {
    sl.registerLazySingleton<BookingsRepository>(
        () => FakeBookingsRepository());
  } else {
    sl.registerLazySingleton<BookingsRepository>(
        () => BookingsRepositoryImpl(sl<BookingsService>()));
  }
  sl.registerLazySingleton(() => BookingsService(sl<ApiClient>()));
  sl.registerLazySingleton(
      () => GetAvailableTripsUseCase(sl<BookingsRepository>()));
  sl.registerLazySingleton(
      () => GetOccupiedSeatsUseCase(sl<BookingsRepository>()));
  sl.registerLazySingleton(
      () => CreateBookingUseCase(sl<BookingsRepository>()));
  sl.registerLazySingleton(
      () => UpdateBookingUseCase(sl<BookingsRepository>()));
  sl.registerLazySingleton(
      () => CancelBookingUseCase(sl<BookingsRepository>()));

  sl.registerFactory(
    () => BookingViewModel(
      sl<GetAvailableTripsUseCase>(),
    ),
  );
  sl.registerFactory(
    () => BookingSeatsViewModel(
      sl<GetOccupiedSeatsUseCase>(),
      sl<CreateBookingUseCase>(),
      sl<CancelBookingUseCase>(),
      sl<AuthSession>(),
    ),
  );
}
