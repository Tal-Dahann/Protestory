import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:provider/provider.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';

import 'package:protestory/constants/colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page',
            style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
        backgroundColor: white,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'My Protests'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_rounded), label: 'New Protest'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded), label: 'Profile'),
        ],
        onTap: (index) {
          switch(index) {
            case 0:
              break;
            case 1:
              log('pressed my protests - nothing to show yet');
              break;
            case 2:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewProtestScreen()));
              break;
            case 3:
              log('pressed search - nothing to show yet');
              break;
            case 4:
              log('pressed profile - nothing to show yet');
              break;
          }
        },
        showUnselectedLabels: true,
        showSelectedLabels: true,
        unselectedItemColor: lightBlue,
        selectedItemColor: blue,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const TestAppDana(),
            ElevatedButton(
              onPressed: context.read<AuthNotifier>().signOut,
              child: Text(
                  "Logout from ${context.read<AuthNotifier>().user?.displayName}"),
            ),
          ],
        ),
      ),
    );
  }
}
