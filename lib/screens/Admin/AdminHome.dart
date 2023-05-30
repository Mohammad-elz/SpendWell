import 'package:flutter/material.dart';



class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('Admin Home'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Material(
              elevation: 5,
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(10),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'AddProduct');
                },
                minWidth: MediaQuery.of(context).size.width/1.5,
                child: Text(
                  'Add Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Material(
              elevation: 5,
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(10),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'manageProduct');
                },
                minWidth: MediaQuery.of(context).size.width/1.5,
                child: Text(
                  'Manage Product',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Material(
              elevation: 5,
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(10),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ordersScreen');
                },
                minWidth: MediaQuery.of(context).size.width/1.5,
                child: Text(
                  'View Orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
