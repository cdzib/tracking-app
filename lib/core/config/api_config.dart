import 'dart:developer';

class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.77:8080',
  );

  static const String wsBaseUrl = String.fromEnvironment(
    'WS_BASE_URL',
    defaultValue: 'ws://192.168.1.77:8082',
  );

  static void logConfig() {
    log('API baseUrl: ' + baseUrl);
    log('WS baseUrl: ' + wsBaseUrl);
  }
}
