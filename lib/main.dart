import 'package:ecommerce/Widgets/constants.dart';
import 'package:ecommerce/provider/adminMode.dart';
import 'package:ecommerce/provider/cartItem.dart';
import 'package:ecommerce/provider/favoriteItems.dart';
import 'package:ecommerce/provider/modalHud.dart';
import 'package:ecommerce/screens/Admin/AddProduct.dart';
import 'package:ecommerce/screens/Admin/AdminHome.dart';
import 'package:ecommerce/screens/User/CartScreen.dart';
import 'package:ecommerce/screens/User/FavoriteScreen.dart';
import 'package:ecommerce/screens/OTP.dart';
import 'package:ecommerce/screens/User/ProductInfoFromFav.dart';
import 'package:ecommerce/screens/Admin/ViewOrders.dart';
import 'package:ecommerce/screens/Admin/editProduct.dart';
import 'package:ecommerce/screens/Admin/manageProduct.dart';
import 'package:ecommerce/screens/User/HomePage.dart';
import 'package:ecommerce/screens/LogIn.dart';
import 'package:ecommerce/screens/SignUp.dart';
import 'package:ecommerce/screens/Admin/orderDetails.dart';
import 'package:ecommerce/screens/User/productInfo.dart';
import 'package:ecommerce/screens/verifyEmail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isUserLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return MaterialApp(home: Scaffold(body: Center(child: Text('Loading...')),),);
        }else{
          isUserLoggedIn= snapshot.data!.getBool(KKeepMeLoggedIn) ?? false;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ModalHud>(
                create: (context) => ModalHud(),
              ),
              ChangeNotifierProvider<AdminMode>(
                create: (context) => AdminMode(),
              ),
              ChangeNotifierProvider<CartItem>(
                create: (context) => CartItem(),
              ),
              ChangeNotifierProvider<AddToFavorite>(
                create: (context) => AddToFavorite(),
              ),
            ],
            child: MaterialApp(
              // initialRoute: isUserLoggedIn? 'Home' : 'login',
               initialRoute: 'Home',
              routes: {
                'login': (context) => LoginScreen(),
                'signup': (context) => SignUp(),
                'Home': (context) => HomePage(),
                'adminHome': (context) => AdminHome(),
                'AddProduct': (context) => AddProduct(),
                'manageProduct': (context) => ManageProduct(),
                'editProduct': (context) => EditProduct(),
                'productInfo': (context) => ProductInfo(),
                'cartScreen': (context) => CartScreen(),
                'ordersScreen': (context) => OrdersScreen(),
                'orderDetails': (context) => OrderDetails(),
                'favoriteScreen': (context) => FavoriteScreen(),
                'ProductInfoFromFav': (context) => ProductInfoFromFav(),
                'OTP': (context) => OTPpage(),
                'verifyPage': (context) => VerifyEmailPage(),
              },
            ),
          );
        }
    },
    );
  }
}
