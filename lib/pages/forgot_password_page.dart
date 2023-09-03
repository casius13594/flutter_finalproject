import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_finalproject/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ResetPasswordState();

}

class _ResetPasswordState extends State<ResetPassword>{
  final formKey = GlobalKey<FormState>();
  final _emailController =TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold (
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Reset Password'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Receive an email to\nreset your password.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email! != null && !EmailValidator.validate(email)
              ? 'Enter a valid email'
              : null,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.email_outlined),
              label: Text(
                'Reset Password',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {resetPassword();},
            )
          ],
        ),
      ),
    ),
  );

  Future resetPassword() async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));
    try{
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Fluttertoast.showToast(msg: 'Password Reset Email Sent');
      Navigator.of(context).popUntil((route) => route.isActive);
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.message.toString());
      Navigator.of(context).pop();
    }

  }
}
  //   return Container(
  //     decoration: BoxDecoration(
  //         gradient: RadialGradient(
  //             radius: 0.78,
  //             focal: Alignment(0.7, -0.7),
  //             tileMode: TileMode.mirror,
  //             colors: [Theme.of(context).colorScheme.tertiary,
  //               Theme.of(context).colorScheme.onTertiary]
  //         )
  //     ),
  //     child: Scaffold(
  //         backgroundColor:Colors.transparent,
  //         extendBodyBehindAppBar: true,
  //         appBar: AppBar(
  //           backgroundColor: Colors.transparent,
  //           elevation: 0,
  //         ),
  //         body: SingleChildScrollView(
  //           child: Container(
  //             margin: EdgeInsets.symmetric(horizontal: 20),
  //             padding: EdgeInsets.symmetric(horizontal: 5),
  //
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 150,),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 20),
  //                   child: Text(
  //                     'Reset \nPassword',
  //                     style: TextStyle(
  //                       color: Theme.of(context).colorScheme.onTertiaryContainer,
  //                       fontSize:  55,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //
  //                 SizedBox(height: 100,),
  //
  //                 //Email
  //                 Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 10),
  //                   child: Text(
  //                     'Email',
  //                     style: TextStyle(
  //                       color: Theme.of(context).colorScheme.onTertiaryContainer,
  //                       fontSize:  20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 5,),
  //                 TextField(
  //                   style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
  //                   decoration: InputDecoration(
  //
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                             width: 2),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface,
  //                             width: 2),
  //                       ),
  //                       fillColor: Theme.of(context).colorScheme.tertiaryContainer,
  //                       hintText: 'Email',
  //                       hintStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                       )
  //                   ),
  //                 ),
  //
  //                 SizedBox(height: 20,),
  //
  //                 // N
  //                 Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 10),
  //                   child: Text(
  //                     'New Password',
  //                     style: TextStyle(
  //                       color: Theme.of(context).colorScheme.onTertiaryContainer,
  //                       fontSize:  20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 5,),
  //                 TextField(
  //                   style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer,),
  //                   decoration: InputDecoration(
  //
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                             width: 2),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface,
  //                             width: 2),
  //                       ),
  //                       fillColor: Theme.of(context).colorScheme.tertiaryContainer,
  //                       hintText: 'New Password',
  //                       hintStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                       )
  //                   ),
  //                 ),
  //
  //                 SizedBox(height: 20,),
  //                 //Address
  //                 Container(
  //                   margin: EdgeInsets.symmetric(horizontal: 10),
  //                   child: Text(
  //                     'Confirm New Password',
  //                     style: TextStyle(
  //                       color:Theme.of(context).colorScheme.onTertiaryContainer,
  //                       fontSize:  20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: 5,),
  //                 TextField(
  //                   style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
  //                   decoration: InputDecoration(
  //
  //                       enabledBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer,
  //                             width: 2),
  //                       ),
  //                       focusedBorder: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                         borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface,
  //                             width: 2),
  //                       ),
  //                       fillColor: Theme.of(context).colorScheme.tertiaryContainer,
  //                       hintText: 'Confirm New Password',
  //                       hintStyle: TextStyle(color:Theme.of(context).colorScheme.onTertiaryContainer),
  //                       border: OutlineInputBorder(
  //                         borderRadius: BorderRadius.circular(20),
  //                       )
  //                   ),
  //                 ),
  //
  //
  //
  //                 SizedBox(height: 20,),
  //                 Container(
  //                   margin: EdgeInsets.only(left: 300),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Directionality(
  //                         textDirection: TextDirection.rtl,
  //                         child: ElevatedButton.icon(
  //                           onPressed: (){
  //                             Navigator.push(context,
  //                                 MaterialPageRoute(builder: (context) => PhoneVerify()));
  //                           },
  //                           icon: Icon(Icons.arrow_circle_right),
  //                           label: Text("Reset Password"),
  //                           style: ElevatedButton.styleFrom(
  //                             padding: EdgeInsets.all(5),
  //                             fixedSize: Size(150, 50),
  //                             shadowColor: Theme.of(context).colorScheme.onBackground,
  //                             side: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 2),
  //                             primary: Theme.of(context).colorScheme.onSurface,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         )
  //     ),
  //   );
  // }
