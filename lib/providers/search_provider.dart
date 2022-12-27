import 'package:flutter/cupertino.dart';

import '../screens/search_screen.dart';

class SearchPresetsProvider extends ChangeNotifier {
  SearchOptions _searchOption = SearchOptions.all;
  final List<String> _selectedTagsList = [];

  SearchPresetsProvider();

  SearchOptions get searchOption {
    return _searchOption;
  }

  List<String> get selectedTagsList {
    return _selectedTagsList;
  }

  void addTag(String tag) {
    _selectedTagsList.add(tag);
    notifyListeners();
  }

  void removeTag(String tag) {
    _selectedTagsList.remove(tag);
    notifyListeners();
  }

  set searchOption(SearchOptions searchOptions) {
    _searchOption = searchOptions;
    notifyListeners();
  }
}
