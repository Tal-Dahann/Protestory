import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/firebase/attender.dart';
import 'package:protestory/widgets/protest_card.dart';
import 'package:provider/provider.dart';

import '../providers/data_provider.dart';

class PaginatorFavorites extends StatelessWidget {
  final Widget? header;
  final Widget onEmpty;
  final QueryChangeListener<Attender> queryProvider;

  const PaginatorFavorites(
      {required this.queryProvider,
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
        final data = documentSnapshots[index].data() as Attender;

        return FutureBuilder(
            future: context
                .read<DataProvider>()
                .getProtestById(protestId: data.protestID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProtestCard(
                  protest: snapshot.requireData,
                  type: ProtestCardTypes.wholeScreen,
                );
              }
              return const ListTile();
            });
      },
    );
  }
}
