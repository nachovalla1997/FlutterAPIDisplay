import 'package:flutter/material.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';

/// A ChangeNotifier that manages the state and business logic for posts.
///
/// This provider acts as a ViewModel in the MVVM architecture, mediating between
/// the UI layer and the post repository. It handles:
/// * Fetching posts from the repository
/// * Managing the loading state
/// * Error handling
/// * Notifying listeners of state changes
///
/// Example usage:
/// ```dart
/// final postProvider = context.read<PostProvider>();
/// await postProvider.fetchPosts();
/// ```
class PostProvider extends ChangeNotifier {
  /// The repository responsible for post-related data operations
  final IPostRepository _postRepository;

  /// Creates a [PostProvider] with the required repository dependency.
  ///
  /// Parameters:
  /// * [postRepository] - An implementation of [IPostRepository] that will be used
  ///   to fetch and manage post data.
  PostProvider({
    required IPostRepository postRepository,
  }) : _postRepository = postRepository;
}
