class Product {
  String Pname;
  String Pprice;
  String Pdescription;
  String Pcategory;
  String Pimage;
  String? Pid;
  int? Pquantity;

  Product(
      { this.Pquantity,
        this.Pid,
      required this.Pname,
      required this.Pprice,
      required this.Pdescription,
      required this.Pcategory,
      required this.Pimage});
}
