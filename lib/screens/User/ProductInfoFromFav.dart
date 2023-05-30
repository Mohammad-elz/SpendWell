import 'package:ecommerce/provider/cartItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../provider/favoriteItems.dart';

class ProductInfoFromFav extends StatefulWidget {
  const ProductInfoFromFav({Key? key}) : super(key: key);

  @override
  State<ProductInfoFromFav> createState() => _ProductInfoFromFavState();
}

class _ProductInfoFromFavState extends State<ProductInfoFromFav> {
  int quantity = 1;
  bool isFavorite=false;
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context)?.settings.arguments as Product;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*.5,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*.5,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      fit: BoxFit.fill,
                      image: AssetImage(product.Pimage),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*.2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_ios,size: 30,),),
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'cartScreen');
                              },
                              child: Icon(Icons.shopping_cart_sharp,size: 30,)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color:Colors.grey[500],thickness:2,height: MediaQuery.of(context).size.height*.01,),
            Container(
              height: MediaQuery.of(context).size.height*.49,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .39,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // RichText(
                              //   text: TextSpan(
                              //     style: TextStyle(color: Colors.black),
                              //     children: <TextSpan>[
                              //       TextSpan(text: 'Name:', style: TextStyle(fontSize: 25,color: Colors.black),),
                              //       TextSpan(text: '${product.Pname}', style: TextStyle(fontSize: 20)),
                              //     ],
                              //   ),
                              // ),
                              Text(
                                'Name: ${product.Pname}',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                  size: 30,
                                ),
                                onPressed: (){
                                  setState(() {
                                    isFavorite =!isFavorite;
                                  });
                                  AddToFavorite FavoriteList = Provider.of<AddToFavorite>(context, listen: false);
                                  FavoriteList.addToFavorite(product);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Text(
                            'Price: ${product.Pprice} \$ ',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Material(
                                    color: Colors.blue,
                                    child: GestureDetector(
                                        onTap: subtract,
                                        child: Icon(Icons.remove))),
                              ),
                              Text(
                                '${quantity}',
                                style: TextStyle(fontSize: 50),
                              ),
                              ClipOval(
                                child: Material(
                                    color: Colors.blue,
                                    child: GestureDetector(
                                        onTap: add, child: Icon(Icons.add))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*.10,
                    width: MediaQuery.of(context).size.width,
                    child: Builder(builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Material(
                          elevation: 5,
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(20),
                          child: MaterialButton(
                            onPressed: () {
                              CartItem cartItem =
                              Provider.of<CartItem>(context, listen: false);
                              product.Pquantity = quantity;
                              bool exist = false;
                              var productsInCart = cartItem.products;
                              for (var productInCart in productsInCart) {
                                if (productInCart == product) {
                                  exist = true;
                                }
                              }
                              if (exist) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('you have added this item before'),
                                ));
                              } else {
                                cartItem.addProduct(product);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text('Added to Cart'),
                                ));
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width,
                            child: Text(
                              'Add to cart',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),






      // Stack(
      //   children: [
      //     Container(
      //       height: MediaQuery.of(context).size.height,
      //       width: MediaQuery.of(context).size.width,
      //       child: Image(
      //         fit: BoxFit.fill,
      //         image: AssetImage(product.Pimage),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
      //       child: Container(
      //         height: MediaQuery.of(context).size.height * .09,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             GestureDetector(
      //                 onTap: () {
      //                   Navigator.pop(context);
      //                 },
      //                 child: Icon(Icons.arrow_back_ios)),
      //             GestureDetector(
      //                 onTap: () {
      //                   Navigator.pushNamed(context, 'cartScreen');
      //                 },
      //                 child: Icon(Icons.shopping_cart_sharp)),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 0,
      //       child: Column(
      //         children: [
      //           Opacity(
      //             opacity: .4,
      //             child: Container(
      //               height: MediaQuery.of(context).size.height * .25,
      //               width: MediaQuery.of(context).size.width,
      //               color: Colors.white,
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     product.Pname,
      //                     style: TextStyle(
      //                         fontSize: 25, fontWeight: FontWeight.bold),
      //                   ),
      //                   Text(
      //                     '${product.Pprice} \$ ',
      //                     style: TextStyle(
      //                         fontSize: 25, fontWeight: FontWeight.bold),
      //                   ),
      //                   Text(
      //                     product.Pdescription,
      //                     style: TextStyle(
      //                         fontSize: 25, fontWeight: FontWeight.bold),
      //                   ),
      //                   Spacer(),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       ClipOval(
      //                         child: Material(
      //                             color: Colors.blue,
      //                             child: GestureDetector(
      //                                 onTap: subtract,
      //                                 child: Icon(Icons.remove))),
      //                       ),
      //                       Text(
      //                         '${quantity}',
      //                         style: TextStyle(fontSize: 50),
      //                       ),
      //                       ClipOval(
      //                         child: Material(
      //                             color: Colors.blue,
      //                             child: GestureDetector(
      //                                 onTap: add, child: Icon(Icons.add))),
      //                       ),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           Builder(builder: (context) {
      //             return Material(
      //               elevation: 5,
      //               color: Colors.blue[900],
      //               borderRadius: BorderRadius.circular(10),
      //               child: MaterialButton(
      //                 onPressed: () {
      //                   CartItem cartItem =
      //                       Provider.of<CartItem>(context, listen: false);
      //                   product.Pquantity = quantity;
      //                   bool exist = false;
      //                   var productsInCart = cartItem.products;
      //                   for (var productInCart in productsInCart) {
      //                     if (productInCart == product) {
      //                       exist = true;
      //                     }
      //                   }
      //                   if (exist) {
      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                       content: Text('you have added this item before'),
      //                     ));
      //                   } else {
      //                     cartItem.addProduct(product);
      //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                       content: Text('Added to Cart'),
      //                     ));
      //                   }
      //                 },
      //                 height: 80,
      //                 minWidth: MediaQuery.of(context).size.width,
      //                 child: Text(
      //                   'Add to cart',
      //                   style: TextStyle(
      //                     color: Colors.white,
      //                     fontSize: 20,
      //                   ),
      //                 ),
      //               ),
      //             );
      //           }),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  subtract() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  add() {
    setState(() {
      quantity++;
    });
  }
}
