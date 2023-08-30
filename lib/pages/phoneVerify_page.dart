import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:pinput/pinput.dart';

class PhoneVerify extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PhoneVerifyState();

}

class _PhoneVerifyState extends State<PhoneVerify>{


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
                  ),

                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage())
                          );
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