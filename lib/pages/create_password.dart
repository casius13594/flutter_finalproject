import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatePasswordPage extends StatefulWidget {
  const CreatePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _controllerPasswordGoogle = TextEditingController();
  bool _passwordValidateGoogle = false;

  @override
  Widget build (BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Create Password'),
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
              color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Password
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Your account password',
                      style: TextStyle(
                        fontSize:  20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: _controllerPasswordGoogle,
                    obscureText: true,
                    decoration: InputDecoration(
                        errorText: _passwordValidateGoogle ? 'Password length must be at least 6 characters' : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(width: 2),
                        ),
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )
                    ),
                  ),
                  SizedBox(height: 10,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                      child: Text(
                        'Note: This password can be used to sign in via email.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize:  15,

                        ),
                      )
                  ),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.topRight,
                      child:Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.arrow_circle_right),
                            label: Text("Finish"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                              fixedSize: Size(100, 50),
                            ),
                            onPressed: () async {
                              setState(() {
                                _controllerPasswordGoogle.text.length < 6 ?
                                _passwordValidateGoogle = true :
                                _passwordValidateGoogle = false;
                              });
                              if (!_passwordValidateGoogle) {
                                try {
                                  await FirebaseAuth.instance.currentUser!
                                      .linkWithCredential(
                                      EmailAuthProvider.credential(
                                          email: FirebaseAuth.instance
                                              .currentUser!.email.toString(),
                                          password: _controllerPasswordGoogle
                                              .text.trim())
                                  ).then((value) {
                                    Navigator.push(
                                        context, MaterialPageRoute(
                                        builder: (context) => shiftscreen()));
                                  });
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                      msg: "Error linking credentials: ${e.message.toString()}");
                                }
                              }
                            }
                          )
                      )
                  )

                ],
            ),
          ),
        ),
    );
  }
}