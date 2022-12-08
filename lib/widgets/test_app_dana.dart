import 'package:flutter/material.dart';
import 'package:protestory/widgets/protest_list_home.dart';
import 'package:provider/provider.dart';

import '../firebase/data_provider.dart';

class TestAppDana extends StatelessWidget {
  const TestAppDana({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<DataProvider>().getMostRecentProtests(n: 5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(snapshot.error.toString(),
                  textDirection: TextDirection.ltr));
        }
        if (snapshot.hasData) {
          return ProtestListHome(
              protestList: snapshot.requireData, maxLengthList: 5);
        }

        //TODO: replace with waiting to list to load
        return const CircularProgressIndicator();
      },
    );

    //ProtestListHome(protestList: pl, maxLengthList: 5);
  }
}
