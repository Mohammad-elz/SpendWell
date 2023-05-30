import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/constants.dart';
import '../../Widgets/productView.dart';
import '../../functions.dart';
import '../../models/product.dart';
import '../../services/fireStore.dart';
import 'package:firebase_auth/firebase_auth.dart';




class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = Auth();
  int tabBarIndex =0;
  int BottomBarIndex =0;
  final _store = Store();
  List<Product> _products = [];
  late User _loggedUser;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: Colors.grey[200],
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 30,
                type: BottomNavigationBarType.fixed,
                currentIndex: BottomBarIndex,
                fixedColor: Colors.blue,
                onTap: (value) async {
                  if(value == 0) {
                    String x;
                    x= await getCurrentUid();
                    print(x);
                  }
                  if(value ==1){
                    Navigator.pushNamed(context, 'favoriteScreen');
                  }else
                  if (value == 2) {
                    showCustomDialog(context,value);
                  } else{
                    setState(() {
                      BottomBarIndex = value;
                    });
                  }
                },

                items: [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(Icons.home),
                  ),
                  BottomNavigationBarItem(
                    label: 'Favorite',
                    icon: Icon(Icons.favorite_border),
                  ),
                  BottomNavigationBarItem(
                    label: 'Sign Out',
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
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
                  ProductsView(KTrousers,_products),
                  ProductsView(KTshirts,_products),
                  ProductsView(KShoes,_products),
                ],
              ),
            )),
        Material(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              height: MediaQuery.of(context).size.height*.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Text('Explore',style: TextStyle(
                  fontSize: 25,
                ),),
                GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'cartScreen');
                    },
                    child: Icon(Icons.shopping_cart_sharp)),
              ],),
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
        } else {
          return Center(child: Text('loading'));
        }
      },
    );
  }

  Future<void> _clearPreferencesAndSignOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await _auth.SignOut();
  }

  Future <void> showCustomDialog(BuildContext context,int value) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Are you sure you want to SignOut?',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: (){
                          _clearPreferencesAndSignOut().then((_) {
                            setState(() {
                              BottomBarIndex = value;
                            });
                            Navigator.popAndPushNamed(context, 'login');
                          });
                        },
                        child: Text('Yes'),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.blue[700]),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.black),
                                )
                            ))
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.blue[700]),
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(color: Colors.black),
                                )
                            ))
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
    );
  }


  @override
  void initState(){
     getCurrentUser();
    SaveCurrentUid();
  }

   getCurrentUser() async{
    _loggedUser = (await _auth.getUser())!;
   }

  void SaveCurrentUid() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(KUserId, _loggedUser.uid);
  }


  Future<String> getCurrentUid() async{
    String CurrentUid;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CurrentUid = preferences.getString(KUserId)!;
    return CurrentUid;
  }


}







