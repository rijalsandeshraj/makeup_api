import 'package:flutter/foundation.dart';
import 'package:makeup_api/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _products = [];
  double _totalPrice = 0.0;

  void add(Product item) {
    if (_products.contains(item)) {
      item.orderQuantity++;
    } else {
      _products.add(item);
    }
    _totalPrice += item.dPrice;
    notifyListeners();
  }

  void remove(Product item) {
    _totalPrice -= (item.dPrice * item.orderQuantity);
    item.orderQuantity = 1;
    _products.remove(item);
    notifyListeners();
  }

  void removeOne(Product item) {
    if (item.orderQuantity > 1) {
      _totalPrice -= item.dPrice;
      item.orderQuantity--;
    }
    notifyListeners();
  }

  void removeAll() async {
    _products.map((e) => e.orderQuantity = 1);
    _products.clear();
    _totalPrice = 0.0;
    notifyListeners();
  }

  int get count => _products.length;

  String get totalPrice => _totalPrice.toStringAsFixed(2);

  List<Product> get cartItems => _products;
}
