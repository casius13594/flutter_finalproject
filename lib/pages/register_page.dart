import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/phoneVerify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({Key? key}) : super(key:key);
  static String verify="";
  @override
  State<StatefulWidget> createState() => _RegisterPageState();

}

class _RegisterPageState extends State<RegisterPage>{
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhoneNum = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _nameValidate = false;
  bool _phoneValidate = false;
  bool _emailValidate = false;
  bool _addressValidate = false;
  bool _passwordValidate = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/register_background.jpg'),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100,),
                Text(
                  'Create \nAccount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:  55,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 50,),

                //Full name
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Full Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _controllerName,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      errorText: _nameValidate ? 'Value Can\'t Be Empty' : null,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.white,
                          width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black,
                          width: 2),
                    ),
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                ),

                SizedBox(height: 20,),
                //Your phone
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Your Phone Number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _controllerPhoneNum,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      errorText: _phoneValidate ? 'Value Can\'t Be Empty' : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black,
                            width: 2),
                      ),
                      hintText: 'Phone',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 20,),
                // Email
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _controllerEmail,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      errorText: _emailValidate ? 'Value Can\'t Be Empty' : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black,
                            width: 2),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 20,),
                //Address
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _controllerAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      errorText: _addressValidate ? 'Value Can\'t Be Empty' : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black,
                            width: 2),
                      ),
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 20,),
                //Password
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:  20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      errorText: _passwordValidate ? 'Value Can\'t Be Empty' : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white,
                            width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black,
                            width: 2),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),

                SizedBox(height: 20,),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                    Align(
                    alignment: Alignment.centerRight, // Align the button to the right
                      child:Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: _controllerPhoneNum.text,
                                verificationCompleted: (PhoneAuthCredential credential){},
                                verificationFailed: (FirebaseAuthException e) {},
                                codeSent: (String verificationID, int? resendToken) {
                                  RegisterPage.verify = verificationID;
                                  
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          PhoneVerify.withData(_controllerEmail.text,_controllerPassword.text)));
                                },
                                codeAutoRetrievalTimeout: (String verificationID) {},
                              );


                            },
                            icon: Icon(Icons.arrow_circle_right),
                            label: Text("Let's sign up"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                              fixedSize: Size(150, 50),
                              shadowColor: Colors.black,
                              side: BorderSide(color: Colors.black45, width: 2),
                              primary: Colors.pink[200],
                            ),
                          ),
                      ),
                    ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }

}