class PagedPostsState {
 const PagedPostsState({
 this.items = const [],
 this.page = 0,
 this.isLoadingMore = false,
 this.hasMore = true,
 this.error,
 });
 final List<Post> items;
 final int page;
 final bool isLoadingMore;
 final bool hasMore;
 final Object? error;

 
}

