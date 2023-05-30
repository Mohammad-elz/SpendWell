import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Widgets/CustomTextField.dart';
import 'User/HomePage.dart';


class OTPpage extends StatefulWidget {


  @override
  State<OTPpage> createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  String verificationId='';
  final FirebaseAuth auth = FirebaseAuth.instance;
  var OTPcontroller;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: OTPcontroller,
            decoration: InputDecoration(
              hintText: 'otp'
            ),
          ),
          Material(
            elevation: 5,
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              onPressed: () async {
                // var credential = auth.signInWithCredential(
                //   PhoneAuthProvider.credential(
                //       verificationId: verificationId,
                //       smsCode: OTPcontroller)
                // );
                //
                // if(auth.currentUser != null){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => HomePage(),
                //     ),
                //   );
                // }
              },
              minWidth: MediaQuery.of(context).size.width,
              // height: 42,
              child: Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
