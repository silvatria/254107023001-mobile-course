import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/post.dart';
import '../data/repositories/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) => PostRepository());

final postsProvider = FutureProvider.autoDispose<List<Post>>((ref) async {
  final repository = ref.watch(postRepositoryProvider);
  return repository.fetchPosts();
});
