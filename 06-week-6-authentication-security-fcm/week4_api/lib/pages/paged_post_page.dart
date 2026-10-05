// di initState()
_controller.addListener(() {
 if (_controller.position.pixels >=
 _controller.position.maxScrollExtent - 200) {
 ref.read(pagedPostsProvider.notifier).loadNextPage();
 }
});
// di build()
ListView.builder(
 controller: _controller,
 itemCount: state.items.length + 1, // +1 untuk footer
 itemBuilder: (context, index) {
 if (index == state.items.length) {
 return state.hasMore
 ? /* CircularProgressIndicator */
 : /* Text('Semua data termuat.') */;
 }
 final post = state.items[index];
 return ListTile(...);
 },
)
