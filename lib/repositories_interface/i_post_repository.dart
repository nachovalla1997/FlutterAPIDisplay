import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/models/pure_manufacture/get_post_filter.dart';

/// An interface defining the contract for repositories that handle post-related operations.
abstract class IPostRepository {
  /// Retrieves a paginated list of posts.
  ///
  /// Parameters:
  /// * [page] - The page number to retrieve (starts at 1)
  /// * [limit] - The maximum number of posts to retrieve per page
  ///
  /// Returns a [Future<Result<List<Post>>>] that will complete with either:
  /// * [Success] containing a list of posts if the operation succeeds
  /// * [Failure] containing an error if the operation fails
  Future<Result<List<Post>>> getPosts({
    /// The page number to retrieve
    required int page,

    /// The number of posts to retrieve
    required int limit,
  });

  /// Retrieves a single post based on the provided filter criteria.
  ///
  /// Parameters:
  /// * [filter] - A [GetPostFilter] object containing the criteria
  ///   to find the specific post (e.g., post ID, author, etc.)
  ///
  /// Returns a [Future<Result<Post>>] that will complete with either:
  /// * [Success] containing the requested post if found
  /// * [Failure] containing an error if:
  ///   - The post is not found
  ///   - The operation fails due to network issues
  ///   - Any other error occurs during the operation
  Future<Result<Post>> getPost(GetPostFilter filter);
}
