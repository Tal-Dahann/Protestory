import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/colors.dart';
import '../widgets/navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
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
    );
  }
}
