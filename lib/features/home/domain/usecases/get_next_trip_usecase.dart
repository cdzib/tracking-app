import '../repositories/home_repository.dart';

class GetNextTripUseCase {
  final HomeRepository repository;
  GetNextTripUseCase(this.repository);
  Future<Map<String, dynamic>> call() async => repository.getNextTrip();
}
