import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:provider/provider.dart';

import '../constants/tags.dart';
import '../firebase/protest.dart';
import '../providers/data_provider.dart';
import '../providers/navigation_provider.dart';
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

Query<Protest> searchQuery(DataProvider dataProvider,
    SearchOptions searchOption, List<String> selectedTags,
    {String text = '', bool isSearchAvail = true}) {
  Query<Protest> wantedQuery;
  if (isSearchAvail) {
    //search view
    switch (searchOption) {
      case SearchOptions.mostRecent:
        {
          wantedQuery = dataProvider.getProtestCollectionRef
              .orderBy('creation_time', descending: true)
              .where('prefixes_name', arrayContains: text);
        }
        break;
      case SearchOptions.mostPopular:
        {
          wantedQuery = dataProvider.getProtestCollectionRef
              .orderBy('participants_amount', descending: true)
              .where('prefixes_name', arrayContains: text);
        }
        break;
      default:
        {
          //ALl- sorted by name
          wantedQuery = dataProvider.getProtestCollectionRef
              .orderBy('name', descending: false)
              .where('prefixes_name', arrayContains: text);
        }
    }
  } else {
    //tags view
    wantedQuery = dataProvider.getProtestCollectionRef
        .orderBy('creation_time', descending: true);
    if (selectedTags.isNotEmpty) {
      wantedQuery = wantedQuery.where('ags', arrayContainsAny: selectedTags);
    }
  }
  return wantedQuery;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final QueryChangeListener<Protest> queryProvider;
  String searchText = '';

  // List<String> selectedTagsList = [];
  bool isSearchView = true;

  @override
  void initState() {
    super.initState();
    queryProvider = QueryChangeListener(searchQuery(
        context.read<DataProvider>(),
        context.read<SearchPresetsProvider>().searchOption, []));
    context.read<SearchPresetsProvider>().addListener(() {
      _updateQuery();
    });
  }

  @override
  void dispose() {
    queryProvider.dispose();
    super.dispose();
  }

  _updateQuery({bool isSearchAvail = true}) {
    queryProvider.query = searchQuery(
        context.read<DataProvider>(),
        context.read<SearchPresetsProvider>().searchOption,
        context.read<SearchPresetsProvider>().selectedTagsList,
        text: searchText.toLowerCase(),
        isSearchAvail: isSearchAvail);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<NavigationProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search', style: navTitleStyle),
          backgroundColor: white,
        ),
        body: Paginator(
          queryProvider: queryProvider,
          header: SliverAppBar(
            titleSpacing: 0,
            centerTitle: true,
            backgroundColor: white,
            toolbarHeight: 150,
            floating: true,
            title: isSearchView
                ? Column(
                    children: [
                      addVerticalSpace(height: 15),
                      CustomTextFormField(
                        textInputAction: TextInputAction.search,
                        icon: IconButton(
                            onPressed: () {
                              isSearchView = false;
                              _updateQuery(isSearchAvail: isSearchView);
                              setState(() {});
                            },
                            icon: const Icon(Icons.filter_alt),
                            color: darkPurple),
                        hintText: 'Search...',
                        onChanged: (searchText) {
                          this.searchText = searchText;
                          _updateQuery();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<SearchOptions>(
                            // Initial Value
                            value: context
                                .watch<SearchPresetsProvider>()
                                .searchOption,
                            elevation: 20,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items:
                                SearchOptions.values.map((SearchOptions item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item.value),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (SearchOptions? newValue) {
                              setState(() {
                                context
                                    .read<SearchPresetsProvider>()
                                    .searchOption = newValue!;
                              });
                            },
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                        ],
                      ),
                      //  Padding(
                      //padding: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width * 0.1,
                      // right: MediaQuery.of(context).size.width * 0.1),
                      //child:
                    ],
                  )
                : Column(
                    children: [
                      ListTile(
                        title: const Text('Choose Tags',
                            style: TextStyle(color: lightGray, fontSize: 24)),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: darkPurple,
                            ),
                            onPressed: () {
                              isSearchView = true;
                              _updateQuery(isSearchAvail: isSearchView);
                              setState(() {});
                            }),
                      ),
                      addVerticalSpace(height: 10),
                      SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 5),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Wrap(
                              spacing: 10,
                              children: List<Widget>.generate(
                                tags.length,
                                (int index) {
                                  bool currSelected = context
                                      .read<SearchPresetsProvider>()
                                      .selectedTagsList
                                      .contains(tags[index]);
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: ChoiceChip(
                                      // shape: const StadiumBorder(
                                      //   side: BorderSide(),
                                      // ),
                                      side: BorderSide(
                                          color: currSelected
                                              ? darkPurple
                                              : lightGray),
                                      labelPadding: const EdgeInsets.all(5.0),
                                      label: Text(
                                        tags[index],
                                        style: TextStyle(
                                            color: currSelected
                                                ? darkPurple
                                                : black,
                                            fontSize: 18),
                                      ),
                                      selected: currSelected,
                                      selectedColor: transparentPurple,
                                      backgroundColor:
                                          currSelected ? purple : white,
                                      elevation: 2,
                                      onSelected: (bool selected) {
                                        //  setState(() {
                                        selected
                                            ? context
                                                .read<SearchPresetsProvider>()
                                                .addTag(tags[index])
                                            : context
                                                .read<SearchPresetsProvider>()
                                                .removeTag(tags[index]);
                                        _updateQuery(isSearchAvail: false);
                                      },
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          onEmpty: const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'No protests match your search',
                style: TextStyle(color: darkGray),
              ),
            ),
          ),
        ));
    //onFieldSubmitted: ;
  }
}
