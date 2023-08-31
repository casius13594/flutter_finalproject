import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:flutter_finalproject/pages/register_page.dart';
import 'package:pinput/pinput.dart';

class PhoneVerify extends StatefulWidget{
  String email ="";
  String password = "";
  PhoneVerify();
  PhoneVerify.withData(this.email, this.password);
  @override
  State<StatefulWidget> createState() => _PhoneVerifyState(email, password);


}

class _PhoneVerifyState extends State<PhoneVerify>{
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email1 = "";
  String password1 = "";
  _PhoneVerifyState(String emailSet, String passwordSet){
    email1 = emailSet;
    password1 = passwordSet;
  }
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 30,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(71, 241, 149, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(71, 241, 149, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(71, 241, 149, 1),
      ),
    );
    var code = "";

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/phone_verify_page_bg.jpg'),
          fit:BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(horizontal: 5),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  Text(
                    'Phone Verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  55,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 50,),

                  SizedBox(
                    height: 300,
                    width: 330,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.greenAccent,
                              offset: const Offset(5.0, 5.0),
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.white,
                              offset: const Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage('lib/images/phone_verify_lg.jpg'),
                          fit:BoxFit.cover,
                        )
                      ),
                    ),
                  ),


                  SizedBox(height: 50,),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    onCompleted: (pin) => print(pin),
                    onChanged: (value){
                      code = value;
                    },
                  ),

                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () async {

                            PhoneAuthCredential credential = PhoneAuthProvider
                                .credential(verificationId: RegisterPage.verify, smsCode: code);
                            await auth.signInWithCredential(credential);
                            FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: email1,
                                password: password1
                            ).then((value) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LoginPage()));
                            }).onError((error, stackTrace) {
                              print("Error ${error.toString()} ");
                            });
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.pink[200],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        child: Center(
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

}