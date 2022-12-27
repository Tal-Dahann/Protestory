import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../firebase/story.dart';

class PaginatorStories extends StatelessWidget {
  final Widget? header;
  final Widget onEmpty;
  final String protestID;
  final QueryChangeListener<Story> queryProvider;

  const PaginatorStories(
      {required this.queryProvider,
      required this.protestID,
      Key? key,
      required this.header,
      required this.onEmpty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      header: header,
      onEmpty: onEmpty,
      queryProvider: queryProvider,
      isLive: true,
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Story;
        print("paginator stories build item ${index}");
        return ListTile(
          title: Text("story of : ${data.userID}, content: ${data.content}"),
        );

        // return FutureBuilder(
        //     future: context
        //         .read<DataProvider>()
        //         .queryStoriesOfProtest(protestId: protestID),
        //     builder: (context, snapshot) {
        //       if (snapshot.hasData) {
        //         return Text(
        //             "story of : ${data.userID}, content: ${data.content}");
        //       }
        //       return const ListTile();
        //     });
      },
    );
  }
}
