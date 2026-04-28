import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';

abstract class HomeRepository {
  Future<Map<String, dynamic>> getNextTrip();
  Future<HistoryResponse> getAvailableTrips({required int page, required int perPage});
  Future<List<Recents>> getRecentTrips();
}
