import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/widgets/paginator_stories.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';
import '../providers/data_provider.dart';

class ProtestUpdates extends StatefulWidget {
  final Protest protest;
  final DataProvider dataProvider;
  final bool isCreator;

  const ProtestUpdates(
      {required this.protest,
      required this.dataProvider,
      Key? key,
      required this.isCreator})
      : super(key: key);

  @override
  State<ProtestUpdates> createState() => _ProtestUpdatesState();
}

class _ProtestUpdatesState extends State<ProtestUpdates> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            child: PaginatorStories(
              isCreator: widget.isCreator,
              protestID: widget.protest.id,
              queryProvider: QueryChangeListener(context
                  .read<DataProvider>()
                  .queryStoriesOfProtest(protestId: widget.protest.id)),
              onEmpty: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'No Updates yet',
                    style: TextStyle(color: darkGray),
                  ),
                ),
              ),
              dataProvider: widget.dataProvider,
            ),
          )
        ],
      ),
    );
  }
}
