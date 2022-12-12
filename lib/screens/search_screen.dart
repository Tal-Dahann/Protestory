import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/data_provider.dart';
import '../firebase/protest.dart';
import '../widgets/navigation.dart';
import '../widgets/paginator.dart';

enum SearchOptions {
  all('All'),
  mostRecent('Most Recent'),
  mostPopular('Most Popular');

  const SearchOptions(this.value);
  final String value;
}

Query<Protest> searchQuery(BuildContext context, SearchOptions searchOption,
    {String text = ''}) {
  switch (searchOption) {
    case SearchOptions.mostRecent:
      {
        return context
            .read<DataProvider>()
            .getProtestCollectionRef
            .orderBy('creation_time', descending: true)
            .where('prefixes_name', arrayContains: text);
      }
    case SearchOptions.mostPopular:
      {
        return context
            .read<DataProvider>()
            .getProtestCollectionRef
            .orderBy('participants_amount', descending: true)
            .where('prefixes_name', arrayContains: text);
      }
    default:
      {
        //ALl- sorted by name
        return context
            .read<DataProvider>()
            .getProtestCollectionRef
            .orderBy('name', descending: false)
            .where('name', isGreaterThanOrEqualTo: text)
            .where('name', isLessThan: '${text}z');
      }
  }
}

class SearchScreen extends StatefulWidget {
  final SearchOptions initDropDownValue;
  const SearchScreen({this.initDropDownValue = SearchOptions.all, Key? key})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String text = '';

  late SearchOptions dropDownValue = widget.initDropDownValue;

  @override
  Widget build(BuildContext context) {
    Query<Protest> qry = searchQuery(context, dropDownValue);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: navTitleStyle),
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
              text = searchText.toLowerCase();
            }),
            onFieldSubmitted: (searchText) => setState(() {
              text = searchText.toLowerCase();
            }),
          ),
          addVerticalSpace(height: 4),
          DropdownButton<SearchOptions>(
            // Initial Value
            value: dropDownValue,
            elevation: 10,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: SearchOptions.values.map((SearchOptions item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.value),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (SearchOptions? newValue) {
              setState(() {
                //TODO: when it is null??
                dropDownValue = newValue!;
              });
            },
          ),
          Expanded(child: Paginator(query: qry))
        ],
      ),
    );
    //onFieldSubmitted: ;
  }
}
