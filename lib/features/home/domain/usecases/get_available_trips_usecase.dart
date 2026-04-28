import '../repositories/home_repository.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';

class GetAvailableTripsUseCase {
  final HomeRepository repository;
  GetAvailableTripsUseCase(this.repository);
  Future<HistoryResponse> call({required int page, required int perPage}) async => repository.getAvailableTrips(page: page, perPage: perPage);
}
