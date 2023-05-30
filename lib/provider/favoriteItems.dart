import 'package:flutter/material.dart';

import '../models/product.dart';

class AddToFavorite extends ChangeNotifier{

  List<Product> FavoriteItems = [];

  addToFavorite(Product product){
    FavoriteItems.add(product);
    notifyListeners();
  }

  RemoveFromFavorite(Product product){
    FavoriteItems.remove(product);
    notifyListeners();
  }

}