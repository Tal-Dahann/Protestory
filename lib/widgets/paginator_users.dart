import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../firebase/user.dart';

class PaginatorUsers extends StatelessWidget {
  final Widget? header;
  final Widget onEmpty;
  final QueryChangeListener<PUser> queryProvider;
  final ScrollController? scrollController;

  const PaginatorUsers(
      {required this.queryProvider,
      Key? key,
      required this.header,
      required this.onEmpty,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      header: header,
      onEmpty: onEmpty,
      queryProvider: queryProvider,
      isLive: true,
      scrollController: scrollController,
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as PUser;

        return Text("username: ${data.username}");
      },
    );
  }
}
