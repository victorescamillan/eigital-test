import 'dart:convert';
import 'package:eigital_test/constants/network_response.dart';
import 'package:eigital_test/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  final _productUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> getProducts() async {
    var url = Uri.parse(_productUrl);
    dynamic httpRes = await http.get(url);
    if(httpRes.reasonPhrase == NetworkResponse.OK){
      List<dynamic> items = jsonDecode(httpRes.body);
      if(items != null && items.length > 0){
        return items.map((e) => Product.fromJson(e)).toList();
      }
    }

    return [];
  }
}