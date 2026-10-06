import 'package:dio/dio.dart';

import '../remote/post.dart';

class PostRepository {
  PostRepository({Dio? dio}) : _dio = dio ?? Dio(BaseOptions()) {
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  final Dio _dio;

  Future<List<Post>> fetchPosts() async {
    final response = await _dio.get<List>('https://jsonplaceholder.typicode.com/posts');
    final data = response.data ?? const <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Post.fromJson)
        .toList();
  }

  Future<List<Post>> fetchPostsPage({
    required int page,
    int limit = 10,
  }) async {
    final response = await _dio.get<List>(
      'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {
        '_page': page,
        '_limit': limit,
      },
    );
    final data = response.data ?? const <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Post.fromJson)
        .toList();
  }
}
