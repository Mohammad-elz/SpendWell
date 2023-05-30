import 'package:flutter/material.dart';
import '../functions.dart';
import '../models/product.dart';

Widget ProductsView(String pCategory,List<Product> allProducts) {
  List<Product> products ;
  products = getProductByCategory(pCategory,allProducts);
  return GridView.builder(
    gridDelegate:
    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, 'productInfo',arguments: products[index]);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Image(
                fit: BoxFit.fill,
                image: AssetImage(products[index].Pimage),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Opacity(
                opacity: .7,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products[index].Pname,
                          style: TextStyle(
                            fontSize: 15,
                            color:   Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$ ${products[index].Pprice}',
                          style: TextStyle(
                            fontSize: 15,
                            color:   Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    itemCount: products.length,
  );
}