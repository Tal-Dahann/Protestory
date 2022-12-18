import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/constants/colors.dart';
import 'package:provider/provider.dart';

import '../firebase/data_provider.dart';
import '../firebase/protest.dart';
import '../utils/add_spaces.dart';
import '../widgets/navigation.dart';
import '../widgets/paginator.dart';
import '../widgets/text_fields.dart';

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
            .where('prefixes_name', arrayContains: text);
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
  late SearchOptions dropDownValue = widget.initDropDownValue;
  late final QueryChangeListener<Protest> queryProvider;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    queryProvider = QueryChangeListener(searchQuery(context, dropDownValue));
  }

  @override
  void dispose() {
    queryProvider.dispose();
    super.dispose();
  }

  _updateQuery() {
    queryProvider.query =
        searchQuery(context, dropDownValue, text: searchText.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search', style: navTitleStyle),
          backgroundColor: white,
        ),
        body: Paginator(
          queryProvider: queryProvider,
          header: SliverAppBar(
            backgroundColor: white,
            toolbarHeight: 150,
            centerTitle: true,
            floating: true,
            title: Column(
              children: [
                addVerticalSpace(height: 15),
                CustomTextFormField(
                  icon: const Icon(Icons.search),
                  hintText: "Search...",
                  onChanged: (searchText) {
                    this.searchText = searchText;
                    _updateQuery();
                  },
                ),
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
                      _updateQuery();
                    });
                  },
                ),
              ],
            ),
          ),
          onEmpty: const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "No protests match your search",
                style: TextStyle(color: darkGray),
              ),
            ),
          ),
        ));
    //onFieldSubmitted: ;
  }
}
