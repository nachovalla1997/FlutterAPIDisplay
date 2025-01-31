import 'package:flutter_api_display/business_logic/providers/post_provider.dart';
import 'package:flutter_api_display/business_logic/providers/post_state.dart';
import 'package:flutter_api_display/core/base_exception.dart';
import 'package:flutter_api_display/core/result.dart';
import 'package:flutter_api_display/models/post_model.dart';
import 'package:flutter_api_display/repositories_interface/i_post_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/post_repository.mocks.dart';

@GenerateMocks([IPostRepository])
void main() {
  late PostProvider provider;
  late MockIPostRepository mockRepository;

  setUpAll(() {
    // Provide dummy values for Result types
    provideDummy<Result<List<Post>>>(
      Result.success([]),
    );
    provideDummy<Result<Post>>(
      Result.success(Post(id: '1', title: 'Dummy')),
    );
  });

  setUp(() {
    mockRepository = MockIPostRepository();
    provider = PostProvider(postRepository: mockRepository);
  });

  group('PostProvider Tests', () {
    test('Initial state is PostState.initial()', () {
      expect(provider.state, PostState.initial());
    });

    test('fetchPosts() - success case', () async {
      final mockPosts = [
        Post(id: '1', title: 'Post 1'),
        Post(id: '2', title: 'Post 2'),
      ];

      when(mockRepository.getPosts(page: 1, limit: anyNamed('limit')))
          .thenAnswer((_) async => Result.success(mockPosts));

      await provider.fetchPosts();

      expect(provider.state.posts, mockPosts);
      expect(provider.state.isLoading, false);
      expect(provider.state.hasMore, true);
    });

    test('fetchPosts() - failure case', () async {
      final error = BaseException('Network error', 500);

      when(mockRepository.getPosts(page: 1, limit: anyNamed('limit')))
          .thenAnswer((_) async => Result.error(error));

      await provider.fetchPosts();

      expect(provider.state.error, error);
      expect(provider.state.isLoading, false);
    });

    test('searchPosts() filters posts correctly', () async {
      final mockPosts = [
        Post(id: '1', title: 'Flutter Tutorial'),
        Post(id: '2', title: 'Dart Basics'),
      ];

      // Setup mock repository response
      when(mockRepository.getPosts(page: 1, limit: anyNamed('limit')))
          .thenAnswer((_) async => Result.success(mockPosts));

      // Fetch posts first to populate the state
      await provider.fetchPosts();

      // Perform search
      provider.searchPosts('Flutter');

      expect(provider.state.posts.length, 1);
      expect(provider.state.posts.first.title, 'Flutter Tutorial');
    });

    test('fetchPostById() - success', () async {
      final post = Post(id: '1', title: 'Post 1');

      when(mockRepository.getPost(any))
          .thenAnswer((_) async => Result.success(post));

      await provider.fetchPostById('1');

      expect(provider.state.selectedPost, post);
      expect(provider.state.isPostLoading, false);
    });

    test('fetchPostById() - failure', () async {
      final error = BaseException('Not Found', 404);

      when(mockRepository.getPost(any))
          .thenAnswer((_) async => Result.error(error));

      await provider.fetchPostById('1');

      expect(provider.state.selectedPost, null);
      expect(provider.state.isPostLoading, false);
      expect(provider.state.error, error);
    });
  });
}
