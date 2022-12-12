import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/screens/search_screen.dart';
import 'package:protestory/widgets/protest_card.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/data_provider.dart';
import 'loading.dart';

class ProtestListHome extends StatelessWidget {
  final int maxLengthList;
  final SearchOptions searchOption;

  const ProtestListHome(
      {this.maxLengthList = 10, Key? key, required this.searchOption})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Protest>>(
      future: context
          .read<DataProvider>()
          .processQuery(searchQuery(context, searchOption)),
      builder: (BuildContext context, AsyncSnapshot<List<Protest>> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.hasData) {
          double height = 280;
          int listSize = min(snapshot.requireData.length, maxLengthList);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 6, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      searchOption.value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: blue,
                      ),
                    ),
                    InkWell(
                      onTap: () => 1, //TODO
                      child: const Text(
                        "see all",
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
                height: height,
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  itemCount: listSize,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(),
                  itemBuilder: (BuildContext context, int index) {
                    return ProtestCard.byHeight(
                      protest: snapshot.requireData[index],
                      height: height,
                      shape: roundedProtestCardBorder,
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const LoadingWidget();
      },
    );
  }
}
