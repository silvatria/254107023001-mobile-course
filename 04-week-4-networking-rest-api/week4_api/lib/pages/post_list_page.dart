final postsAsync = ref.watch(postListProvider);
body: postsAsync.when(
 loading: () => const Center(
 child: CircularProgressIndicator()),
 error: (err, _) => /* pesan + Coba lagi */,
 data: (posts) {
 if (posts.isEmpty) {
 return const Center(child:
 Text('Belum ada data dari server.'));
 }
 return RefreshIndicator(
 onRefresh: () => ref
 .read(postListProvider.notifier).refresh(),
 child: ListView.builder(...),
 );
 },
),