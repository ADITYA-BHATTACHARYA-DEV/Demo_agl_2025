import 'package:flutter/material.dart';


void main()
{
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override

  Widget build(BuildContext context)
  {
    return MaterialApp(home: Scaffold(
       appBar: AppBar(
        title: Text('AGL Demo Quiz APP 2025 ')
       ),
       body: MyHomePage(),

    ),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
{
  bool showImage = false;
  @override
 
    Widget build(BuildContext context)
    {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('My Name Is', style: TextStyle(fontSize:24 )),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            setState((){
              showImage= !showImage;
            },);
          }, child: Text('Show Picture'),
          ),
          SizedBox(height:20),
          if (showImage)
          Image.network('https://docs.automotivelinux.org/en/salmon/img/agl.png', height: 400),

        ],

      ),);
    }
  }
