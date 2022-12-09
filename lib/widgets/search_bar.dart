import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../firebase/protest.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _searchController = TextEditingController();
  String text = 'zzzzz';

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomTextFormField(
            controller: _searchController,
            hintText: "Search...",
            onChanged: (searchText) => setState(() {
              //print("changed");
              text = searchText;
            }),
            onFieldSubmitted: (searchText) => setState(() {
              text = searchText;
            }),
          ),
          Container(height: 500, child: Paginator(searchText: text))
        ],
      ),
    );
    //onFieldSubmitted: ;
  }
}

class Paginator extends StatelessWidget {
  Paginator({required String this.searchText, Key? key}) : super(key: key);
  String searchText;
  @override
  Widget build(BuildContext context) {
    print("building pagintor: " + searchText);
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
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: '${searchText}z'),
//Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
// to fetch real-time data
      //isLive: true,
    );
  }
}
