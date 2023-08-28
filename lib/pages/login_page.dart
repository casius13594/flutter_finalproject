import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 25),

              Icon(
                Icons.message,
                size: 80,
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
                  ),
                ),
                ),



              SizedBox(height: 10),
              // password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
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
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal:  25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forget password?',
                        style: TextStyle(color: Colors.grey[600]),
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
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => shiftscreen())
                      );
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
                    Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      ),
                    ),

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
