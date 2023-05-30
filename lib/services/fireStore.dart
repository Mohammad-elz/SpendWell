
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/constants.dart';
import '../models/product.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _firestore.collection(KProductCollection).add({
      KProductName: product.Pname,
      KProductPrice: product.Pprice,
      KProductDescription: product.Pdescription,
      KProductCategory: product.Pcategory,
      KProductImage: product.Pimage,
    });
  }

  deletProduct(documentID){
    _firestore.collection(KProductCollection).doc(documentID).delete();
  }

  editProduct(documentID , data){
    _firestore.collection(KProductCollection).doc(documentID).update(data);
  }

  Stream<QuerySnapshot> LoadProduct() {
    return _firestore.collection(KProductCollection).snapshots();
  }

  Stream<QuerySnapshot> LoadOrders() {
    return _firestore.collection(KOrders).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> LoadOrdersByUid(String CureentUid) {
    return _firestore.collection(KOrders).doc().collection(KOrderDetails).where(KUserId, isEqualTo: CureentUid).snapshots();
  }

  deleteOrder(documentID){
    _firestore.collection(KOrders).doc(documentID).delete();
  }



  Stream<QuerySnapshot> LoadOrderDetails(documentID) {
    return _firestore.collection(KOrders).doc(documentID).collection(KOrderDetails).snapshots();
  }

  StoreOrders(data,List<Product> products){
    var documentRef = _firestore.collection(KOrders).doc();
    documentRef.set(data);
    for(var product in products){
      documentRef.collection(KOrderDetails).doc().set(
        {
          KProductName : product.Pname,
          KProductPrice : product.Pprice,
          KProductDescription : product.Pdescription,
          KProductQuantity : product.Pquantity,
          KProductCategory : product.Pcategory,
          KProductImage : product.Pimage
        }
      );
    }
  }
}
