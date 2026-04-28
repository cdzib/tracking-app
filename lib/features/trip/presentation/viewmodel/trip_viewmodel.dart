import 'package:flutter/material.dart';
import 'package:vagonetas_app/features/trip/data/models/trip_response.dart';
import '../../domain/usecases/get_my_trips_use_case.dart';

class TripViewModel extends ChangeNotifier {
  final GetMyTripsUseCase getMyTripsUseCase;
  TripViewModel(this.getMyTripsUseCase);

  bool isLoading = false;
  TripResponse? tripsResponse;
  String? error;

  Future<void> fetchMyTrips({String status = 'active', int perPage = 15, int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      tripsResponse = await getMyTripsUseCase(status: status, perPage: perPage, page: page);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
