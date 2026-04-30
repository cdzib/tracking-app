import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import 'package:vagonetas_app/features/mapa/domain/models/trip.dart';
import '../../domain/repositories/historial_repository.dart';

class FakeHistorialRepository implements HistorialRepository {
  @override
  Future<HistoryResponse> getHistorial({int page = 1, int perPage = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return HistoryResponse(
      currentPage: page,
      data: [
        History(
          bookingId: 1,
          trip: Trip(
            id: 1,
          ),
        ),
        History(
          bookingId: 2,
          trip: Trip(
            id: 2,
          ),
        ),
      ],
      firstPageUrl: 'https://api.example.com/history?page=1',
      from: 1,
      lastPage: 1,
      lastPageUrl: 'https://api.example.com/history?page=1',
      links: [],
      nextPageUrl: null,
      perPage: perPage,
      total: 2,
    );
  }
}
