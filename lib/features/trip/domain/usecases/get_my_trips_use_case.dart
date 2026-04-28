import 'package:vagonetas_app/features/trip/data/models/trip_response.dart';

import '../repositories/trip_repository.dart';

class GetMyTripsUseCase {
  final TripRepository repository;
  GetMyTripsUseCase(this.repository);

  Future<TripResponse> call({
    required String status,
    int perPage = 15,
    int page = 1,
  }) async {
    return await repository.fetchMyTrips(status: status, perPage: perPage, page: page);
  }
}
