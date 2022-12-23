import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protestory/providers/navigation_provider.dart';
import 'package:protestory/screens/search_screen.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../widgets/navigation.dart';
import '../widgets/protest_list_home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    context.watch<NavigationProvider>();
    List<SearchOptions> list = [
      SearchOptions.mostPopular,
      SearchOptions.mostRecent,
      SearchOptions.all
    ];
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Protestory', style: navTitleStyle),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: SvgPicture.asset(
                'assets/icons/app_logo.svg',
                color: blue,
                alignment: Alignment.topCenter,
                fit: BoxFit.scaleDown,
              ),
            ),
          ],
        ),
        backgroundColor: white,
      ),
      body: RefreshIndicator(
        color: blue,
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
            itemBuilder: (context, index) =>
                ProtestListHome(searchOption: list[index]),
            separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(
                    color: Colors.grey,
                  ),
                ),
            itemCount: list.length),
      ),
    );
  }
}
