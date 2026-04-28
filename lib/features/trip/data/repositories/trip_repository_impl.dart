import 'package:vagonetas_app/features/trip/data/models/trip_response.dart';

import '../../domain/repositories/trip_repository.dart';
import '../service/trip_service.dart';

class TripRepositoryImpl implements TripRepository {
  final TripService service;
  TripRepositoryImpl(this.service);

  @override
  Future<TripResponse> fetchMyTrips({
    required String status,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await service.fetchMyTrips(status: status, perPage: perPage, page: page);
    return response;
  }
}
