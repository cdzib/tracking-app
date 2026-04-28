import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:vagonetas_app/core/config/api_config.dart';

enum SocketStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

class ReverbSocketService {
  WebSocket? socket;

  final _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  final _statusController =
      StreamController<SocketStatus>.broadcast();

  Stream<Map<String, dynamic>> get stream =>
      _controller.stream;

  Stream<SocketStatus> get statusStream =>
      _statusController.stream;

  SocketStatus _status = SocketStatus.disconnected;

  Timer? _reconnectTimer;

  String? _lastChannel;

  //--------------------------------------

  Future<bool> connect() async {
    if (_status == SocketStatus.connected ||
        _status == SocketStatus.connecting) {
      return true;
    }

    _setStatus(SocketStatus.connecting);

    try {
      final url =
          '${ApiConfig.wsBaseUrl}/app/xscamr41r2pxrs5zqtv0'
          '?protocol=7&client=flutter&version=1.0.0';

      print("Conectando a: $url");

      socket = await WebSocket.connect(url);

      print("✅ Conectado al WebSocket");

      _setStatus(SocketStatus.connected);

      socket!.listen(
        (message) {
          final data = jsonDecode(message);
          _controller.add(data);
        },

        onDone: () {
          print("❌ Conexión cerrada");
          _handleDisconnect();
        },

        onError: (error) {
          print("🔥 Error: $error");
          _setStatus(SocketStatus.error);
          _handleDisconnect();
        },
      );

      // Re-suscribir canal si existía
      if (_lastChannel != null) {
        subscribe(_lastChannel!);
      }

      return true;

    } catch (e) {
      print("❌ Error al conectar: $e");

      _setStatus(SocketStatus.error);

      _scheduleReconnect();

      return false;
    }
  }

  //--------------------------------------

  void subscribe(String channelName) {
    _lastChannel = channelName;

    if (socket == null ||
        _status != SocketStatus.connected) {
      print("⚠️ No conectado aún");
      return;
    }

    final message = {
      "event": "pusher:subscribe",
      "data": {
        "channel": channelName
      }
    };

    socket!.add(jsonEncode(message));

    print("📡 Suscrito a: $channelName");
  }

  //--------------------------------------

  void _handleDisconnect() {
    _setStatus(SocketStatus.disconnected);

    socket = null;

    _scheduleReconnect();
  }

  //--------------------------------------

  void _scheduleReconnect() {
    if (_reconnectTimer != null) return;

    print("🔄 Intentando reconectar en 5 segundos...");

    _setStatus(SocketStatus.reconnecting);

    _reconnectTimer =
        Timer(const Duration(seconds: 5), () async {
      _reconnectTimer = null;

      await connect();
    });
  }

  //--------------------------------------

  void _setStatus(SocketStatus status) {
    _status = status;

    _statusController.add(status);

    print("📡 Estado socket: $status");
  }

  //--------------------------------------

  void close() {
    _reconnectTimer?.cancel();

    socket?.close(1000, 'Cierre manual');

    _setStatus(SocketStatus.disconnected);
  }
}