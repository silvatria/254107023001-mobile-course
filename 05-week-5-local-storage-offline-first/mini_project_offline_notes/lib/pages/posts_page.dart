import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/offline_providers.dart';
import '../providers/post_providers.dart';

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final offline = ref.watch(forceOfflineProvider);
    final refreshError = ref.watch(postRefreshErrorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Posts (cache-first)')),
      body: Column(
        children: [
          if (offline)
            Container(
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.all(12),
              child: const Text(
                'Mode offline: menampilkan data dari cache lokal',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          if (refreshError != null)
            MaterialBanner(
              content: Text(
                'Refresh gagal; cache lokal tetap digunakan: $refreshError',
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      ref.read(postRefreshErrorProvider.notifier).clear(),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          Expanded(
            child: postsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('$e', textAlign: TextAlign.center),
                ),
              ),
              data: (posts) => RefreshIndicator(
                onRefresh: () async {
                  try {
                    final refreshed = await ref
                        .read(postsProvider.notifier)
                        .refresh();
                    if (!refreshed && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Mode offline aktif; cache lokal tetap digunakan',
                          ),
                        ),
                      );
                    }
                  } catch (error) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Refresh gagal; cache lokal tetap digunakan: $error',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text(post.id.toString())),
                      title: Text(post.title, maxLines: 1),
                      subtitle: Text(post.body, maxLines: 2),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
