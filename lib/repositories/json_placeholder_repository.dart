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
  Future<Result<List<Post>>> getPosts(
      {required int page, required int limit}) async {
    await Future.delayed(const Duration(seconds: 4));

    return Result.success(
      [
        Post(id: "1", title: "Hello"),
        Post(id: "2", title: "World"),
        Post(id: "3", title: "Flutter"),
        Post(id: "4", title: "API"),
        Post(id: "5", title: "Display"),
        Post(id: "6", title: "App"),
        Post(id: "7", title: "JSON"),
        Post(id: "8", title: "Placeholder"),
        Post(id: "9", title: "Repository"),
        Post(id: "10", title: "Provider"),
        Post(id: "11", title: "State"),
        Post(id: "12", title: "Model"),
        Post(id: "13", title: "Filter"),
        Post(id: "14", title: "Remote Config"),
        Post(id: "15", title: "Utilities"),
        Post(id: "16", title: "Logger"),
        Post(id: "17", title: "Initialize"),
        Post(id: "18", title: "Multi"),
        Post(id: "19", title: "Single"),
        Post(id: "20", title: "ChangeNotifier"),
      ],
    );
  }
}
