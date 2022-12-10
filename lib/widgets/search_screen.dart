import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/protest_card_search.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String text = 'zzzzzzzzzzzzzzzzzzzzzzzzz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search',
            style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
        backgroundColor: white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addVerticalSpace(height: 15),
          CustomTextFormField(
            icon: const Icon(Icons.search),
            hintText: "Search...",
            onChanged: (searchText) => setState(() {
              text = searchText;
            }),
            onFieldSubmitted: (searchText) => setState(() {
              text = searchText;
            }),
          ),
          addVerticalSpace(height: 3),
          Expanded(child: Paginator(searchText: text))
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
    print("building pagintor: $searchText");
    return PaginateFirestore(
      //TODO: check if it lazy loaded
      //itemsPerPage: 5,
      key: ValueKey(searchText),
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
      query: context
          .read<DataProvider>()
          .getProtestCollectionRef
          .orderBy('name', descending: false)
          .where('name', isGreaterThanOrEqualTo: searchText)
          .where('name', isLessThan: '${searchText}z'),
//Change types accordingly
      itemBuilderType: PaginateBuilderType.listView,
// to fetch real-time data
      //TODO: check is it really necessary
      isLive: true,
    );
  }
}
