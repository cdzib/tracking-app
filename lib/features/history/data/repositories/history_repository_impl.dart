import 'package:vagonetas_app/features/history/data/history_service.dart';
import 'package:vagonetas_app/features/history/domain/repositories/historial_repository.dart';

import '../models/history_response.dart';

class HistoryRepositoryImpl extends HistorialRepository {
  final HistoryService _historyService;

  HistoryRepositoryImpl(this._historyService);

  @override
  Future<HistoryResponse> getHistorial({int page = 1, int perPage = 10}) {
    return _historyService.fetchHistory(page: page, perPage: perPage);
  }
}
