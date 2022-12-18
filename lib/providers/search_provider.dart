import 'package:flutter/cupertino.dart';

import '../screens/search_screen.dart';

class SearchPresetsProvider extends ChangeNotifier {
  SearchOptions _searchOption = SearchOptions.all;
  SearchPresetsProvider();

  SearchOptions get searchOption {
    return _searchOption;
  }

  set searchOption(SearchOptions searchOptions) {
    _searchOption = searchOptions;
    notifyListeners();
  }
}
