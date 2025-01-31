import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/repositories/dataprovider/json_placeholder_api_provider.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:http/http.dart' as http;

/// Repository implementation for interacting with the JSONPlaceholder API.
class JsonPlaceholderRepository implements IPostRepository {
  final JsonPlaceholderApiProvider _apiProvider;

  JsonPlaceholderRepository({
    required RemoteConfig remoteConfig,
    http.Client? client,
  }) : _apiProvider = JsonPlaceholderApiProvider(
          remoteConfig: remoteConfig,
          client: client,
        );

  @override
  Future<Result<Post>> getPost(GetPostFilter filter) async {
    try {
      final data = await _apiProvider.getPost(filter.id);
      return Result.success(_mapToPost(data));
    } catch (e) {
      return Result.error(e as BaseException);
    }
  }

  @override
  Future<Result<List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final start = (page - 1) * limit;
      final data = await _apiProvider.getPosts(start: start, limit: limit);
      return Result.success(data.map(_mapToPost).toList());
    } catch (e) {
      return Result.error(e as BaseException);
    }
  }

  Post _mapToPost(Map<String, dynamic> data) {
    return Post(
      id: data['id'].toString(),
      title: data['title'],
      body: data['body'],
    );
  }

  void dispose() {
    _apiProvider.dispose();
  }
}
