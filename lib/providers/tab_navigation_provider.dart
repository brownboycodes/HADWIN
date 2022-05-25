import 'package:flutter/material.dart';

class TabNavigationProvider with ChangeNotifier {
  List<int> _tabHistory = [0];

  int get lastTab => _tabHistory.last;

  void removeLastTab() {
    _tabHistory.removeLast();
    notifyListeners();
  }

  void updateTabs(int tab) {
    if (tab == 0) {
      _tabHistory = [0];
    } else {
      _tabHistory.removeWhere((element) => element == tab);
      _tabHistory.add(tab);
    }
    notifyListeners();
  }
}
