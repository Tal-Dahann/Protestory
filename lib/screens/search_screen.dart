import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../constants/tags.dart';
import '../firebase/protest.dart';
import '../providers/data_provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/add_spaces.dart';
import '../utils/permissions_helper.dart';
import '../widgets/paginator.dart';
import '../widgets/protest_card.dart';
import '../widgets/text_fields.dart';

enum SearchOptions {
  all('All'),
  mostRecent('Most Recent'),
  mostPopular('Most Popular'),
  closest('Near You'),
  tagged('By Tag'),
  dateRange('Date Range');

  const SearchOptions(this.title);

  final String title;
}

Query<Protest> searchQuery(DataProvider dataProvider,
    SearchOptions searchOption, List<String> selectedTags,
    {String text = '', DateTime? start, DateTime? end}) {
  Query<Protest> wantedQuery;
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
    case SearchOptions.all:
      {
        wantedQuery = dataProvider.getProtestCollectionRef
            .orderBy('name', descending: false)
            .where('prefixes_name', arrayContains: text);
      }
      break;
    case SearchOptions.closest:
      {
        wantedQuery = dataProvider.getProtestCollectionRef
            .where('prefixes_name', arrayContains: text);
      }
      break;
    case SearchOptions.tagged:
      {
        //tags view
        wantedQuery = dataProvider.getProtestCollectionRef
            .orderBy('name', descending: false);
        if (selectedTags.isNotEmpty) {
          wantedQuery =
              wantedQuery.where('tags', arrayContainsAny: selectedTags);
        }
      }
      break;
    case SearchOptions.dateRange:
      {
        wantedQuery = dataProvider.getProtestCollectionRef
            .orderBy('date', descending: false)
            .where("date", isGreaterThanOrEqualTo: start)
            .where("date", isLessThanOrEqualTo: end);
      }
      break;
    default:
      {
        wantedQuery = dataProvider.getProtestCollectionRef
            .orderBy('name', descending: false);
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
  final TextEditingController searchTextController = TextEditingController();
  String searchText = '';

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
    searchTextController.dispose();
    queryProvider.dispose();
    super.dispose();
  }

  _updateQuery({DateTime? start, DateTime? end}) {
    queryProvider.query = searchQuery(
        context.read<DataProvider>(),
        context.read<SearchPresetsProvider>().searchOption,
        context.read<SearchPresetsProvider>().selectedTagsList,
        text: searchText.toLowerCase(),
        start: start,
        end: end);
    setState(() {});
  }

  Widget _textFiller(String text) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        text,
        style: const TextStyle(color: darkGray),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<NavigationProvider>();

    Widget themeBuilder(BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: blue,
            onPrimary: white,
            onSurface: darkBlue,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                backgroundColor: lightBlue, foregroundColor: white),
          ),
        ),
        child: child!,
      );
    }

    Widget appBar = SliverAppBar(
      titleSpacing: 0,
      centerTitle: true,
      backgroundColor: white,
      toolbarHeight: 150,
      floating: true,
      title: context.watch<SearchPresetsProvider>().searchOption ==
              SearchOptions.tagged
          ? Column(
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
                        context.read<SearchPresetsProvider>().searchOption =
                            SearchOptions.all;
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
                                    color:
                                        currSelected ? darkPurple : lightGray),
                                labelPadding: const EdgeInsets.all(5.0),
                                label: Text(
                                  tags[index],
                                  style: TextStyle(
                                      color: currSelected ? darkPurple : black,
                                      fontSize: 18),
                                ),
                                selected: currSelected,
                                selectedColor: transparentPurple,
                                backgroundColor: currSelected ? purple : white,
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
                                  _updateQuery();
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
            )
          : context.watch<SearchPresetsProvider>().searchOption ==
                  SearchOptions.dateRange
              ? Column(children: [
                  Row(
                    children: [
                      const Padding(padding: EdgeInsets.only(left: 10.0)),
                      const Text('Choose Date Range',
                          style: TextStyle(color: lightGray, fontSize: 24)),
                      IconButton(
                          icon: const Icon(
                            Icons.date_range,
                            color: darkPurple,
                          ),
                          onPressed: () async {
                            DateTimeRange? pickedDate =
                                await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    builder: themeBuilder);
                            //initialDate: DateTime.now(),

                            if (pickedDate != null) {
                              DateTime start = pickedDate.start;
                              DateTime end = pickedDate.end;

                              _updateQuery(start: start, end: end);

                              //context.read<SearchPresetsProvider>().searchOption =
                              //  SearchOptions.all;
                            }
                          }),
                      const Spacer(),
                      IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: darkPurple,
                          ),
                          onPressed: () {
                            context.read<SearchPresetsProvider>().searchOption =
                                SearchOptions.all;
                          })
                    ],
                  )
                ])
              : Column(
                  children: [
                    addVerticalSpace(height: 15),
                    CustomTextFormField(
                      controller: searchTextController,
                      textInputAction: TextInputAction.search,
                      icon: IconButton(
                          onPressed: () {
                            context.read<SearchPresetsProvider>().searchOption =
                                SearchOptions.tagged;
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
                          items: SearchOptions.values.map((SearchOptions item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item.title),
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
                ),
    );
    Widget body;
    if (context.read<SearchPresetsProvider>().searchOption ==
        SearchOptions.closest) {
      body = CustomScrollView(
        slivers: [
          appBar,
          FutureBuilder(
              future: requestLocationPermission(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  var message = snapshot.error as String;
                  return SliverToBoxAdapter(
                    child: _textFiller(message),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return FutureBuilder(
                    future: Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best)
                        .then((position) => DataProvider.geostore
                            .collectionWithConverter(
                                collectionRef: queryProvider.query)
                            .withinWithDistance(
                                center: GeoFirePoint(
                                    position.latitude, position.longitude),
                                radius: 50,
                                field: 'location_point',
                                geopointFrom: (p) => GeoPoint(
                                    p.locationLatLng.latitude,
                                    p.locationLatLng.longitude))
                            .first)
                        .then((snapshots) => snapshots
                            .map((snapshot) => snapshot.documentSnapshot.data()!
                              ..distanceFromUser = snapshot.kmDistance)
                            .toList()
                          ..sort((a, b) =>
                              a.distanceFromUser
                                  ?.compareTo(b.distanceFromUser ?? 0) ??
                              0)),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.requireData.isEmpty) {
                          return SliverToBoxAdapter(
                            child: _textFiller(
                                'No protests with 50 km match your search'),
                          );
                        }
                        return SliverList(
                            delegate:
                                SliverChildListDelegate(snapshot.requireData
                                    .map((e) => ProtestCard(
                                          protest: e,
                                          type: ProtestCardTypes.wholeScreen,
                                        ))
                                    .toList()));
                      }
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LoadingWidget(),
                        ),
                      );
                    },
                  );
                }
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LoadingWidget(),
                  ),
                );
              }),
        ],
      );
    } else {
      body = Paginator(
        queryProvider: queryProvider,
        header: appBar,
        onEmpty: _textFiller('No protests match your search'),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: white,
        ),
        body: body);
    //onFieldSubmitted: ;
  }
}
