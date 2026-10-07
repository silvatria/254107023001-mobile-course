import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/post.dart';
import '../data/repositories/post_repository.dart';
import '../data/sync.dart';
import 'offline_providers.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(),
);

final postRefreshErrorProvider =
    NotifierProvider<PostRefreshErrorNotifier, String?>(
      PostRefreshErrorNotifier.new,
    );

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(
  PostsNotifier.new,
);

class PostRefreshErrorNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void record(Object error) => state = error.toString();

  void clear() => state = null;
}

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final repo = ref.watch(postRepositoryProvider);
    final offline = ref.watch(forceOfflineProvider);

    // 1. Selalu baca cache lokal terlebih dahulu.
    final cached = await repo.readCachedPosts();

    if (offline) {
      if (cached.isEmpty) {
        throw const OfflineException(
          'Offline dan belum ada cache. Buka halaman ini sekali saat online.',
        );
      }
      return cached;
    }

    // 2. Belum ada cache: terpaksa menunggu jaringan.
    if (cached.isEmpty) return repo.fetchAndCache();

    // 3. Ada cache: tampilkan segera, refresh di background.
    unawaited(_refreshInBackground(repo));
    return cached;
  }

  Future<void> _refreshInBackground(PostRepository repo) async {
    try {
      final fresh = await repo.fetchAndCache();
      state = AsyncData(fresh);
      ref.read(postRefreshErrorProvider.notifier).clear();
    } catch (error) {
      ref.read(postRefreshErrorProvider.notifier).record(error);
    }
  }

  /// Dipanggil oleh pull-to-refresh. Mengembalikan true bila berhasil.
  Future<bool> refresh() async {
    if (ref.read(forceOfflineProvider)) return false;
    try {
      final fresh = await ref.read(postRepositoryProvider).fetchAndCache();
      state = AsyncData(fresh);
      ref.read(postRefreshErrorProvider.notifier).clear();
      return true;
    } catch (error) {
      ref.read(postRefreshErrorProvider.notifier).record(error);
      rethrow;
    }
  }
}
