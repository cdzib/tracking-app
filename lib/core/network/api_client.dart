import 'dart:convert';
import 'dart:io';

import '../auth/auth_session.dart';
import '../config/api_config.dart';
import 'api_exception.dart';

class ApiClient {
  ApiClient(this._session);

  final AuthSession _session;

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    bool requiresAuth = false,
  }) {
    return _send(
      'GET',
      path,
      queryParameters: queryParameters,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) {
    return _send(
      'POST',
      path,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> patch(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) {
    return _send(
      'PATCH',
      path,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) {
    return _send(
      'DELETE',
      path,
      body: body,
      requiresAuth: requiresAuth,
    );
  }

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, String>? queryParameters,
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(
        queryParameters: queryParameters,
      );
      final request = await client.openUrl(method, uri);
      request.headers.contentType = ContentType.json;
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      if (requiresAuth) {
        final token = _session.token;
        if (token == null || token.isEmpty) {
          throw ApiException('No hay una sesión activa.');
        }
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      }

      if (body != null) {
        request.write(jsonEncode(body));
      }

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = responseBody.isEmpty ? null : jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }

      throw ApiException(
        _extractErrorMessage(decoded) ?? 'Ocurrió un error inesperado.',
        statusCode: response.statusCode,
      );
    } on SocketException {
      throw ApiException(
        'No se pudo conectar con el servidor. Revisa la URL base y tu red.',
      );
    } on HandshakeException {
      throw ApiException('No se pudo establecer una conexión segura con el servidor.');
    } finally {
      client.close(force: true);
    }
  }

  String? _extractErrorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final message = decoded['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      final errors = decoded['errors'];
      if (errors is Map<String, dynamic>) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
        }
      }
    }
    return null;
  }
}
