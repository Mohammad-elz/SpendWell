import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Widgets/constants.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../services/fireStore.dart';


class OrderDetails extends StatelessWidget {
  const OrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String documentID = ModalRoute.of(context)?.settings.arguments as String;
    Store _store = Store();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('Order Details'),
      ),
      body: Material(
        color: Colors.grey[300],
        child: StreamBuilder<QuerySnapshot>(
          stream: _store.LoadOrderDetails(documentID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products = [];
              for (var doc in snapshot.data?.docs ?? []) {
                var data = doc.data();
                products.add(Product(
                    Pname: data[KProductName],
                    Pprice: data[KProductPrice],
                    Pdescription: data[KProductDescription],
                    Pcategory: data[KProductCategory],
                    Pquantity: data[KProductQuantity],
                    Pimage: data[KProductImage]));
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
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
                    ],
                  );
                },
                itemCount: products.length,
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading order details'));
            } else {
              return Center(child: Text('Loading order details'));
            }
          },
        ),
      ),
    );
  }
}

