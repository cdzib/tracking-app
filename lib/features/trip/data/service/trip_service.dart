import 'dart:convert';

import 'package:vagonetas_app/core/network/api_client.dart';
import 'package:vagonetas_app/features/trip/data/models/trip_response.dart';

class TripService {
  TripService(this._apiClient);

  final ApiClient _apiClient;
  Future<TripResponse> fetchMyTrips({
    required String status,
    int perPage = 15,
    int page = 1,
  }) async {
    final response = await _apiClient.get(
      '/api/my-trips',
      queryParameters: {
        'status': status,
        'per_page': perPage.toString(),
        'page': page.toString(),
      },
      requiresAuth: true,
    );

    if (response.statusCode == 200) {
      return TripResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load my trips');
    }
  }
}
