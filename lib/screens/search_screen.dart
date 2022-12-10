import 'package:flutter/material.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/data_provider.dart';
import '../widgets/paginator.dart';

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
          addVerticalSpace(height: 4),
          Expanded(
              child: Paginator(
            query: context
                .read<DataProvider>()
                .getProtestCollectionRef
                .orderBy('name', descending: false)
                .where('name', isGreaterThanOrEqualTo: text)
                .where('name', isLessThan: '${text}z'),
          ))
        ],
      ),
    );
    //onFieldSubmitted: ;
  }
}
