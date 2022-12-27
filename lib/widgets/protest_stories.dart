import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/widgets/paginator_stories.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';
import '../providers/data_provider.dart';
import '../utils/add_spaces.dart';

class ProtestStories extends StatefulWidget {
  Protest protest;
  DataProvider dataProvider;
  ProtestStories({required this.protest, required this.dataProvider, Key? key})
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
          TextButton(
            onPressed: () {
              widget.dataProvider.addStory(widget.protest, "content");
              print("added story");
              setState(() {});
            },
            child: const Text('addStory'),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: PaginatorStories(
              protestID: widget.protest.id,
              queryProvider: QueryChangeListener(context
                  .read<DataProvider>()
                  .queryStoriesOfProtest(protestId: widget.protest.id)),
              header: SliverAppBar(
                backgroundColor: white,
                toolbarHeight: 5,
                centerTitle: true,
                floating: true,
                title: Column(
                  children: [
                    addVerticalSpace(height: 15),
                  ],
                ),
              ),
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
