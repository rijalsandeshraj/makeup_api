import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class HttpHelper {
  final String authority = 'makeup-api.herokuapp.com';
  final String path = 'api/v1/products.json';

  Future<List<Product>?> getProductList() async {
    Uri url = Uri.https(authority, path);
    http.Response result = await http.get(url);
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<Product> products = [];
      for (var item in jsonResponse) {
        products.add(Product.fromJson(item));
      }
      return products;
    } else {
      return [];
    }
  }
}