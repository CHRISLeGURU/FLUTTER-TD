import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      final details = errors!.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      return '$message ($details)';
    }
    return message;
  }
}

class ApiService {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Traitement centralisé de la réponse HTTP
  static Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> responseData = {};

    try {
      if (response.body.isNotEmpty) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          responseData = decoded;
        }
      }
    } catch (_) {
      if (response.statusCode >= 400) {
        throw ApiException(
          'Erreur serveur (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData;
    }

    // Gestion des codes d'erreur HTTP (401, 404, 409, 422, 500, etc.)
    final String message = responseData['message'] as String? ??
        'Une erreur est survenue (${response.statusCode})';
    final Map<String, dynamic>? errors =
        responseData['errors'] as Map<String, dynamic>?;

    throw ApiException(
      message,
      statusCode: response.statusCode,
      errors: errors,
    );
  }

  // GET
  static Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');

    try {
      final response = await http.get(url, headers: _defaultHeaders);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de communiquer avec le serveur : $e');
    }
  }

  // POST JSON
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');

    try {
      final response = await http.post(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de communiquer avec le serveur : $e');
    }
  }

  // PUT JSON
  static Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');

    try {
      final response = await http.put(
        url,
        headers: _defaultHeaders,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de communiquer avec le serveur : $e');
    }
  }

  // DELETE
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');

    try {
      final response = await http.delete(url, headers: _defaultHeaders);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de communiquer avec le serveur : $e');
    }
  }

  // Multipart POST (pour l'envoi de formulaire avec image)
  static Future<Map<String, dynamic>> multipartPost(
    String endpoint, {
    required Map<String, String> fields,
    List<int>? fileBytes,
    String? fileName,
    String fileField = 'image',
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/$endpoint');

    try {
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        'Accept': 'application/json',
      });

      request.fields.addAll(fields);

      if (fileBytes != null && fileBytes.isNotEmpty && fileName != null) {
        final multipartFile = http.MultipartFile.fromBytes(
          fileField,
          fileBytes,
          filename: fileName,
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Impossible de communiquer avec le serveur : $e');
    }
  }
}
