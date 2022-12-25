import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class NavigationProvider extends ChangeNotifier {
  final PersistentTabController controller;

  NavigationProvider(this.controller);

  void notifyScreens() {
    notifyListeners();
  }
}
