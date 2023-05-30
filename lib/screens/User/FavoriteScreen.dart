import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Widgets/customMenu.dart';
import '../../models/product.dart';
import '../../provider/favoriteItems.dart';
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<AddToFavorite>(context).FavoriteItems;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('Favorite'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constrains) {
                if (products.isNotEmpty) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                            child: GestureDetector(
                              onTapUp: (details) {
                                showCustomMenu(
                                    details, context, products[index]);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                height: MediaQuery.of(context).size.height * .15,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius:
                                      MediaQuery.of(context).size.height * .15 / 2.5,
                                      backgroundImage:
                                      AssetImage(products[index].Pimage),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  products[index].Pname,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                SizedBox(height: 30,),
                                                Text(
                                                  '${products[index].Pprice} \USD',
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    itemCount: products.length,
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('Favorite is empty.',style: TextStyle(
                          fontSize: 20,
                        ),),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCustomMenu(details, context, product) {
    double dx = details.globalPosition.dx;
    double dy = details.globalPosition.dy;
    double dx2 = MediaQuery.of(context).size.width - dx;
    double dy2 = MediaQuery.of(context).size.height - dy;
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
        items: [
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              // Navigator.pushNamed(context, 'ProductInfoFromFav',arguments: product);
              Navigator.popAndPushNamed(context, 'ProductInfoFromFav',arguments: product);
            },
            child: Text('View order'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<AddToFavorite>(context, listen: false)
                  .RemoveFromFavorite(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }
}
