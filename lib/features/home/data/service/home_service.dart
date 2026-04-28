import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';

class HomeService {
  final ApiClient _apiClient;
  HomeService(this._apiClient);

  Future<Map<String, dynamic>> getNextTrip() async {
    final response = await _apiClient.get('/api/trips/next', requiresAuth: true);
    return response.data;
  }
  Future<HistoryResponse> getAvailableTrips({required int page, required int perPage}) async {
    final response = await _apiClient.get('/api/trips/history', queryParameters: {'status': 'active', 'page': page.toString(), 'per_page': perPage.toString()}, requiresAuth: true);
    print('Available Trips Response: $response'); // Debug print
    return HistoryResponse.fromJson(response);
  }
  Future<List<Recents>> getRecentTrips() async {
    final response = await _apiClient.get('/api/trips/recent', requiresAuth: true);
    return (response as List).map((json) => Recents.fromJson(json)).toList();
  }
}
