import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/login_page.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Switch to dark/light theme
  static ValueNotifier<bool> switcher = ValueNotifier(false);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: switcher,
      builder: (context, bool newvalue, child){
        return MaterialApp(
          theme: newvalue? _dark : _light,
          debugShowCheckedModeBanner: false,

          home:MainPage(),
        );
      },
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
        gradient: RadialGradient(
          colors: [Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.tertiaryContainer],
          radius: 1.2,
        )
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
              color: Theme.of(context).colorScheme.onError,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),),

          SizedBox(height: 20,),
          Lottie.asset('lib/animation/maplove.json'),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                padding: EdgeInsets.symmetric(horizontal: 30),
                textStyle: TextStyle(fontSize: 28),
              ),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=> LoginPage()));
              },
              icon: Icon(Icons.map_outlined,size:42, color: Theme.of(context).colorScheme.onBackground),
              label: Text("Let's discover",style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiaryContainer
              ),))
        ],
      )
    ),
  );

}


ThemeData _dark = ThemeData( brightness: Brightness.dark,
    colorScheme:  ColorScheme.dark(
      primary: Color(0xff66e04b)!,
      onPrimary: Color(0xff003a00)!,
      primaryContainer: Color(0xFF005300)!,
      onPrimaryContainer: Color(0xFFbdf1a9)!,
      secondary: Color(0xffbbcbb1)!,
      onSecondary: Color(0xff263421)!,
      secondaryContainer: Color(0xff3d4b37)!,
      onSecondaryContainer: Color(0xffd7e7cc)!,
      tertiary: Color(0xFFa0cfd1)!,
      onTertiary: Color(0xFF003739)!,
      tertiaryContainer: Color(0xFF1e4e50)!,
      onTertiaryContainer: Color(0xFFbcebee)!,
      error: Color(0xFFffb4a9)!,
      onError: Color(0xFF680003)!,
      errorContainer: Color(0xff930006)!,
      onErrorContainer: Color(0xFFffb4a9)!,
      background: Color(0xFF051F23)!,
      onBackground: Color(0xFFD7E7CC)!,
      surface:  Color(0xFF7A2558)!,
      onSurface: Color(0xFFEC43A8)!,
      onSurfaceVariant: Color(0xFFD9E2FF)!,
      surfaceVariant:Color(0xFF525e7d)! ,
    )
);


ThemeData _light = ThemeData(brightness: Brightness.light,
    colorScheme:  ColorScheme.light(
      primary: Color(0xff006874)!,
      onPrimary: Color(0xFFFFFFFF)!,
      primaryContainer: Color(0xFF90f1ff)!,
      onPrimaryContainer: Color(0xFF001f24)!,
      secondary: Color(0xffa46367)!,
      onSecondary: Color(0xFFFFFFF)!,
      secondaryContainer: Color(0xffcde7ec)!,
      onSecondaryContainer: Color(0xff051f23)!,
      tertiary: Color(0xFF525e7d)!,
      onTertiary: Color(0xFFFFFFFF)!,
      tertiaryContainer: Color(0xFFD9E2FF)!,
      onTertiaryContainer: Color(0xFF0e1a37)!,
      error: Color(0xFFBA1B1B)!,
      onError: Color(0xFFffffff)!,
      errorContainer: Color(0xffffdad4)!,
      onErrorContainer: Color(0xff400001)!,
      background: Color(0xFFD7E7CC)!,
      onBackground: Color(0xFF051F23)!,
      surface:  Color(0xFFF696D2)!,
      onSurface: Color(0xFF591C40)!,
      onSurfaceVariant: Color(0xFF525e7d)!,
      surfaceVariant: Color(0xFFD9E2FF)!,
    )
);