import 'package:flutter/material.dart';
import 'package:makeup_api/models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<Product> _favoriteList = [];
  bool removeAllClicked = false;

  void addFavorite(Product item) {
    item.isfavorite = true;
    _favoriteList.add(item);
    notifyListeners();
  }

  void removeFavorite(Product item) {
    item.isfavorite = false;
    _favoriteList.remove(item);
    notifyListeners();
  }

  void removeAll() {
    _favoriteList.map((e) => e.isfavorite = false);
    _favoriteList.clear();
    removeAllClicked = true;
    notifyListeners();
  }

  List<Product> get favoriteItems => _favoriteList;
}
