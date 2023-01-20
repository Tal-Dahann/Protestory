import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/navigation_provider.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:protestory/screens/search_screen.dart';
import 'package:protestory/widgets/protest_card.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/data_provider.dart';
import 'loading.dart';

class ProtestListHome extends StatelessWidget {
  static const cardHeight = 300.0;
  final int maxLengthList;
  final SearchOptions searchOption;

  const ProtestListHome(
      {this.maxLengthList = 10, Key? key, required this.searchOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                searchOption.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: blue,
                ),
              ),
              InkWell(
                onTap: () {
                  context.read<SearchPresetsProvider>().searchOption =
                      searchOption;
                  context.read<NavigationProvider>().controller.jumpToTab(1);
                },
                child: const Text(
                  'see all',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: purple,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: cardHeight,
          child: FutureBuilder<List<Protest>>(
            future: context.read<DataProvider>().processQuery(
                searchQuery(context.read<DataProvider>(), searchOption, [])),
            builder:
                (BuildContext context, AsyncSnapshot<List<Protest>> snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                    body: Center(
                        child: Text(snapshot.error.toString(),
                            textDirection: TextDirection.ltr)));
              }
              if (snapshot.hasData) {
                int listSize = min(snapshot.requireData.length, maxLengthList);
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  itemCount: listSize,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return ProtestCard(
                      protest: snapshot.requireData[index],
                      type: ProtestCardTypes.mainScreen,
                    );
                  },
                );
              }
              return const LoadingWidget();
            },
          ),
        ),
      ],
    );
  }
}
