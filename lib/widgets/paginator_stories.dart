import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:provider/provider.dart';

import '../firebase/story.dart';
import '../firebase/user.dart';

class PaginatorStories extends StatelessWidget {
  final Widget? header;
  final Widget onEmpty;
  final String protestID;
  final QueryChangeListener<Story> queryProvider;

  const PaginatorStories(
      {required this.queryProvider,
      required this.protestID,
      Key? key,
      this.header,
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: context
                        .read<DataProvider>()
                        .getUserById(userId: data.userID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.requireData.getAvatarWidget(radius: 20);
                      }
                      return PUser.getAvatarLoadingWidget(radius: 20);
                    }),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: double.infinity, minHeight: 50),
                      child: Material(
                        borderRadius: BorderRadius.circular(5),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            data.content,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
