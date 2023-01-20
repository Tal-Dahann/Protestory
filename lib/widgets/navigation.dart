import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/navigation_provider.dart';
import 'package:provider/provider.dart';

import '../screens/account_screen.dart';
import '../screens/create_new_protest_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/main_screen.dart';
import '../screens/search_screen.dart';

const navTitleStyle =
    TextStyle(color: blue, fontWeight: FontWeight.bold, fontSize: 28);

class MainNavigation extends StatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final screens = const [
    MainScreen(),
    SearchScreen(),
    //UserSearch(),
    SizedBox(), // Add new protest filler
    FavoritesScreen(),
    AccountScreen(),
  ];

  final navBarItems = [
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: blue,
        inactiveColorPrimary: lightBlue),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.search),
        title: 'Search',
        activeColorPrimary: blue,
        inactiveColorPrimary: lightBlue),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.add),
        title: 'New Protest',
        activeColorPrimary: blue,
        inactiveColorPrimary: lightBlue),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: 'My Protests',
        activeColorPrimary: blue,
        inactiveColorPrimary: lightBlue),
    PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: 'Profile',
        activeColorPrimary: blue,
        inactiveColorPrimary: lightBlue),
  ];

  late final PersistentTabController _controller;

  late int lastIndex;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    lastIndex = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => NavigationProvider(_controller),
      builder: (context, _) {
        return PersistentTabView(
          context,
          controller: _controller,
          screens: screens,
          items: navBarItems,
          decoration: const NavBarDecoration(
            boxShadow: [BoxShadow(blurRadius: 6, color: Colors.grey)],
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            colorBehindNavBar: Colors.white,
          ),
          navBarStyle: NavBarStyle.style12,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          onItemSelected: (index) {
            if (index == 2) {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const NewProtestScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.slideRight,
              ).then((value) =>
                  context.read<NavigationProvider>().notifyScreens());
              _controller.index = lastIndex;
            } else {
              lastIndex = index;
            }
          },
        );
      },
    );
  }
}
