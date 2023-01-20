import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:provider/provider.dart';

import '../firebase/protest.dart';
import '../providers/data_provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/add_spaces.dart';
import '../widgets/paginator.dart';
import '../widgets/text_fields.dart';

class UserSearch extends StatefulWidget {
  const UserSearch({Key? key}) : super(key: key);

  @override
  State<UserSearch> createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  late final QueryChangeListener<Protest> queryProvider;
  final TextEditingController searchTextController = TextEditingController();
  String searchText = '';

  @override
  void initState() {
    super.initState();
    queryProvider = QueryChangeListener(context
        .read<DataProvider>()
        .getProtestCollectionRef
        .where('username', arrayContains: ''));
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

  _updateQuery({bool isSearchAvail = true}) {
    queryProvider.query = context
        .read<DataProvider>()
        .getProtestCollectionRef
        .orderBy("username", descending: false)
        .where("username", isLessThan: searchText.toLowerCase())
        .where("username", isLessThan: '${searchText.toLowerCase()}+z');
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
    Widget appBar = SliverAppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: white,
        toolbarHeight: 150,
        floating: true,
        title: Column(
          children: [
            addVerticalSpace(height: 15),
            CustomTextFormField(
              controller: searchTextController,
              textInputAction: TextInputAction.search,
              icon: IconButton(
                  onPressed: () {
                    _updateQuery(isSearchAvail: true);
                    setState(() {});
                  },
                  icon: const Icon(Icons.filter_alt),
                  color: darkPurple),
              hintText: 'Search User...',
              onChanged: (searchText) {
                this.searchText = searchText;
                _updateQuery();
              },
            ),
          ],
        ));
    Widget body;
    body = Paginator(
      queryProvider: queryProvider,
      header: appBar,
      onEmpty: _textFiller('No protests match your search'),
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search User'),
          backgroundColor: white,
        ),
        body: body);
    //onFieldSubmitted: ;
  }
}
