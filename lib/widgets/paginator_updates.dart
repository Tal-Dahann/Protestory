import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/update.dart';

class PaginatorUpdates extends StatelessWidget {
  final Widget onEmpty;
  final String protestID;
  final QueryChangeListener<Update> queryProvider;
  final ScrollController? scrollController;

  const PaginatorUpdates(
      {required this.queryProvider,
      Key? key,
      required this.protestID,
      required this.onEmpty,
      this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      onEmpty: onEmpty,
      queryProvider: queryProvider,
      isLive: true,
      scrollController: scrollController,
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Update;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        minWidth: double.infinity, minHeight: 100),
                    child: Material(
                      borderRadius: BorderRadius.circular(5),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              data.content,
                              style: const TextStyle(fontSize: 20),
                            ),
                            AutoSizeText(
                              DateFormat('dd/MM/yyyy, kk:mm')
                                  .format(data.creationTime.toDate())
                                  .toString(),
                              style: const TextStyle(
                                  fontSize: 20, color: lightGray),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
