import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home:MainPage(),
    );
  }
}

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage>{


  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Colors.deepPurple, Colors.lightBlue],
      ),
    ),
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Text(
            'Map Chat',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),),

          SizedBox(height: 20,),
          Lottie.asset('lib/animation/maplove.json'),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30),
                textStyle: TextStyle(fontSize: 28)
              ),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> LoginPage()));
              },
              icon: Icon(Icons.map_outlined,size:42),
              label: Text("Let's discover"))

        ],
      )
    ),
  );

}
