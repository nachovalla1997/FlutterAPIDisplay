import 'dart:convert';

import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories/api_endpoints.dart';
import 'package:flutter_api_display/repositories/api_errors.dart';
import 'package:flutter_api_display/repositories/api_status_code.dart';
import 'package:http/http.dart' as http;

/// Provider class responsible for making HTTP requests to the JSONPlaceholder API.
class JsonPlaceholderApiProvider {
  final RemoteConfig _remoteConfig;
  final http.Client _client;

  JsonPlaceholderApiProvider({
    required RemoteConfig remoteConfig,
    http.Client? client,
  })  : _remoteConfig = remoteConfig,
        _client = client ?? http.Client();

  String get _baseUrl => _remoteConfig.getString(RemoteConfig.apiBaseUrl);

  /// Fetches a single post by ID from the API.
  Future<Map<String, dynamic>> getPost(String id) async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl + ApiEndpoints.getPostDetails(id)),
      );

      if (response.statusCode == ApiStatusCode.success) {
        return json.decode(response.body);
      }

      throw BaseException(
        ApiErrors.fetchPostFailed(response.statusCode),
        response.statusCode,
      );
    } catch (e) {
      if (e is BaseException) rethrow;
      throw BaseException(
        ApiErrors.fetchPostError(e.toString()),
        ApiStatusCode.internalError,
      );
    }
  }

  /// Fetches a paginated list of posts from the API.
  Future<List<Map<String, dynamic>>> getPosts({
    required int start,
    required int limit,
  }) async {
    try {
      final response = await _client.get(
        Uri.parse(_baseUrl + ApiEndpoints.getPostsList(start, limit)),
      );

      if (response.statusCode == ApiStatusCode.success) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      }

      throw BaseException(
        ApiErrors.fetchPostsFailed(response.statusCode),
        response.statusCode,
      );
    } catch (e) {
      if (e is BaseException) rethrow;
      throw BaseException(
        ApiErrors.fetchPostsError(e.toString()),
        ApiStatusCode.internalError,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
