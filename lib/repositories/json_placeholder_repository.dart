import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';
import 'package:flutter_api_display/remote_config/remote_config.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';

class JsonPlaceholderRepository implements IPostRepository {
  final RemoteConfig _remoteConfig;

  const JsonPlaceholderRepository({
    required RemoteConfig remoteConfig,
  }) : _remoteConfig = remoteConfig;

  @override
  Future<Result<Post>> getPost(GetPostFilter filter) {
    // TODO: implement getPost
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Post>>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
