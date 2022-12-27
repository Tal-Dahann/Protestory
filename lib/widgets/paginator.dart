import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/widgets/protest_card.dart';

import '../firebase/protest.dart';

class Paginator extends StatelessWidget {
  final Widget? header;
  final Widget onEmpty;
  final QueryChangeListener<Protest> queryProvider;
  final ScrollController? scrollController;

  const Paginator(
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
        final data = documentSnapshots[index].data() as Protest;

        return ProtestCard(
          protest: data,
          type: ProtestCardTypes.wholeScreen,
        );
      },
    );
  }
}
