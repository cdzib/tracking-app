import 'dart:developer' as developer;
import 'package:logger/logger.dart';

class SimpleLogPrinter extends LogPrinter {
  static int counter = 0;
  final String className;

  SimpleLogPrinter(this.className);
  
  @override
  List<String> log(LogEvent event) {
    final message = event.message.toString();

    developer.log(
      message,
      time: DateTime.now(),
      level: _mapLevelToInt(event.level),
      name: className,
      error: event.error,
      sequenceNumber: counter += 1,
    );

    // Retornamos la lista con el mensaje, o vacía si no quieres salida en consola
    return [message];
  }

  int _mapLevelToInt(Level level) {
    switch (level) {
      case Level.verbose:
        return 0;
      case Level.debug:
        return 500;
      case Level.info:
        return 0;
      case Level.warning:
        return 1500;
      case Level.error:
        return 2000;
      case Level.wtf:
        return 2000;
      default:
        return 2000;
    }
  }
}

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}
