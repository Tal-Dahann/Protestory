import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/data_provider.dart';
import '../providers/navigation_provider.dart';
import '../utils/add_spaces.dart';
import '../widgets/navigation.dart';
import '../widgets/paginator_favorites.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.watch<NavigationProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Joined Protests', style: navTitleStyle),
          backgroundColor: white,
        ),
        body: PaginatorFavorites(
          queryProvider: QueryChangeListener(
              context.read<DataProvider>().getMyAttendings()),
          header: SliverAppBar(
            backgroundColor: white,
            toolbarHeight: 5,
            centerTitle: true,
            floating: true,
            title: Column(
              children: [
                addVerticalSpace(height: 15),
              ],
            ),
          ),
          onEmpty: const Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Not Attending any protests yet',
                style: TextStyle(color: darkGray),
              ),
            ),
          ),
        ));
  }
}
