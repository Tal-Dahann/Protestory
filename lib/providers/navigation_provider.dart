import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/utils/exceptions.dart';

class NavigationProvider extends ChangeNotifier {
  PersistentTabController? _controller;

  PersistentTabController get controller {
    if (_controller == null) {
      throw NavigationNotInitialized();
    }
    return _controller!;
  }

  set controller(PersistentTabController newController) {
    _controller = newController;
  }

  NavigationProvider({PersistentTabController? controller})
      : _controller = controller;

  void notifyScreens() {
    notifyListeners();
  }
}
