import 'package:vagonetas_app/features/booking/data/model/trip_available_dto.dart';

import '../repositories/bookings_repository.dart';

class GetAvailableTripsUseCase {
  GetAvailableTripsUseCase(this._repository);

  final BookingsRepository _repository;

  Future<TripAvailableResponse> call({int page = 1, int pageSize = 10}) {
    return _repository.getAvailableTrips(page: page, pageSize: pageSize);
  }
}
