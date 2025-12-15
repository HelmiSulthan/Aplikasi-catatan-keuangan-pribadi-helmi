import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // PENTING: TANPA slash di akhir
  static const String baseUrl = 'http://10.68.194.86/keuangan/api';

  static Uri _uri(String endpoint) {
    // pastikan endpoint TIDAK diawali slash
    endpoint = endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;
    return Uri.parse('$baseUrl/$endpoint/');
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final uri = _uri(endpoint);
    print('➡️ GET $uri');

    final res = await http.get(uri);

    print('⬅️ STATUS: ${res.statusCode}');
    print('⬅️ BODY: ${res.body}');

    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = _uri(endpoint);
    print('➡️ POST $uri');
    print('➡️ PAYLOAD: ${jsonEncode(body)}');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('⬅️ STATUS: ${res.statusCode}');
    print('⬅️ BODY: ${res.body}');

    return _handleResponse(res);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = _uri(endpoint);
    print('➡️ DELETE $uri');

    final res = await http.delete(uri);

    print('⬅️ STATUS: ${res.statusCode}');
    print('⬅️ BODY: ${res.body}');

    return _handleResponse(res);
  }

  static Map<String, dynamic> _handleResponse(http.Response res) {
    try {
      final json = jsonDecode(res.body);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return json;
      } else {
        throw Exception(json['message'] ?? 'API Error');
      }
    } catch (_) {
      throw Exception('Invalid response from server');
    }
  }
}
