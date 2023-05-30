import 'dart:async';
import 'package:ecommerce/screens/User/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;


  @override
  void initState() {
    super.initState();

    isEmailVerified = auth.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendEmailVerification();
    }
    timer = Timer.periodic(
      Duration(seconds: 3),
        (_)=>chechEmailVerification(),
    );
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>isEmailVerified?HomePage():Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue[900],
      title: Center(child: Text('verify Email')),
    ),
    body: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Text('A verification email has been sent to your email.',style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),),
          SizedBox(height: 15,),
          Material(
            elevation: 5,
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              onPressed: () {
                  if(canResendEmail){
                    sendEmailVerification();
                  }
              },
              minWidth: MediaQuery.of(context).size.width/1.5,
              // height: 42,
              child: Text(
                'Resent Email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 15,),
          Material(
            elevation: 5,
            color: Colors.blue[900],
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              onPressed: () {
                auth.signOut();
              },
              minWidth: MediaQuery.of(context).size.width/1.5,
              // height: 42,
              child: Text(
                'Cancel',
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

  void sendEmailVerification() async{
    try {
      final user = auth.currentUser;
      await user?.sendEmailVerification();

      setState(() {
      canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        canResendEmail = true;
      });

    }catch(e){
      print(e.toString());
    }
  }

  Future chechEmailVerification() async{
    await auth.currentUser!.reload();
    setState(() {
      isEmailVerified = auth.currentUser!.emailVerified;
    });
    if(isEmailVerified){
      timer?.cancel();
    }

  }
  }

