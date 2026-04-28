import '../../domain/models/historial_item.dart';
import '../../domain/repositories/historial_repository.dart';

class FakeHistorialRepository implements HistorialRepository {
  @override
  Future<List<HistorialItem>> getHistorial() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      HistorialItem(
        id: '1',
        descripcion: 'Reserva completada de Ciudad A a Ciudad B',
        fecha: DateTime.now().subtract(const Duration(days: 1)),
      ),
      HistorialItem(
        id: '2',
        descripcion: 'Reserva cancelada de Ciudad C a Ciudad D',
        fecha: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
