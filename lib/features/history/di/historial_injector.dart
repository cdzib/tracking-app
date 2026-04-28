import 'package:get_it/get_it.dart';
import 'package:vagonetas_app/features/history/data/repositories/fake_historial_repository.dart';
import 'package:vagonetas_app/features/history/data/repositories/history_repository_impl.dart';
import 'package:vagonetas_app/features/history/domain/repositories/historial_repository.dart';
import 'package:vagonetas_app/features/history/presentation/viewmodel/historial_viewmodel.dart';

void setupHistorialLocator(GetIt sl, {required bool useMockup}) {
  if (useMockup) {
    sl.registerLazySingleton<HistorialRepository>(() => FakeHistorialRepository());
  } else {
    sl.registerLazySingleton<HistorialRepository>(() => HistoryRepositoryImpl());
  }
  sl.registerFactory(HistorialViewModel.new);
}
