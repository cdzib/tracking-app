import 'package:flutter/material.dart';
import 'package:vagonetas_app/core/di/injector.dart';
import 'package:vagonetas_app/features/history/data/models/history_response.dart';
import '../../domain/repositories/historial_repository.dart';

class HistorialViewModel extends ChangeNotifier {
  final HistorialRepository _repository = sl<HistorialRepository>();

  List<History> historial = [];
  bool isLoading = false;
  String? error;
  int total = 0;
  int currentPage = 1;
  int lastPage = 1;

  HistorialViewModel();

  Future<void> loadHistorial() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _repository.getHistorial();
      _applyResponse(response, replace: true);
    } catch (e) {
      error = 'Error al cargar el historial';
    }
    isLoading = false;
    notifyListeners();
  }

  Future<List<History>> fetchHistorialPage(int page, int pageSize) async {
    error = null;
    notifyListeners();
    try {
      final response = await _repository.getHistorial(
        page: page,
        perPage: pageSize,
      );
      _applyResponse(response, replace: page == 1);
      notifyListeners();
      return response.data ?? [];
    } catch (e) {
      error = 'Error al cargar el historial';
      notifyListeners();
      rethrow;
    }
  }

  bool hasMoreHistorial(int page, List<History> _) => page < lastPage;

  void _applyResponse(HistoryResponse response, {required bool replace}) {
    final items = response.data ?? [];
    currentPage = response.currentPage ?? currentPage;
    lastPage = response.lastPage ?? lastPage;
    total = response.total ?? items.length;

    if (replace) {
      historial = List<History>.from(items);
    } else {
      historial = [...historial, ...items];
    }
  }
}
