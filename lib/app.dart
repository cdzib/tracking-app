import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vagonetas_app/core/providers.dart';
import 'package:vagonetas_app/core/theme/theme_provider.dart';
import 'package:vagonetas_app/theme/theme_app.dart';

import 'features/auth/presentation/pages/login_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/history/presentation/pages/historial_page.dart';
// import 'features/mapa/presentation/pages/mapa_page.dart';
import 'features/profile/presentation/pages/perfil_page.dart';
import 'features/booking/presentation/pages/booking_trips_page.dart';
import 'features/settings/presentation/pages/settings_page.dart';
import 'features/home/presentation/pages/navigation_page.dart';
import 'features/mapa/presentation/pages/mapa_tracking_page.dart';
import 'features/mapa/presentation/pages/vehicle_detail_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: ProviderInjector.providers,
        child: Builder(builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: 'Vagonetas',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: '/splash',
            onGenerateRoute: (settings) {
              if (settings.name != null &&
                  settings.name!.startsWith('/vehicle/')) {
                final id = settings.name!.split('/').last;
                return MaterialPageRoute(
                  builder: (_) => VehicleDetailPage(vehicleId: id),
                );
              }
              // Rutas estáticas
              switch (settings.name) {
                case '/splash':
                  return MaterialPageRoute(builder: (_) => const SplashPage());
                case '/login':
                  return MaterialPageRoute(builder: (_) => const LoginPage());
                case '/register':
                  return MaterialPageRoute(
                      builder: (_) => const RegisterPage());
                case '/home':
                  return MaterialPageRoute(
                      builder: (_) => const NavigationPage());
                // case '/reservas':
                //   return MaterialPageRoute(builder: (_) => const ReservasPage());
                case '/historial':
                  return MaterialPageRoute(
                      builder: (_) => const HistorialPage());
                case '/perfil':
                  return MaterialPageRoute(builder: (_) => const PerfilPage());
                case '/settings':
                  return MaterialPageRoute(
                      builder: (_) => const SettingsPage());
                case '/tracking':
                  return MaterialPageRoute(
                      builder: (_) => const MapaTrackingPage());
                case '/booking-trips':
                  return MaterialPageRoute(
                      builder: (_) => const BookingTripsPage());
              }
              return null;
            },
          );
        }));
  }
}
