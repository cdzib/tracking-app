import 'package:flutter/material.dart';
import 'package:vagonetas_app/core/di/injector.dart';
import '../../domain/models/historial_item.dart';
import '../../domain/repositories/historial_repository.dart';

class HistorialViewModel extends ChangeNotifier {
  final HistorialRepository _repository = sl<HistorialRepository>();

  List<HistorialItem> historial = [];
  bool isLoading = false;
  String? error;

  HistorialViewModel() {
    loadHistorial();
  }

  Future<void> loadHistorial() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      historial = await _repository.getHistorial();
    } catch (e) {
      error = 'Error al cargar el historial';
    }
    isLoading = false;
    notifyListeners();
  }
}
