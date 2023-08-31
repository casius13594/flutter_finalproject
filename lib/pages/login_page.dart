import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/forgot_password_page.dart';
import 'package:flutter_finalproject/pages/register_page.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finalproject/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('LOGIN',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                ),),
              SizedBox(height: 20,),
              SvgPicture.asset('lib/images/logo_login.svg',
                width: 300,
                height: 300,
                alignment: Alignment.topCenter,
              ),

              SizedBox(height: 10),

              Text("Welcome back",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              SizedBox(height: 20),

              //email text field
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _controllerEmail,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:  Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                      border: InputBorder.none,
                      hintText: 'Email',
                      prefixIcon: Icon(
                        Icons.mail
                      )
                  ),
                ),
                ),



              SizedBox(height: 10),
              // password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:  Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: InputBorder.none,
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock
                    )
                  ),
                ),
              ),

              SizedBox(height: 20),

              //Forgot Password
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ResetPassword()));
                        },
                        child: Text('Forget password?',
                          style: TextStyle(
                              color: Colors.grey[600]
                          ),
                        ),
                      ),
                    ],
                  ),
              ),

              SizedBox(height: 20),

              // sign in button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _controllerEmail.text,
                          password: _controllerPassword.text
                      ).then((value) {
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => shiftscreen()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()} ");
                      });
                    },

                    style: TextButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    child: Center(
                      child: Text(
                        'Sign In',
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
              SizedBox(height: 30),

              // Not a member? Register
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:  25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),

                    SizedBox(width: 5),
                    TextButton(
                       onPressed: () {
                         Navigator.push(context,
                             MaterialPageRoute(builder: (context) => RegisterPage()));
                       },
                      child: Text('Register',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
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
}
