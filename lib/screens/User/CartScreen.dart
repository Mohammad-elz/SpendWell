import 'package:ecommerce/Widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Widgets/customMenu.dart';
import '../../models/product.dart';
import '../../provider/cartItem.dart';
import '../../services/fireStore.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String CurrentUserId;

  @override
  Widget build(BuildContext context) {

    List<Product> products = Provider.of<CartItem>(context).products;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constrains) {
                if (products.isNotEmpty) {
                  return Column(
                    children: [
                      Container(
                        // height:MediaQuery.of(context).size.height*.76,
                        height: constrains.maxHeight*0.90,
                        child: ListView.builder(
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
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      right: 10),
                                                  child: Text(
                                                    'Qte: ${products[index].Pquantity}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18),
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
                        ),
                      ),
                      Container(
                        // height:MediaQuery.of(context).size.height*.08,
                        height: constrains.maxHeight*0.10,
                        child: Builder(
                            builder: (context) {
                              return Material(
                                elevation: 5,
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(10),
                                child: MaterialButton(
                                  onPressed: () async{
                                    CurrentUserId = await getCurrentUid();
                                    print(CurrentUserId);
                                    showCustomDialog(products, context,CurrentUserId);
                                  },
                                  minWidth: MediaQuery.of(context).size.width,
                                  child: Text(
                                    'Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Cart is empty',style: TextStyle(
                          fontSize: 25,
                        ),),
                        SizedBox(height: 20,),
                        SizedBox(
                          height:50,
                          width:MediaQuery.of(context).size.width/3,
                          child: TextButton(
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Text('Explore items'),
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.blue[900]),
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero,
                                        side: BorderSide(color: Colors.black),
                                      )
                                  ))
                          ),
                        ),

                      ],
                    ),
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
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
              Navigator.pushNamed(context, 'productInfo', arguments: product);
            },
            child: Text('Edit'),
          ),
          MyPopupMenuItem(
            onClick: () {
              Navigator.pop(context);
              Provider.of<CartItem>(context, listen: false)
                  .deleteProduct(product);
            },
            child: Text('Delete'),
          ),
        ]);
  }

  void showCustomDialog(List<Product> products, context,String UserId) {
    var price = getTotalePrice(products);
    var Street,Building,Phone2;
    AlertDialog alertDialog = AlertDialog(
      actions: [
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                onPressed: () {
                  if(_globalKey.currentState!.validate()) {
                    _globalKey.currentState!.save();
                    try {
                      Store _store = Store();
                      _store.StoreOrders({
                        KUserId:UserId,
                        KStreetName: Street,
                        KBuildingName: Building,
                        KBackupNumber: Phone2,
                        KToatlePrice: price,
                      }, products);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Order Successfully')));
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }else{
                    print('errorrrr');
                  };
                },
                child: Text('Confirm'),
              ),
              MaterialButton(
                onPressed: () {Navigator.pop(context);},
                child: Text('Cancel'),
              ),
            ],
          ),

        ],),

      ],
      content: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Container(
            height: 250,
            width: 150,
            child: Column(
              children: [

                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return _errorMessage('Street Name');
                    }
                  },
                  onChanged: (value) {
                    Street=value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Street Name',
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return _errorMessage('Building Name');
                    }
                  },
                  onSaved: (value) {
                    Building = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Building Name',
                  ),
                ),
                TextFormField(
                  maxLength: 8,
                  validator: (value){
                    if(value!.isEmpty){
                      return _errorMessage('Backup Phone Number');
                    }
                  },
                  onChanged: (value) {
                    // address = value;
                    Phone2 = value.toString();
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter 8-digit number',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      title: Center(child: Column(
        children: [
          Text('Totale price = ${price} \$'),
          SizedBox(height: 13,),
          Text('Enter your address'),
        ],
      )),
    );
    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  getTotalePrice(List<Product> products) {
    var price = 0;
    for (var product in products) {
      price += (product.Pquantity! * int.parse(product.Pprice))!;
    }
    return price;
  }

  String _errorMessage(String str){
    switch(str){
      case 'Street Name' : return "Street Name is empty";
      case 'Building Name' : return "Building Name is empty";
      case 'Backup Phone Number' : return "Backup Phone Number is empty";
      default: return "Unknown error";
    }
  }

  Future<String> getCurrentUid() async{
    String CurrentUid;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    CurrentUid = preferences.getString(KUserId)!;
    return CurrentUid;
  }
}
