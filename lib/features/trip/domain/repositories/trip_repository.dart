import 'package:vagonetas_app/features/trip/data/models/trip_response.dart';

abstract class TripRepository {
  Future<TripResponse> fetchMyTrips({
    required String status,
    int perPage,
    int page,
  });
}
