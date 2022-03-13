import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:drag_puzzle/screens/drag_puzzle.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool change = false;
  late Timer timer;

  bool newGame = false;
  bool comp = false;
  bool how = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 2700), (timer) {
      setState(() {
        change = !change;
      });
    });
  }

  // getHighScore() async {
  //   var box = await Hive.openBox('puzzle');
  //   if (box.get('hp') != null && box.get('tp') != null) {
  //     setState(() {
  //       Data.highScoreInPokemon = box.get('hp');
  //       Data.timeInPokemon = box.get('tp');
  //     });
  //   }
  //   if (box.get('he') != null && box.get('te') != null) {
  //     setState(() {
  //       Data.highScoreInPokemon = box.get('he');
  //       Data.timeInPokemon = box.get('te');
  //     });
  //   }
  //   if (box.get('hn') != null && box.get('tn') != null) {
  //     setState(() {
  //       Data.highScoreInPokemon = box.get('hn');
  //       Data.timeInPokemon = box.get('tn');
  //     });
  //   }
  // }

  // snackBar(String s) {
  //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
  //       duration: Duration(milliseconds: 2000),
  //       backgroundColor: Colors.white,
  //       padding: EdgeInsets.only(left: 25),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //       content: Text(
  //         s,
  //         style: TextStyle(
  //             color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
  //       ),
  //       behavior: SnackBarBehavior.floating));
  // }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body: AnimatedContainer(
        duration: Duration(milliseconds: 2500),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: change == false ? Alignment.topRight : Alignment.topLeft,
                end: change == false
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                stops: [
                  0,
                  change == false ? 0.4 : 0.6,
                  1
                ],
                colors: [
                  Color(0xffFFCC70),
                  Color(0xffC850C0),
                  Color(0xff4158D0),
                ])),
        child: Container(
          height: mediaQH,
          width: mediaQW,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(),
              Container(
                height: mediaQH * 0.2,
                width: mediaQW * 0.75,
                child: Card(
                  margin: EdgeInsets.all(0),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 10,
                  child: Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText("Puzzle",
                            speed: Duration(milliseconds: 450),
                            textStyle: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: Color(0xffDD2A7B),
                            )),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: mediaQH * 0.1,
              // ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    newGame = true;
                  });
                  Future.delayed(const Duration(milliseconds: 300), () {
                    setState(() {
                      newGame = false;
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return DragAndDrop();
                        },
                      ));
                    });
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height:
                  newGame == false ? mediaQH * 0.085 : mediaQH * 0.078,
                  width: newGame == false ? mediaQW * 0.5 : mediaQW * 0.45,
                  child: Card(
                    margin: EdgeInsets.all(0),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: Center(
                        child: Text(
                          "Play",
                          style: TextStyle(
                            fontSize: mediaQW * 0.053,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffDD2A7B),
                          ),
                        )),
                  ),
                ),
              ),
              Container(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     IconButton(
              //       icon: Icon(Icons.help),
              //       iconSize: 26,
              //       color: Colors.white,
              //       onPressed: () {
              //         // Navigator.push(context, MaterialPageRoute(builder: (context){
              //         //   return Help();
              //         // }));
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.star),
              //       iconSize: 26,
              //       color: Colors.white,
              //       onPressed: () {
              //         // rate();
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.share),
              //       iconSize: 25,
              //       color: Colors.white,
              //       onPressed: () {
              //         // share();
              //       },
              //     ),
              //     IconButton(
              //       icon: Icon(Icons.settings),
              //       iconSize: 25,
              //       color: Colors.white,
              //       onPressed: () {
              //         // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //         //   return Setting();
              //         // },));
              //       },
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
        // child: Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Container(
        //           height: MediaQuery.of(context).size.height*0.2,
        //           width: MediaQuery.of(context).size.width*0.75,
        //           child: Card(
        //             margin: EdgeInsets.all(0),
        //             color: Colors.white,
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(25),
        //             ),
        //             elevation: 10,
        //             child: Center(
        //               child: AnimatedTextKit(
        //                 animatedTexts: [
        //                   WavyAnimatedText("Tap & Tap",
        //                       speed: Duration(milliseconds: 450),
        //                       textStyle: GoogleFonts.lato(
        //                         fontSize: MediaQuery.of(context).size.width*0.078,
        //                         fontWeight: FontWeight.w600,
        //                         color: Color(0xffDD2A7B),
        //                       )),
        //                 ],
        //                 repeatForever: true,
        //                 isRepeatingAnimation: true,
        //               ),
        //             ),
        //           ),
        //         ),
        //         GestureDetector(
        //           onTapDown: (value){
        //             setState(() {
        //               newGame = true;
        //             });
        //           },
        //
        //           onTapUp: (value){
        //             setState(() {
        //               newGame = false;
        //               Navigator.push(context, MaterialPageRoute(builder: (context) {
        //                 return Play();
        //               },));
        //             });
        //           },
        //
        //           child: AnimatedContainer(
        //             duration: Duration(milliseconds: 200),
        //             curve: Curves.bounceInOut,
        //             height: newGame == false ? 65 : 60,
        //             width: newGame == false ? 200 : 185,
        //             child: Card(
        //               margin: EdgeInsets.all(0),
        //               color: Colors.white,
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(20),
        //               ),
        //               elevation: 10,
        //               child: Center(
        //                   child: Text("Levels",
        //                     style: TextStyle(
        //                       fontSize: 20,
        //                       fontFamily: "Source",
        //                       fontWeight: FontWeight.w600,
        //                       color: Color(0xffDD2A7B),
        //                     ),)
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Positioned(
        //       bottom: 5,
        //       right: 0,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //
        //           IconButton(
        //             icon: Icon(Icons.help),
        //             iconSize: 26,
        //             color: Colors.white,
        //             onPressed: (){
        //               // Navigator.push(context, MaterialPageRoute(builder: (context){
        //               //   return Help();
        //               // }));
        //             },
        //           ),
        //
        //           IconButton(
        //             icon: Icon(Icons.star),
        //             iconSize: 26,
        //             color: Colors.white,
        //             onPressed: (){
        //               // rate();
        //             },
        //           ),
        //
        //           IconButton(
        //             icon: Icon(Icons.share),
        //             iconSize: 25,
        //             color: Colors.white,
        //             onPressed: (){
        //               // share();
        //             },
        //           ),
        //
        //           IconButton(
        //             icon: Icon(Icons.settings),
        //             iconSize: 25,
        //             color: Colors.white,
        //             onPressed: (){
        //               // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //               //   return Setting();
        //               // },));
        //             },
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
