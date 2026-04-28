import '../repositories/home_repository.dart';
import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';

class GetRecentTripsUseCase {
  final HomeRepository repository;
  GetRecentTripsUseCase(this.repository);
  Future<List<Recents>> call() async => repository.getRecentTrips();
}
