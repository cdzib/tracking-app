import '../models/historial_item.dart';

abstract class HistorialRepository {
  Future<List<HistorialItem>> getHistorial();
}
