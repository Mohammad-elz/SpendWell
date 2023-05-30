import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Widgets/constants.dart';
import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../services/fireStore.dart';


class OrdersScreen extends StatelessWidget {

  Store _store = Store();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('All Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _store.LoadOrders(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Center(child: Text('Loading...'));
          }else{
            List<Orders> orders = [];
            for(var doc in snapshot.data?.docs ?? []){
              var data = doc.data();
              orders.add(Orders(
                documentID: doc.id,
                address: data[KAddress],
                totalePrice: data[KToatlePrice],
                BuildingName:data[KBuildingName],
                phoneNumber:data[KBackupNumber],
              ));
            }
            return ListView.builder(
              itemBuilder: (context,index){
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, 'orderDetails',arguments: orders[index].documentID);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('ID: ${orders[index].documentID!}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
                                IconButton(
                                    onPressed: (){
                                  showCustomDialog( context,orders[index].documentID!);
                                },
                                    icon: Icon(Icons.delete,color: Colors.red,)),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text('Totale price = ${orders[index].totalePrice.toString()} \$',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text('Phone: ${orders[index].phoneNumber}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          ],),
                      ),
                    ),
                  ),
                );
              },
              itemCount: orders.length,
            );
          }
        },
      ),
    );
  }

  Future <void> showCustomDialog(BuildContext context,String documentID) {
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
              Text('Are you sure you want to delete this order?',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: (){
                        _store.deleteOrder(documentID);
                        Navigator.pop(context);
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

}
