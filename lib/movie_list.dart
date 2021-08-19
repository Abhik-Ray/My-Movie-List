// import 'package:flutter/material.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//
// class MovieListView extends StatefulWidget {
//   @override
//   _MovieListViewState createState() => _MovieListViewState();
// }
//
// class _MovieListViewState extends State<MovieListView> {
//   static const _pageSize = 20;
//
//   final PagingController<int, String> _pagingController =
//   PagingController(firstPageKey: 0);
//
//   @override
//   void initState() {
//     _pagingController.addPageRequestListener((pageKey) {
//       _fetchPage(pageKey);
//     });
//     super.initState();
//   }
//
//   Future<void> _fetchPage(int pageKey) async {
//     try {
//       final newItems = ['Hello', 'Hi', 'Im', 'The', '2019', 'Guy'];
//       final isLastPage = newItems.length < _pageSize;
//       if (isLastPage) {
//         _pagingController.appendLastPage(newItems);
//       } else {
//         final nextPageKey = pageKey + newItems.length;
//         _pagingController.appendPage(newItems, nextPageKey);
//       }
//     } catch (error) {
//       _pagingController.error = error;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) =>
//       PagedListView<int, String>(
//         pagingController: _pagingController,
//         builderDelegate: PagedChildBuilderDelegate<String>(
//           itemBuilder: (context, item, index) => CharacterListItem(
//             character: item,
//           ),
//         ),
//       );
//
//   @override
//   void dispose() {
//     _pagingController.dispose();
//     super.dispose();
//   }
// }