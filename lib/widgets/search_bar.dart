import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:provider/provider.dart';

import '../firebase/protest.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
//item builder type is compulsory.
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Protest;
        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: data == null ? const Text('Error in data') : Text(data.name),
          subtitle: Text(documentSnapshots[index].id),
        );
      },
// orderBy is compulsory to enable pagination
      query: context
          .read<DataProvider>()
          .getProtestCollectionRef
          .orderBy('name', descending: false)
          .where('name', isGreaterThanOrEqualTo: "love")
          .where('name', isLessThan: "love" + 'z'),
//Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
// to fetch real-time data
      isLive: true,
    );
  }
}
