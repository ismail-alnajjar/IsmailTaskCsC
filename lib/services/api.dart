import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  /// 🔹 رابط السيرفر الأساسي (.NET backend)
  final String baseUrl = "http://10.180.177.246:7295/api/";

  Future<dynamic> get({required String endpoint, String? token}) async {
    final url = "$baseUrl$endpoint";
    final headers = <String, String>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      print("🌍 GET: $url");
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 15));

      print("✅ Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          '❌ GET ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ GET Error: $e');
    }
  }

  Future<dynamic> post({
    required String endpoint,
    required dynamic body,
    String? token,
  }) async {
    final url = "$baseUrl$endpoint";
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      print("📤 POST: $url");
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      print("✅ Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          '❌ POST ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ POST Error: $e');
    }
  }

  Future<dynamic> put({
    required String endpoint,
    required dynamic body,
    String? token,
  }) async {
    final url = "$baseUrl$endpoint";
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      print("✏️ PUT: $url");
      final response = await http
          .put(Uri.parse(url), headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));

      print("✅ Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {"message": "Updated successfully"};
      } else {
        throw Exception(
          '❌ PUT ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ PUT Error: $e');
    }
  }

  Future<bool> delete({required String endpoint, String? token}) async {
    final url = "$baseUrl$endpoint";
    final headers = <String, String>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';

    try {
      print("🗑 DELETE: $url");
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 15));

      print("✅ Response [${response.statusCode}]");

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception(
          '❌ DELETE ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      throw Exception('⚠️ DELETE Error: $e');
    }
  }
}
