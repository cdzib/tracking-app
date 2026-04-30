import 'package:vagonetas_app/features/history/data/models/history_response.dart';

abstract class HistorialRepository {
  Future<HistoryResponse> getHistorial({int page = 1, int perPage = 10});
}
