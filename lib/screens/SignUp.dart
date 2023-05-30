import 'package:ecommerce/screens/OTP.dart';
import 'package:ecommerce/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/CustomTextField.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../provider/modalHud.dart';


class SignUp extends StatelessWidget {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  late final String _email , _password;
  final _auth = Auth();

  final FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ModalProgressHUD(
            inAsyncCall: Provider.of<ModalHud>(context).isLoading,
            child: Form(
              key: _globalKey,
              child: ListView(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(top: height*.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'images/icons/image2.png',
                          height: height*.15,
                        ),
                        Text('CashOnDelivery',style: TextStyle(
                          fontSize: 35,
                        ),),
                        SizedBox(height: height*.05),
                        CustomTextField(
                          onClick: (value){},
                            hint: 'Name',
                            icon: Icon(Icons.person,color: Colors.blue[900],
                            ),
                        ),
                        SizedBox(height: height*.02),
                        CustomTextField(
                          onClick: (value){
                            _email = value!;
                          },
                            hint: 'Email',
                            icon: Icon(Icons.email,color: Colors.blue[900],),
                        ),

                        SizedBox(height: height*.02),
                        CustomTextField(
                          onClick: (value){
                            _password = value!;
                          },
                            hint: 'Password',
                            icon: Icon(Icons.password,color: Colors.blue[900]),
                        ),
                        SizedBox(height: height*.02),
                        CustomTextField(
                          onClick: (value) {

                          },
                          hint: 'Phone',
                          icon: Icon(
                            Icons.email,
                            color: Colors.blue[900],
                          ),
                        ),
                        SizedBox(height: height*.02),
                        Material(
                          elevation: 5,
                          color: Colors.blue[900],
                          borderRadius: BorderRadius.circular(10),
                          child: Builder(
                            builder: (context) {
                              return MaterialButton(
                                onPressed: ()async{
                                  final modelhud = Provider.of<ModalHud>(context,listen: false);
                                  modelhud.ChangeisLoading(true);

                                  if(_globalKey.currentState!.validate()){
                                    _globalKey.currentState!.save();
                                    try {
                                      final authResult = await _auth.SignUp(_email.trim(), _password.trim());
                                      modelhud.ChangeisLoading(false);
                                      Navigator.pushNamed(context, 'verifyPage');
                                      // bool isEmailVerified = false;
                                      // isEmailVerified = auth.currentUser!.emailVerified;
                                      // if(isEmailVerified) {
                                      //   Navigator.pushNamed(
                                      //       context, 'Home');
                                      // }else{
                                      //   Navigator.pushNamed(
                                      //       context, 'verifyPage');
                                      // }
                                      print(authResult.user?.uid);
                                    }
                                    on FirebaseAuthException catch(e){
                                      modelhud.ChangeisLoading(false);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(e.message!),
                                      ));
                                    }
                                  }
                                  modelhud.ChangeisLoading(false);


                                  // await auth.verifyPhoneNumber(
                                  //   phoneNumber: '+22233333333',
                                  //   verificationCompleted: (PhoneAuthCredential credential) {},
                                  //   verificationFailed: (FirebaseAuthException e) {
                                  //     Text('$e');
                                  //   },
                                  //   codeSent: (String Id, int? resendToken) {
                                  //     verificationId = Id;
                                  //     // Navigator.push(
                                  //     //   context,
                                  //     //   MaterialPageRoute(
                                  //     //     builder: (context) => OTPpage(verificationId: verificationId),
                                  //     //   ),
                                  //     // );
                                  //   },
                                  //   codeAutoRetrievalTimeout: (String Id) {
                                  //     verificationId = Id;
                                  //   },
                                  // );
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => OTPpage(),
                                  //   ),
                                  // );

                                },
                                minWidth: MediaQuery.of(context).size.width,
                                height: 42,
                                child: Text('Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),),
                              );
                            }
                          ),
                        ),
                        SizedBox(height: height * .05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Do you have an account?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: height*.01),
                            GestureDetector(
                              onTap: (){
                                // Navigator.pop(context, 'login');
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}





