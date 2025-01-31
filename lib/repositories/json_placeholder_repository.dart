import 'dart:convert';

import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:http/http.dart' as http;

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
        Uri.parse('$_baseUrl/posts/${filter.id}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Result.success(
          Post(
            id: data['id'].toString(),
            title: data['title'],
            body: data['body'],
          ),
        );
      } else {
        return Result.error(
          BaseException(
            'Failed to fetch post. Status code: ${response.statusCode}',
            response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Result.error(
        BaseException('Error fetching post: ${e.toString()}', 500),
      );
    }
  }

  @override
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      // Calculate start and end indices for pagination
      final start = (page - 1) * limit;

      final response = await _client.get(
        Uri.parse('$_baseUrl/posts?_start=$start&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final posts = data
            .map((post) => Post(
                  id: post['id'].toString(),
                  title: post['title'],
                  body: post['body'],
                ))
            .toList();

        return Result.success(posts);
      } else {
        return Result.error(
          BaseException(
            'Failed to fetch posts. Status code: ${response.statusCode}',
            response.statusCode,
          ),
        );
      }
    } catch (e) {
      return Result.error(
        BaseException(
          'Error fetching posts: ${e.toString()}',
          500,
        ),
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
