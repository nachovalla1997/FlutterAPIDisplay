import 'dart:convert';

import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories/api_endpoints.dart';
import 'package:flutter_api_display/repositories/api_errors.dart';
import 'package:flutter_api_display/repositories/api_status_code.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:http/http.dart' as http;

/// Repository implementation for interacting with the JSONPlaceholder API.
class JsonPlaceholderRepository implements IPostRepository {
  final RemoteConfig _remoteConfig;
  final http.Client _client;

  JsonPlaceholderRepository({
    required RemoteConfig remoteConfig,
    http.Client? client,
  })  : _remoteConfig = remoteConfig,
        _client = client ?? http.Client();

  String get _baseUrl => _remoteConfig.getString(RemoteConfig.apiBaseUrl);

  @override
  Future<Result<Post>> getPost(GetPostFilter filter) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl${ApiEndpoints.getPostDetails(filter.id)}'),
      );

      if (response.statusCode == ApiStatusCode.success) {
        return Result.success(_parsePost(response.body));
      }

      return Result.error(
        BaseException(
          ApiErrors.fetchPostFailed(response.statusCode),
          response.statusCode,
        ),
      );
    } catch (e) {
      return Result.error(
        BaseException(
          ApiErrors.fetchPostError(e.toString()),
          ApiStatusCode.internalError,
        ),
      );
    }
  }

  @override
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final start = (page - 1) * limit;

      final response = await _client.get(
        Uri.parse('$_baseUrl${ApiEndpoints.getPostsList(start, limit)}'),
      );

      if (response.statusCode == ApiStatusCode.success) {
        return Result.success(_parsePosts(response.body));
      }

      return Result.error(
        BaseException(
          ApiErrors.fetchPostsFailed(response.statusCode),
          response.statusCode,
        ),
      );
    } catch (e) {
      return Result.error(
        BaseException(
          ApiErrors.fetchPostsError(e.toString()),
          ApiStatusCode.internalError,
        ),
      );
    }
  }

  Post _parsePost(String responseBody) {
    final Map<String, dynamic> data = json.decode(responseBody);
    return Post(
      id: data['id'].toString(),
      title: data['title'],
      body: data['body'],
    );
  }

  List<Post> _parsePosts(String responseBody) {
    final List<dynamic> data = json.decode(responseBody);
    return data
        .map((post) => Post(
              id: post['id'].toString(),
              title: post['title'],
              body: post['body'],
            ))
        .toList();
  }

  void dispose() {
    _client.close();
  }
}
