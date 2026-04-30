import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';

class HistoryService {
  final ApiClient _apiClient;
  HistoryService(this._apiClient);

  Future<HistoryResponse> fetchHistory({
    int page = 1,
    int perPage = 10,
  }) async {
    final response = await _apiClient.get(
      '/api/trips/history',
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
      requiresAuth: true,
    );
    return HistoryResponse.fromJson(response);
  }
}
