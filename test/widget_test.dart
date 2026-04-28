import 'package:flutter_test/flutter_test.dart';
import 'package:vagonetas_app/app.dart';
import 'package:vagonetas_app/core/di/injector.dart';

void main() {
  testWidgets('renders login screen', (tester) async {
    DI.setupLocator();
    await tester.pumpWidget(const App());

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
