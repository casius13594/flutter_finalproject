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
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
              radius: 0.78,
              focal: Alignment(-0.02, 2.5),
              tileMode: TileMode.mirror,
              colors: [Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.onTertiary]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('LOGIN',
                  style: TextStyle(
                    fontSize: 40,
                    color:Theme.of(context).colorScheme.onPrimaryContainer,
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
                      color:Theme.of(context).colorScheme.onPrimaryContainer
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
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground,),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            fillColor: Theme.of(context).colorScheme.secondary,
                            filled: true,
                            border: InputBorder.none,
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground,),
                            prefixIcon: Icon(
                                Icons.mail,
                              color: Theme.of(context).colorScheme.onBackground,
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
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.background,
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground,),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onBackground,),
                      prefixIcon: Icon(
                        Icons.lock,color: Theme.of(context).colorScheme.onBackground
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
                              color: Theme.of(context).colorScheme.error,
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
                          backgroundColor:  Theme.of(context).colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                      ),
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color:  Theme.of(context).colorScheme.tertiaryContainer,
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
                        style: TextStyle(
                          color:  Theme.of(context).colorScheme.onPrimaryContainer,),
                      ),

                      SizedBox(width: 5),
                      TextButton(
                         onPressed: () {
                           Navigator.push(context,
                               MaterialPageRoute(builder: (context) => RegisterPage()));
                         },
                        child: Text('Register',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
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
      ),
    );
  }
}
