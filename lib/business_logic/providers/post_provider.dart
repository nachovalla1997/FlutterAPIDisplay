import 'package:flutter/material.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:flutter_api_display/utilities/configuration.dart';

/// A ChangeNotifier that manages the state and business logic for posts.
///
/// This provider acts as a ViewModel in the MVVM architecture, mediating between
/// the UI layer and the post repository. It handles:
/// * Fetching posts from the repository
/// * Managing the loading state
/// * Error handling
/// * Notifying listeners of state changes
class PostProvider extends ChangeNotifier {
  /// The repository responsible for post-related data operations
  final IPostRepository _postRepository;

  /// Stores the current state
  PostState _state = PostState.initial();
  PostState get state => _state;

  /// Creates a [PostProvider] with the required repository dependency.
  ///
  /// Parameters:
  /// * [postRepository] - An implementation of [IPostRepository] that will be used
  ///   to fetch and manage post data.
  PostProvider({
    required IPostRepository postRepository,
  }) : _postRepository = postRepository;

  /// Fetches posts from the repository and updates the state.
  Future<void> fetchPosts() async {
    if (_state.isLoading || !_state.hasMore) return;

    _setState(_state.copyWith(isLoading: true, error: null));

    final result = await _postRepository.getPosts(
      limit: Configuration.kPostsPerPage,
      page: _state.page,
    );

    if (result.isSuccess()) {
      final posts = result.tryGetSuccess();

      if (posts != null) {
        _setState(_state.copyWith(
          posts: [..._state.posts, ...posts],
          isLoading: false,
          hasMore: true,
          page: _state.page + 1,
        ));
      }
    }

    // TODO: Handle error state
  }

  /// Internal method to update state and notify UI
  void _setState(PostState newState) {
    _state = newState;
    notifyListeners();
  }
}
