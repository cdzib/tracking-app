import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';

import '../../domain/repositories/home_repository.dart';
import '../service/home_service.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeService service;
  HomeRepositoryImpl(this.service);

  @override
  Future<Map<String, dynamic>> getNextTrip() async {
    final res = await service.getNextTrip();
    return res;
  }

  @override
  Future<HistoryResponse> getAvailableTrips({required int page, required int perPage}) async {
    final res = await service.getAvailableTrips(page: page, perPage: perPage);
    return res;
  }

  @override
  Future<List<Recents>> getRecentTrips() async {
    final res = await service.getRecentTrips();
    return res;
  }
}
