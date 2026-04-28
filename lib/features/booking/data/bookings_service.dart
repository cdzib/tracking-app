import '../../../core/network/api_client.dart';
import '../domain/models/booking.dart';
import '../data/model/trip_available_dto.dart';

class BookingsService {
  BookingsService(this._apiClient);

  final ApiClient _apiClient;

  Future<TripAvailableResponse> getAvailableTrips({int page = 1, int pageSize = 10}) async {
    final response = await _apiClient.get(
      '/api/bookings/available-trips',
      queryParameters: {
        'page': page.toString(),
        'per_page': pageSize.toString(),
      },
      requiresAuth: true,
    );
    final items = response;
    return TripAvailableResponse.fromJson(items as Map<String, dynamic>);
  }

  Future<List<int>> getOccupiedSeats(int tripId) async {
    final response = await _apiClient.get(
      '/api/bookings/occupied-seats',
      queryParameters: {'trip_id': '$tripId'},
      requiresAuth: true,
    );

    final payload = response as Map<String, dynamic>? ?? const {};
    final seats = payload['seats'] as List<dynamic>? ?? const [];
    return seats
        .whereType<Map<String, dynamic>>()
        .map((seat) => seat['seat'])
        .whereType<int>()
        .toList();
  }

  Future<Booking> createBooking({
    required int tripId,
    required int passengerId,
    required List<int> seats,
  }) async {
    final response = await _apiClient.post(
      '/api/bookings',
      body: {
        'trip_id': tripId,
        'passenger_id': passengerId,
        'seats': seats,
      },
      requiresAuth: true,
    );

    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<Booking> updateBooking({
    required int bookingId,
    int? seat,
    String? status,
  }) async {
    final response = await _apiClient.patch(
      '/api/bookings/$bookingId',
      body: {
        if (seat != null) 'seat': seat,
        if (status != null) 'status': status,
      },
      requiresAuth: true,
    );

    return Booking.fromJson(response as Map<String, dynamic>);
  }

  Future<void> cancelBooking(int bookingId) async {
    await _apiClient.delete(
      '/api/bookings/$bookingId',
      requiresAuth: true,
    );
  }
}
