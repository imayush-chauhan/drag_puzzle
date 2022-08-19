import 'package:animated_bottom_bar/animated_bottom_bar.dart';
// import 'package:drag_puzzle/test/test.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {

  int select = 0;

  Color active = Colors.pink;
  Color inactive = Colors.black;

  List name = [
    "Home",
    "Dashboard",
    "Security",
    "Person",
  ];

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: AnimatedBottomBar(

        width: mediaQW - 30,

        iconSize: mediaQW*0.055,

        height: mediaQH*0.085,

        selectedIndex: select,

        items: [

          AnimatedBarItem(
            icon: Icon(Icons.home),
          ),

          AnimatedBarItem(
            icon: Icon(Icons.dashboard),
          ),

          AnimatedBarItem(
            icon: Icon(Icons.safety_check),
          ),

          AnimatedBarItem(
            icon: Icon(Icons.person),
          ),

        ],
        onItemSelected: (_){
          setState((){
            select = _;
          });
          // print(select);
        },
      ),
      body: Container(
        height: mediaQH,
        width: mediaQW,
        color: Colors.white.withOpacity(0.9),
        alignment: Alignment.center,
        child: Text(name[select]),
      ),
    );
  }
}
