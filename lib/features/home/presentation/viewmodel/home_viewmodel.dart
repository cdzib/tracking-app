import 'package:flutter/material.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import 'package:vagonetas_app/features/trip/domain/models/trip_recents.dart';
import '../../domain/usecases/get_next_trip_usecase.dart';
import '../../domain/usecases/get_available_trips_usecase.dart';
import '../../domain/usecases/get_recent_trips_usecase.dart';

class HomeViewModel extends ChangeNotifier {
  bool get isLoading =>
      isLoadingNextTrip || isLoadingAvailableTrips || isLoadingRecentTrips;
  final GetNextTripUseCase getNextTripUseCase;
  final GetAvailableTripsUseCase getAvailableTripsUseCase;
  final GetRecentTripsUseCase getRecentTripsUseCase;

  HomeViewModel({
    required this.getNextTripUseCase,
    required this.getAvailableTripsUseCase,
    required this.getRecentTripsUseCase,
  });

  // Próximo viaje
  Map<String, dynamic>? nextTrip;
  bool isLoadingNextTrip = false;
  String? errorNextTrip;

  // Viajes disponibles
  List<History> availableTrips = [];
  bool isLoadingAvailableTrips = false;
  String? errorAvailableTrips;

  // Últimos viajes
  List<Recents> recentTrips = [];
  bool isLoadingRecentTrips = false;
  String? errorRecentTrips;

  Future<void> loadHomeData() async {
    await Future.wait([
      _loadNextTrip(),
      _loadAvailableTrips(),
      _loadRecentTrips(),
    ]);
  }

  Future<void> _loadNextTrip() async {
    isLoadingNextTrip = true;
    errorNextTrip = null;
    notifyListeners();
    try {
      nextTrip = await getNextTripUseCase();
    } catch (e) {
      errorNextTrip = "No se pudo cargar el próximo viaje";
    }
    isLoadingNextTrip = false;
    notifyListeners();
  }

  Future<void> _loadAvailableTrips() async {
    isLoadingAvailableTrips = true;
    errorAvailableTrips = null;
    notifyListeners();
    try {
      final response = await getAvailableTripsUseCase(page: 1, perPage: 10);
      availableTrips = response.data!;
    } catch (e) {
      errorAvailableTrips = e.toString();
    }
    isLoadingAvailableTrips = false;
    notifyListeners();
  }

  Future<void> _loadRecentTrips() async {
    isLoadingRecentTrips = true;
    errorRecentTrips = null;
    notifyListeners();
    try {
      recentTrips = await getRecentTripsUseCase();
    } catch (e) {
      errorRecentTrips = e.toString();
    }
    isLoadingRecentTrips = false;
    notifyListeners();
  }
}
