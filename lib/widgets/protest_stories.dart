import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/widgets/paginator_stories.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';
import '../providers/data_provider.dart';

class ProtestStories extends StatefulWidget {
  final Protest protest;
  final DataProvider dataProvider;
  const ProtestStories({required this.protest, required this.dataProvider, Key? key})
      : super(key: key);

  @override
  State<ProtestStories> createState() => _ProtestStoriesState();
}

class _ProtestStoriesState extends State<ProtestStories> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Flexible(
            child: PaginatorStories(
              protestID: widget.protest.id,
              queryProvider: QueryChangeListener(context
                  .read<DataProvider>()
                  .queryStoriesOfProtest(protestId: widget.protest.id)),
              onEmpty: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'No Stories yet',
                    style: TextStyle(color: darkGray),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
