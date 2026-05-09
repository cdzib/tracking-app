import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._();

  // ─── Formatters ───────────────────────────────────────────────────────────

  /// Hoy, 3:45 PM · Ayer, 10:00 AM · Mañana, 8:00 AM
  /// Lunes, 3:45 PM        (si está dentro de los próximos 7 días)
  /// 12 Mar 2025, 3:45 PM  (cualquier otra fecha)
  static String formatRelative(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return formatRelativeFromDate(dateTime);
  }

  /// Igual que [formatRelative] pero recibe un [DateTime] directamente.
  /// Hoy, 3:45 PM · Ayer, 10:00 AM · Lunes, 3:45 PM · 12 Mar 2025, 3:45 PM
  static String formatRelativeFromDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final diff = target.difference(today).inDays;
    final time = DateFormat('h:mm a').format(dateTime);

    return switch (diff) {
      0 => 'Hoy, $time',
      1 => 'Mañana, $time',
      -1 => 'Ayer, $time',
      _ when diff > 1 && diff <= 7 =>
        '${_weekdayName(dateTime.weekday)}, $time',
      _ => DateFormat('dd MMM yyyy, h:mm a').format(dateTime),
    };
  }
  /// 12 Mar 2025
  static String formatDateRelative(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  /// 12 Mar 2025, 3:45 PM
  static String formatFull(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return DateFormat('dd MMM yyyy, h:mm a').format(dateTime);
  }

  /// 12/03/2025
  static String formatShortDate(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  /// 3:45 PM
  static String formatTime(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return DateFormat('h:mm a').format(dateTime);
  }

  /// 12 de marzo de 2025
  static String formatLongDate(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';
    return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(dateTime);
  }

  // ─── Relative helpers ─────────────────────────────────────────────────────

  /// hace 5 segundos · hace 3 minutos · hace 2 horas · hace 4 días
  /// en 10 minutos  · en 1 hora       · en 3 días    (fechas futuras)
  static String timeAgo(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return dateTimeStr ?? '';

    final diff = DateTime.now().difference(dateTime);
    final absDiff = diff.abs();

    final (value, unit) = switch (absDiff) {
      _ when absDiff.inSeconds < 60 => (absDiff.inSeconds, 'segundo'),
      _ when absDiff.inMinutes < 60 => (absDiff.inMinutes, 'minuto'),
      _ when absDiff.inHours < 24 => (absDiff.inHours, 'hora'),
      _ when absDiff.inDays < 30 => (absDiff.inDays, 'día'),
      _ when absDiff.inDays < 365 => (absDiff.inDays ~/ 30, 'mes'),
      _ => (absDiff.inDays ~/ 365, 'año'),
    };

    final plural = value != 1 ? _pluralize(unit) : unit;
    return diff.isNegative ? 'en $value $plural' : 'hace $value $plural';
  }

  // ─── Checks ───────────────────────────────────────────────────────────────

  /// true si la fecha corresponde al día de hoy
  static bool isToday(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return false;
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// true si la fecha corresponde a ayer
  static bool isYesterday(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return false;
    return isToday(dateTime.add(const Duration(days: 1)).toIso8601String());
  }

  /// true si la fecha corresponde a mañana
  static bool isTomorrow(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return false;
    return isToday(
        dateTime.subtract(const Duration(days: 1)).toIso8601String());
  }

  /// true si ambas fechas caen en el mismo día (ignora la hora)
  static bool isSameDay(String? aStr, String? bStr) {
    final a = tryParse(aStr);
    final b = tryParse(bStr);
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// true si la fecha ya pasó respecto a ahora
  static bool isPast(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return false;
    return dateTime.isBefore(DateTime.now());
  }

  /// true si la fecha aún no ha llegado respecto a ahora
  static bool isFuture(String? dateTimeStr) {
    final dateTime = tryParse(dateTimeStr);
    if (dateTime == null) return false;
    return dateTime.isAfter(DateTime.now());
  }

  // ─── Parsing ──────────────────────────────────────────────────────────────

  /// Parsea un String ISO 8601 a DateTime local. Devuelve null si falla.
  /// '2025-03-12T15:45:00Z' → DateTime(2025, 3, 12, 9, 45) (UTC-6)
  static DateTime? tryParse(String? value) {
    if (value == null || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toLocal();
  }

  // ─── Private helpers ──────────────────────────────────────────────────────

  static String _weekdayName(int weekday) => switch (weekday) {
        1 => 'Lunes',
        2 => 'Martes',
        3 => 'Miércoles',
        4 => 'Jueves',
        5 => 'Viernes',
        6 => 'Sábado',
        _ => 'Domingo',
      };

  static String _pluralize(String unit) => switch (unit) {
        'mes' => 'meses',
        _ => '${unit}s',
      };
}
