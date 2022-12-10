import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/widgets/protest_card_search.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';

class Paginator extends StatelessWidget {
  Paginator({required this.query, Key? key}) : super(key: key);

  Query<Protest> query;
  @override
  Widget build(BuildContext context) {
    return PaginateFirestore(
      //TODO: check if it lazy loaded
      //itemsPerPage: 5,
      //TODO: what is unique key??
      key: UniqueKey(),
      onEmpty: const Text(
        "No protests match your search",
        style: TextStyle(color: darkGray),
      ),
//item builder type is compulsory.
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Protest;
        if (data == null) {
          return const Text('Error in data');
        } else {
          return ProtestCardSearch(protest: data);
        }

        //   ListTile(
        //   leading: const CircleAvatar(child: Icon(Icons.person)),
        //   title: data == null ? const Text('Error in data') : Text(data.name),
        //   subtitle: Text(documentSnapshots[index].id),
        // );
      },
// orderBy is compulsory to enable pagination
      query: query,
//Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
// to fetch real-time data
      //TODO: check is it really necessary
      isLive: true,
    );
  }
}
