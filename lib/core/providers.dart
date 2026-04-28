import 'package:vagonetas_app/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:vagonetas_app/features/booking/presentation/viewmodel/booking_seats_viewmodel.dart';
import 'package:vagonetas_app/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:vagonetas_app/features/history/presentation/viewmodel/historial_viewmodel.dart';
import 'package:vagonetas_app/features/home/presentation/viewmodel/home_viewmodel.dart';
import 'package:vagonetas_app/features/mapa/presentation/viewmodel/mapa_tracking_viewmodel.dart';

import '../core/locator.dart';
import '../core/services/navigator_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../core/theme/theme_provider.dart';

class ProviderInjector {
  static List<SingleChildWidget> providers = [
    ..._independentServices,
    ..._dependentServices,
    ..._consumableServices,
  ];

  static final List<SingleChildWidget> _independentServices = [
    Provider.value(value: locator<NavigatorService>()),
    ChangeNotifierProvider(create: (_) => locator<AuthViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<BookingViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<BookingSeatsViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<HistorialViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<MapaTrackingViewModel>()),
    ChangeNotifierProvider(create: (_) => locator<HomeViewModel>()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ];

  static final List<SingleChildWidget> _dependentServices = [];
  
  static final List<SingleChildWidget> _consumableServices = [];
}