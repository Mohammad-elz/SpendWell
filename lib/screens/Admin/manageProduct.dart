import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/customMenu.dart';
import '../../functions.dart';
import '../../models/product.dart';
import '../../services/fireStore.dart';

class ManageProduct extends StatefulWidget {
  const ManageProduct({Key? key}) : super(key: key);

  @override
  State<ManageProduct> createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  int tabBarIndex =0;
  int BottomBarIndex =0;
  final _store = Store();
  List<Product> _products = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: Colors.blue,
                  onTap: (value){
                    setState(() {
                      tabBarIndex = value;
                    });
                  },
                  tabs: [
                    Text(
                      'jackets',
                      style: TextStyle(
                        color: tabBarIndex == 0 ? Colors.black : Colors.blue,
                        fontSize: tabBarIndex == 0 ? 17 : 14,
                      ),
                    ),
                    Text(
                      'trousers',
                      style: TextStyle(
                        color: tabBarIndex == 1 ? Colors.black : Colors.blue,
                        fontSize: tabBarIndex == 1 ? 17 : 14,
                      ),
                    ),
                    Text(
                      'T-shirts',
                      style: TextStyle(
                        color: tabBarIndex == 2 ? Colors.black : Colors.blue,
                        fontSize: tabBarIndex == 2 ? 17 : 14,
                      ),
                    ),
                    Text(
                      'shoes',
                      style: TextStyle(
                        color: tabBarIndex == 3 ? Colors.black : Colors.blue,
                        fontSize: tabBarIndex == 3 ? 17 : 14,
                      ),
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  JacketView(),
                  ProductsViewAdmin(KTrousers,_products),
                  ProductsViewAdmin(KTshirts,_products),
                  ProductsViewAdmin(KShoes,_products),
                ],
              ),
            )),
        Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height*.09,
              child: Row(
                children: [
                  IconButton(
                      onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_sharp),
                  ),
                  Text('Go Back',style: TextStyle(
                    fontSize: 20,
                  ),),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget JacketView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _store.LoadProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product> products = [];
          for (var doc in snapshot.data?.docs ?? []) {
            var data = doc.data();
            products.add(Product(
              Pid: doc.id,
              Pname: data[KProductName],
              Pprice: data[KProductPrice],
              Pdescription: data[KProductDescription],
              Pcategory: data[KProductCategory],
              Pimage: data[KProductImage],
            ));
          }
          _products = [...products];
          products.clear();
          products = getProductByCategory(KJackets,_products);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              child: GestureDetector(
                onTapUp: (details){
                  double dx = details.globalPosition.dx;
                  double dy = details.globalPosition.dy;
                  double dx2 = MediaQuery.of(context).size.width - dx;
                  double dy2 = MediaQuery.of(context).size.height - dy;
                  showMenu(context: context, position: RelativeRect.fromLTRB(dx, dy, dx2, dy2), items: [
                    MyPopupMenuItem(
                      onClick: (){
                        Navigator.pop(context);
                        Navigator.pushNamed(context, 'editProduct',arguments: products[index]);
                      },
                      child: Text('Edit'),
                    ),
                    MyPopupMenuItem(
                      onClick: (){
                        _store.deletProduct(products[index].Pid);
                        Navigator.pop(context);
                      },
                      child: Text('Delete'),
                    ),
                  ]);
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
        } else {
          return Center(child: Text('loading'));
        }
      },
    );
  }

  Widget ProductsViewAdmin(String pCategory,List<Product> allProducts) {
    List<Product> products ;
    products = getProductByCategory(pCategory,allProducts);
    return GridView.builder(
      gridDelegate:
      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        child: GestureDetector(
          onTapUp: (details){
            double dx = details.globalPosition.dx;
            double dy = details.globalPosition.dy;
            double dx2 = MediaQuery.of(context).size.width - dx;
            double dy2 = MediaQuery.of(context).size.height - dy;
            showMenu(context: context, position: RelativeRect.fromLTRB(dx, dy, dx2, dy2), items: [
              MyPopupMenuItem(
                onClick: (){
                  Navigator.pop(context);
                  Navigator.pushNamed(context, 'editProduct',arguments: products[index]);
                },
                child: Text('Edit'),
              ),
              MyPopupMenuItem(
                onClick: (){
                  _store.deletProduct(products[index].Pid);
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ]);
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
}


