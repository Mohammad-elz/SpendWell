import 'package:flutter/material.dart';




class CustomTextField extends StatelessWidget {
  String hint;
  Icon? icon;
  final Function(String?) onClick;

  String _errorMessage(String str){
    switch(str){
      case 'Name' : return "Name is empty";
      case 'Email' : return "Email is empty";
      case 'Password' : return "Password is empty";
      default: return "Unknown error";
    }
  }


  CustomTextField({required this.hint, this.icon,required this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onClick,
      obscureText: hint == 'Password'? true:false,
      validator: (value){
        if(value!.isEmpty){
          return _errorMessage(hint);
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hint,
      ),
    );
  }
}