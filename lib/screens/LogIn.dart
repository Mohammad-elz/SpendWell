import 'package:ecommerce/Widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../Widgets/CustomTextField.dart';
import '../provider/adminMode.dart';
import '../provider/modalHud.dart';
import '../services/auth.dart';
import 'SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  late String _email, _password;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final _auth = Auth();

  bool isAdmin = false;
  bool value = false;

  String adminPass= 'admin123';
  String adminEmail = 'admin123@gmail.com';

  bool keepMeLoggedIn = false;

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
                  padding: EdgeInsets.only(top: height * .14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'images/icons/image2.png',
                        height: height * .15,
                      ),
                      Text(
                        'CashOnDelivery',
                        style: TextStyle(
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: height * .05),
                      CustomTextField(
                        onClick: (value) {
                          _email = value!;
                        },
                        hint: 'Email',
                        icon: Icon(
                          Icons.email,
                          color: Colors.blue[900],
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: keepMeLoggedIn,
                            onChanged: (value){
                              setState(() {
                              keepMeLoggedIn=value!;
                              });
                            },
                          ),
                          Text('Remember Me'),
                        ],
                      ),
                      CustomTextField(
                        onClick: (value) {
                          _password = value!;
                        },
                        hint: 'Password',
                        icon: Icon(
                          Icons.password,
                          color: Colors.blue[900],
                        ),
                      ),
                      SizedBox(height: height * .02),
                      Material(
                        elevation: 5,
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10),
                        child: MaterialButton(
                          onPressed: () {
                            if(keepMeLoggedIn == true){
                              KeepUserLoggedIn();
                            }
                            validate(context);
                            },
                          minWidth: MediaQuery.of(context).size.width,
                          // height: 42,
                          child: Text(
                            'Log in',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: height * .01),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new SignUp()));
                            },
                            child: Text(
                              'SignUp',
                              style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('I am an admin',style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                            Switch(
                              value: value,
                              onChanged: (onChanged){
                                setState(() {
                                  value=onChanged;
                                });
                                Provider.of<AdminMode>(context, listen: false).ChangeisAdmin(value);
                                isAdmin = Provider.of<AdminMode>(context,listen: false).isAdmin;
                                print(isAdmin);
                              },
                            ),
                          ],
                        ),
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

  void validate(BuildContext context) async {
    final modelhud = Provider.of<ModalHud>(context, listen: false);
    modelhud.ChangeisLoading(true);
    if (_globalKey.currentState!.validate()) {
      _globalKey.currentState!.save();
      if (Provider.of<AdminMode>(context,listen: false).isAdmin) {
        if( _email == adminEmail || _password == adminPass) {
          try {
            final authResult = await _auth.SignIn(
                _email, _password);
            modelhud.ChangeisLoading(false);
            Navigator.pushNamed(context, 'adminHome');
            // print(authResult.user?.uid);
          } on FirebaseAuthException catch (e) {
            modelhud.ChangeisLoading(false);
            print(e.toString());
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message!),
                ));
          }
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('You are not an admin'),
              ));
        }
      }else
      if (Provider.of<AdminMode>(context,listen: false).isAdmin == false) {
        if( _email == adminEmail || _password == adminPass) {
          try {
            final authResult = await _auth.SignIn(
                _email, _password);
            modelhud.ChangeisLoading(false);
            Navigator.pushNamed(context, 'Home');
            // print(authResult.user?.uid);
          } on FirebaseAuthException catch (e) {
            modelhud.ChangeisLoading(false);
            print(e.toString());
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(e.message!),
                ));
          }
        }
      else {
        try {
          final authResult = await _auth.SignIn(_email, _password);
          modelhud.ChangeisLoading(false);

          bool isEmailVerified = false;
          isEmailVerified = auth.currentUser!.emailVerified;
          if(isEmailVerified) {
            Navigator.pushNamed(
                context, 'Home');
          }else{
            Navigator.pushNamed(
                context, 'verifyPage');
          }

          // Navigator.pushNamed(context, 'Home');
          // print(authResult.user?.uid);
        } on FirebaseAuthException catch (e) {
          modelhud.ChangeisLoading(false);
          print(e.toString());
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message!),
              ));
        }
      }}
    }
    modelhud.ChangeisLoading(false);
  }

  void KeepUserLoggedIn() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(KKeepMeLoggedIn, keepMeLoggedIn);
  }
}
