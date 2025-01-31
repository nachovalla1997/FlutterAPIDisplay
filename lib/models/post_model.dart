/// A class that represents a post.
class Post {
  /// The id of the post.
  final String id;

  /// The title of the post.
  final String title;

  /// The body of the post.
  String? body;

  /// Creates a [Post] with the given [id] and [title].
  Post({
    required this.id,
    required this.title,
    this.body,
  });
}
