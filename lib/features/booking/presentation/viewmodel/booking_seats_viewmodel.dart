import 'package:flutter/material.dart';
import 'package:vagonetas_app/core/auth/auth_session.dart';
import 'package:vagonetas_app/core/network/api_exception.dart';
import 'package:vagonetas_app/features/booking/domain/models/booking.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/cancel_booking_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/create_booking_use_case.dart';
import 'package:vagonetas_app/features/booking/domain/usecases/get_occupied_seats_use_case.dart';
import '../../domain/models/trip_summary.dart';

class BookingSeatsViewModel extends ChangeNotifier {
  late TripSummary selectedTrip;
  late List<int> occupiedSeats;
  List<int> selectedSeats = [];
  bool isLoading = false;
  String? errorMessage;
  final GetOccupiedSeatsUseCase _getOccupiedSeatsUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;
  final AuthSession _session;
  Booking? latestBooking;
  final seatController = TextEditingController();

  BookingSeatsViewModel(
    this._getOccupiedSeatsUseCase,
    this._createBookingUseCase,
    this._cancelBookingUseCase,
    this._session,
  );

  Future<void> selectTrip(TripSummary trip) async {
    selectedTrip = trip;
    selectedSeats.clear();
    notifyListeners();
    await _run(() async {
      occupiedSeats = await _getOccupiedSeatsUseCase(trip.id!);
    }, keepSelection: true);
  }

  Future<void> cancelLatestBooking() async {
    final booking = latestBooking;
    if (booking == null) {
      errorMessage = 'Todavía no hay una reserva reciente para cancelar.';
      notifyListeners();
      return;
    }

    await _run(() async {
      await _cancelBookingUseCase(booking.id);
      latestBooking = null;
      occupiedSeats = await _getOccupiedSeatsUseCase(selectedTrip.id!);
    }, keepSelection: true);
  }

  void toggleSeat(int seat) {
    if (selectedSeats.contains(seat)) {
      selectedSeats.remove(seat);
    } else {
      selectedSeats.add(seat);
    }
    notifyListeners();
  }

  Future<void> createBooking() async {
    final trip = selectedTrip;
    final passengerId = _session.passenger?.id;
    if (passengerId == null || selectedSeats.isEmpty) {
      errorMessage = 'Selecciona un viaje y al menos un asiento válido.';
      notifyListeners();
      return;
    }
    await _run(() async {
      latestBooking = await _createBookingUseCase(
        tripId: trip.id!,
        passengerId: passengerId,
        seats: selectedSeats,
      );
      occupiedSeats = [...occupiedSeats, ...selectedSeats]..sort();
      selectedSeats.clear();
      seatController.clear();
    }, keepSelection: true);
  }

  Future<void> _run(
    Future<void> Function() action, {
    bool keepSelection = false,
  }) async {
    errorMessage = null;
    isLoading = true;
    notifyListeners();

    try {
      await action();
    } on ApiException catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'No se pudo completar la operación.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
