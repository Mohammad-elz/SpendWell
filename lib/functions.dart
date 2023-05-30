import 'models/product.dart';

List<Product> getProductByCategory(String KJackets,List<Product> allproducts) {
  List<Product> products = [];
  try {
    for (var product in allproducts) {
      if (product.Pcategory == KJackets) {
        products.add(product);
      }
    }
  }on Error catch(e){
    print(e);
  }
  return products;
}