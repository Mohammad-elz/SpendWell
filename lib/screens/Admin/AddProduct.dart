import 'package:flutter/material.dart';
import '../../Widgets/CustomTextField.dart';
import '../../models/product.dart';
import '../../services/fireStore.dart';

class AddProduct extends StatelessWidget {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late String name, price, description, category, imageLocation;
  final _store = Store();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text('Add Product'),
      ),
      backgroundColor: Colors.blue[200],
      body: Form(
        key: _globalKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                hint: 'Product Name',
                onClick: (value) {
                  name = value!;
                },
              ),
              SizedBox(height: height * .02),
              CustomTextField(
                hint: 'Product Price',
                onClick: (value) {
                  price = value!;
                },
              ),
              SizedBox(height: height * .02),
              CustomTextField(
                hint: 'Product Description',
                onClick: (value) {
                  description = value!;
                },
              ),
              SizedBox(height: height * .02),
              CustomTextField(
                hint: 'Product Category',
                onClick: (value) {
                  category = value!;
                },
              ),
              SizedBox(height: height * .02),
              CustomTextField(
                hint: 'Product Image',
                onClick: (value) {
                  imageLocation = value!;
                },
              ),
              SizedBox(height: height * .02),
              TextButton(
                  onPressed: () async{
                    try{
                    if(_globalKey.currentState!.validate()){
                      _globalKey.currentState!.save();
                      await _store.addProduct(Product(
                        Pname: name,
                        Pprice: price,
                        Pdescription: description,
                        Pcategory: category,
                        Pimage: imageLocation,
                      ));
                    }
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Text('Add product',style: TextStyle(fontSize: 20),),
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(300, 50)),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[900]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        // side: BorderSide(color: Colors.white),
                      )))),
            ],
          ),
        ),
      ),
    );
  }
}
