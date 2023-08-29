import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/profile_edit.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Settingpage extends StatefulWidget{
  const Settingpage({super.key});

  @override
  State<StatefulWidget> createState()  => _SettingPageState();

}

class _SettingPageState extends State<Settingpage>{
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Settings',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),

      body: Stack(
          children: [
            Column(
              children:[
                Container(
                  height: height * .1,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),

                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Container(
                    height: height* .73,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50)),
                    ),

                    child: Column(
                      children: [

                        // Show profile in settings
                        Row(
                          children: [

                            Padding(
                              padding: EdgeInsets.only(left: 20,top: 20),

                              // image of profile
                              child:  CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('lib/images/image_profile.jpg'),
                                ),
                            ),

                            SizedBox(width: 40,),

                            Column(
                              children: [
                                Text(
                                  'My name',
                                style: Theme.of(context).textTheme.headlineMedium,),

                                SizedBox(height: 5,),

                                Text(
                                  'abcdzyz.@gmail.com',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),

                            SizedBox(width: 40,),

                            SizedBox(
                              // button for editing profile
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  foregroundColor: Colors.amber,
                                ),
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ProfileEditing())
                                  );
                                },
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            )

                            ],
                        ),
                    ],
                    ),
                  ),
                  ),

              ]
            ),
          ],
        ),
    );
  }


}