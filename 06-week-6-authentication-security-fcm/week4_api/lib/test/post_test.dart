import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:week4_api/data/repositories/post_repository.dart';
import 'package:week4_api/data/providers.dart';
import 'package:week4_api/data/network_errors.dart';

class FakePostRepository extends PostRepository {
  FakePostRepository({this.items, this.throwError = false}) : super(Dio());
  final List<Post>? items;
  final bool throwError;

  @override
  Future<List<Post>> fetchPosts() async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionError,
      );
    }
    return items ?? const [];
  }
}

void main() {
  test('1. fromJson aman terhadap field yang hilang', () {
    final json = <String, dynamic>{};
    final post = Post.fromJson(json);

    expect(post.userId, 0);
    expect(post.id, 0);
    expect(post.title, '');
    expect(post.body, '');
  });

  test('2. friendlyErrorMessage untuk connection error', () {
    final err = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
    final msg = friendlyErrorMessage(err);
    expect(msg.contains('Tidak dapat terhubung ke server'), true);
  });

  test('3. Provider sukses dengan repository palsu', () async {
    final fakeRepo = FakePostRepository(items: [
      const Post(userId: 1, id: 1, title: 'Test', body: 'Body Test')
    ]);

    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    final posts = await container.read(postListProvider.future);
    expect(posts.length, 1);
    expect(posts[0].title, 'Test');
  });

  test('4. Provider error dengan repository palsu', () async {
    final fakeRepo = FakePostRepository(throwError: true);

    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(fakeRepo),
      ],
    );
    addTearDown(container.dispose);

    expect(
      () => container.read(postListProvider.future),
      throwsA(isA<DioException>()),
    );
  });
}