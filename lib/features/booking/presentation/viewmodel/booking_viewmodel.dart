import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vagonetas_app/features/booking/data/model/trip_available_dto.dart';

import '../../domain/models/booking.dart';
import '../../domain/models/trip_summary.dart';
import '../../domain/usecases/get_available_trips_use_case.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel(
    this._getAvailableTripsUseCase,
  );

  final GetAvailableTripsUseCase _getAvailableTripsUseCase;
  final seatController = TextEditingController();
  List<int> selectedSeats = [];

  List<TripSummary> trips = [];
  List<int> occupiedSeats = [];
  Booking? latestBooking;
  TripSummary? selectedTrip;
  bool isLoading = false;
  String? errorMessage;

  /// Obtiene una página de viajes disponibles para paginación y expone la última respuesta.
  TripAvailableResponse? _lastTripsResponse;
  int _lastTripsPage = 1;
  Future<List<TripSummary>> fetchTripsPage(int page, int pageSize) async {
    log("Fetching trips page: $page, pageSize: $pageSize");
    final response = await _getAvailableTripsUseCase(page: page, pageSize: pageSize);
    _lastTripsResponse = response;
    _lastTripsPage = page;
    return List<TripSummary>.from(response.data ?? []);
  }

  /// Indica si hay más páginas de viajes disponibles según la última respuesta.
  bool hasMoreTrips(int currentPage, List<TripSummary> lastPageItems) {
    if (_lastTripsResponse == null) return false;
    // Si la API responde con lastPage y currentPage
    if (_lastTripsResponse!.lastPage != null && _lastTripsResponse!.currentPage != null) {
      return _lastTripsResponse!.currentPage! < _lastTripsResponse!.lastPage!;
    }
    // Fallback: si la cantidad de items es igual al pageSize, podría haber más
    return lastPageItems.length == (_lastTripsResponse!.perPage ?? lastPageItems.length);
  }

  @override
  void dispose() {
    seatController.dispose();
    super.dispose();
  }
}
