import 'dart:math';

import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/widgets/protest_card.dart';

class ProtestListHome extends StatelessWidget {
  final List<Protest> protestList;
  final int maxLengthList;

  const ProtestListHome(
      {required this.protestList, required this.maxLengthList, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int listSize = min(protestList.length, maxLengthList);

    if (listSize > 0) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.separated(
          itemCount: listSize,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (BuildContext context, int index) => const Divider(
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ProtestCard(protest: protestList[index]);
          },
        ),
      );
    } else {
      return const Text(
        "No Protests Yet",
        style: TextStyle(height: 10),
      );
    }
  }
}
