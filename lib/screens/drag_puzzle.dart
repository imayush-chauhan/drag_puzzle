import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drag_puzzle/ads/ads.dart';
import 'package:drag_puzzle/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DragAndDrop extends StatefulWidget {
  final int level;
  final int length;
  final int side;
  final int time;
  DragAndDrop({required this.length,required this.side,required this.time,required this.level});

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> with SingleTickerProviderStateMixin{

  Duration durationLong = const Duration(seconds: 60);
  Duration durationShort = const Duration(seconds: 30);
  Duration durationShort2 = const Duration(seconds: 6);
  Duration durationGap = const Duration(milliseconds: 1200);

  late AnimationController _controller;

  bool gap = false;
  bool win = false;
  // bool isLoading = true;

  int level = 0;

  List countContent = [
    "",
    "3",
    "2",
    "1",
    "GO",
  ];

  int count = 1;

  int length = 9;
  int side = 3;
  int totalTime = 15;
  int time = 0;
  int secondDragStart = -1;
  late Timer timer;
  late Timer timer2;
  late Timer timer3;
  late Timer timer4;

  @override
  void initState() {
    super.initState();
    level = widget.level;
    length = widget.length;
    side = widget.side;
    totalTime = widget.time;
    key = "Level_${level}";
    _controller = AnimationController(
      duration: durationLong,
      vsync: this,
    );
    _controller.repeat();
    checkConnectivity();
    Future.delayed(Duration(milliseconds: 200),(){
      if(level == 3){
        share("Please Share our puzzle game with your friends and family, if you like playing");
      }else{
        if(AdsProvider.rewardedAd == null){
          AdsProvider().createRewardedAd();
        }
        if(AdsProvider.interstitialAd == null){
          AdsProvider().createInterstitialAd();
        }else{
          AdsProvider().showInterstitialAd();
        }
      }

    });

    // _controller.addListener(() {
    //
    //
    //   // if(_controller.value > 0.1 && _controller.value < 0.75){
    //   //   setState(() {
    //   //     hmm = true;
    //   //   });
    //   // }else{
    //   //   setState(() {
    //   //     hmm = false;
    //   //   });
    //   // }
    // });

    Future.delayed(const Duration(milliseconds: 15), () {
      setState(() {
        change = true;
      });
    });

    timer = Timer.periodic(durationShort, (timer) {
      setState(() {
        change = !change;
      });
    });

    timer3 = Timer.periodic(durationGap, (timer) {
      setState(() {
        if(count < 4){
          count++;
        }else{
          count = 0;
          // remainingTime();
          timer3.cancel();
        }
      });
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      move();
      timer2 = Timer.periodic(durationShort2, (timer) {
        setState(() {
          move();
        });
      });
    });

    getUserData();
  }


  String? key;

  checkConnectivity() async{
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      if(level == 1){
        showConnectToInternet("Rearrange the different parts of image to make an actual image in given time", false);
      }
    }else{
      showConnectToInternet("Connect to Internet",true);
      print("no internet");
    }
  }

  // getData() async{
  //   if(key != null){
  //     var prefs = await SharedPreferences.getInstance();
  //     if(prefs.getStringList(key!) != null){
  //       setState(() {
  //         data = prefs.getStringList(key!)!;
  //       });
  //     }else{
  //       getUserData();
  //     }
  //   }else{
  //   }
  //
  // }

  List data = [];
  List temp = [];

  getUserData() {
    data.clear();
    FirebaseFirestore.instance
        .collection("drag_data")
        .doc("1")
        .get()
        .then((value) {
      setState(() {
        data = value.get(
          level >= 7 ? "7" :
          level >= 4 ? "4"
              : level >= 2 ? "2" : "1",
        );
        print("Success!!!");
        // changeToBase(temp);
      });
      // Future.delayed(const Duration(seconds: 3), () {
      //   // setState(() {
      //   //   isLoading = false;
      //   //   timer3.cancel();
      //   // });
      //   remainingTime();
      // });
    }).onError((error, stackTrace) {
      print("Error: $error");
    });
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }


  changeToBase(List data2) async{

    for(int i = 0; i < data2.length; i++){
      data.add(await networkImageToBase64(data2[i]));
    }

    setState(() {});

    // setData(key!, data);

  }

  // setData(String key, List<String> list) async{
  //
  //   print("In setData>>>>>>>>>>");
  //
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.remove(key).then((value) {
  //     setState(() {
  //       prefs.setStringList(key, list);
  //     });
  //   });
  //
  // }

  remainingTime(){
    timer4 = Timer.periodic(Duration(seconds: 1), (timer) {
      if(time != totalTime){
        setState(() {
          time++;
        });
      }else{
        if(win == false){
          showWinDialog("Lost lol", false);
        }
        timer4.cancel();
      }
    });
  }


  bool change = false;

  @override
  void dispose() {
    timer.cancel();
    timer2.cancel();
    timer3.cancel();
    timer4.cancel();
    _controller.dispose();
    super.dispose();
  }

  var r = Random();
  bool first = false;

  int selected = -1;

  List n = [];
  List m = [];

  give(BuildContext context){
    location.clear();
    for(int i = 0; i < length; i++){
      setState(() {
        n.add(-1);
        m.add(false);
        location.addAll({
          i.toString(): [
            r.nextInt((MediaQuery.of(context).size.width*0.8).toInt()).toDouble(),
            r.nextInt((MediaQuery.of(context).size.height*0.225).toInt() + 100).toDouble()
          ],
        });
      });
    }
    setState(() {
      first = true;
    });
  }

  move(){
    location.clear();
    for(int i = 0; i < length; i++){
      location.addAll({
        i.toString(): [
          r.nextInt((MediaQuery.of(context).size.width*0.8).toInt()).toDouble(),
          r.nextInt((MediaQuery.of(context).size.height*0.225).toInt() + 100).toDouble()
        ],
      });
      setState(() {});
    }
  }

  Map location = {};

  @override
  Widget build(BuildContext context) {
    if(first == false){
      give(context);
    }
    double mediaQH = MediaQuery.of(context).size.height;
    double mediaQW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: mediaQH,
        width: mediaQW,
        color: Colors.white,
        child:
        Stack(
          children: [

            Container(
              height: mediaQH,
              width: mediaQW,
            ),

            AnimatedContainer(
              duration: durationShort,
              height: mediaQH,
              width: mediaQW,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    change == false ?
                    Color(0xffff512f):
                    Color(0xff232526),

                    change == false ?
                    Color(0xfff09819):
                    Color(0xff414345),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0,0.5],
                ),
              ),
            ),

            starPosition(mediaQH, mediaQW),

            Padding(
              padding: EdgeInsets.only(top: mediaQH*0.075),
              child: Center(
                child: RotationTransition(
                  turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                  alignment: Alignment.center,
                  child: Container(
                    height: mediaQH*0.9,
                    width: mediaQW*0.6,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: mediaQW*0.5,
                          width: mediaQW*0.5,
                          decoration: BoxDecoration(
                            color: Color(0xfffcd14d).withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            height: mediaQW*0.35,
                            width: mediaQW*0.35,
                            decoration: BoxDecoration(
                              color: Color(0xfffcd14d).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              height: mediaQW*0.2,
                              width: mediaQW*0.2,
                              decoration: BoxDecoration(
                                color: Color(0xfffcd14d),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: mediaQW*0.5,
                          width: mediaQW*0.5,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            height: mediaQW*0.4,
                            width: mediaQW*0.4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              height: mediaQW*0.2,
                              width: mediaQW*0.2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: mediaQH*0.15,
              left: mediaQW*0.25,
              child: RotationTransition(
                turns: Tween(begin: 1.0, end: 0.0).animate(_controller),
                alignment: Alignment.center,
                child: Container(
                  height: mediaQH*1,
                  width: mediaQW*0.25,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          height: mediaQW*0.25,
                          width: mediaQW*0.25,
                          child: Image.asset("assets/images/birds.gif",fit: BoxFit.fitWidth,)),
                      Container(),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: mediaQH*0.275 + 5,
              child: Container(
                height: mediaQH*0.725,
                width: mediaQW,
                color: Colors.transparent,
                child: Image.asset("assets/images/mountains.png",fit: BoxFit.cover,),
              ),
            ),

            // Center(
            //   child: Container(
            //     width: mediaQW,
            //     height: mediaQW*0.125,
            //     alignment: Alignment.center,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         AnimatedContainer(
            //           duration: durationGap,
            //           curve: Curves.easeInOut,
            //           width: gap == false ? mediaQW*0.05 : mediaQW*0.125,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //         ),
            //         AnimatedContainer(
            //           duration: Duration(milliseconds: 1200),
            //           curve: Curves.easeInOut,
            //           width: gap == false ? mediaQW*0.07 : mediaQW*0.35,
            //           height: 1,
            //         ),
            //         AnimatedContainer(
            //           duration: durationGap,
            //           curve: Curves.easeInOut,
            //           width: gap == false ? mediaQW*0.05 : mediaQW*0.125,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Center(
            //   child: Container(
            //     width: mediaQW*0.125,
            //     height: mediaQH,
            //     alignment: Alignment.center,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         AnimatedContainer(
            //           duration: durationGap,
            //           curve: Curves.easeInOut,
            //           height: gap == false ? mediaQW*0.125 : mediaQW*0.05,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //         ),
            //         AnimatedContainer(
            //           duration: Duration(milliseconds: 1200),
            //           curve: Curves.easeInOut,
            //           height: gap == false ? mediaQW*0.07 : mediaQW*0.4,
            //           width: 1,
            //         ),
            //         AnimatedContainer(
            //           duration: durationGap,
            //           curve: Curves.easeInOut,
            //           height: gap == false ? mediaQW*0.125 : mediaQW*0.05,
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: Colors.white,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),


            Align(
              alignment: Alignment.bottomCenter*0.9,
              child: Container(
                // height: mediaQH*0.5,
                width: mediaQW*0.9,
                child: GridView.builder(
                  itemCount: length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: side,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                    return n[index] == -1 ?
                    DragTarget<bool>(
                      onWillAccept: (val) => val != true,
                      onLeave: (val){
                        setState(() {
                        });
                      },
                      onAccept: (_){
                        setState(() {
                          Future.delayed(const Duration(milliseconds: 100), () {
                            setState(() {
                              n[index] = selected;
                              check();
                            });
                          });
                        });
                      },
                      builder: (context,can,rej){

                        return can.length > 0 ?
                        Container(
                          height: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                          width: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                          color: Colors.transparent,
                        ) :
                        Container(
                          height: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                          width: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        );
                      },
                    )  :
                    Draggable<bool>(
                      data: m[index],
                      onDragStarted: (){
                        setState(() {
                          m[n[index]] = true;
                          secondDragStart = n[index];
                          n[index] = -1;
                        });
                      },
                      onDragCompleted: (){
                        setState(() {
                          selected = secondDragStart;
                          n[index] = -1;
                          secondDragStart = -1;
                        });

                      },
                      onDraggableCanceled: (_,i){
                        setState(() {
                          m[secondDragStart] = false;
                          secondDragStart = -1;
                        });
                      },
                      feedback: Container(
                        height: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                        width: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                        color: Colors.white,
                        child: CachedNetworkImage(imageUrl: data[n[index]],fit: BoxFit.contain,),
                        // child: Image.memory(base64Decode(data[n[index]]),fit: BoxFit.contain,),
                        // child: Image.asset("assets/images/${n[index]}.png",fit: BoxFit.contain,),
                      ),
                      child: Container(
                        height: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                        width: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
                        color: Colors.white,
                        child: CachedNetworkImage(imageUrl: data[n[index]],fit: BoxFit.contain,),
                        // child: Image.memory(base64Decode(data[n[index]]),fit: BoxFit.contain,),
                        // child: Image.asset("assets/images/${n[index]}.png",fit: BoxFit.contain,),
                      ),
                    ) ;
                  },
                ),
              ),
            ),

            for(int i = 0; i < data.length; i++)
              position(mediaQH, mediaQW, location[i.toString()][0], location[i.toString()][1], i),


            Positioned(
              bottom: 0,
              child: Stack(
                children: [
                  Container(
                    height: mediaQH*0.005,
                    width: mediaQW,
                    color: Colors.white,
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.linear,
                    height: mediaQH*0.005,
                    width: (mediaQW/totalTime)*time,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            showCountDown(mediaQH, mediaQW),

          ],
        ),
      ),
    );
  }

  position(double mediaQH, double mediaQW, double left, double top, int inx){
    return
      AnimatedPositioned(
        duration: durationShort2,
        curve: Curves.easeInOut,
        left: left,
        top: top,
        child: item(mediaQW, inx),
      );
  }

  bool startTimer = false;

  item(double mediaQW,int inx){
    return Draggable<bool>(
      data: m[inx],
      onDragStarted: (){
        setState(() {
          m[inx] = true;
        });

        if(startTimer == false){
          startTimer = true;
          remainingTime();
        }

      },
      onDragCompleted: (){
        setState(() {
          selected = inx;
        });
      },
      onDraggableCanceled: (_,i){
        setState(() {
          m[inx] = false;
        });
      },
      child: m[inx] == false ? Container(
        height: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
        width: side <= 3 ? mediaQW*0.28 : mediaQW*0.2,
        color: Colors.transparent,
        child: data.isNotEmpty ?
        CachedNetworkImage(imageUrl: data[inx],fit: BoxFit.contain,) : Container(),
        // child: Image.asset(
        //   "assets/images/$inx.png",
        //   fit: BoxFit.contain,
        // ),
      ) : Container(),
      feedback: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: side <= 3 ? mediaQW*0.3 : mediaQW*0.22,
          width: side <= 3 ? mediaQW*0.3 : mediaQW*0.22,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: data.isNotEmpty ?
          CachedNetworkImage(imageUrl: data[inx],fit: BoxFit.contain,) : Container(),
          // child: Image.asset("assets/images/$inx.png",fit: BoxFit.contain,),
        ),
      ),
    );
  }

  check(){
    int hmm = -1;
    for(int i = 0; i < length; i++){
      if(n[i] == i){
        hmm++;
      }
    }
    if(hmm == length-1){
      print("win");
      setState(() {
        win = true;
      });
      timer4.cancel();
      setLevelData();
    }
  }

  setLevelData() async{
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
          if(level >= value.get("level")){

            FirebaseFirestore.instance.collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid).collection("level").doc("level_$level").set({
              "total_time": totalTime,
              "time_taken": time,
              "date": DateTime.now(),
              "level": level,
              "frequency": 1,
              "user": FirebaseAuth.instance.currentUser!.uid,
            });

            FirebaseFirestore.instance.collection("users").
            doc(FirebaseAuth.instance.currentUser!.uid).update({
              "level": level+1,
            });

            showWinDialog("High Score $time sec", true);

          }else{

            FirebaseFirestore.instance.collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid).collection("level")
                .doc("level_$level").get().then((value) {
                  int i = value.get("frequency");
                  i++;
                  if(time < value.get("time_taken")){
                    FirebaseFirestore.instance.collection("users")
                        .doc(FirebaseAuth.instance.currentUser!.uid).collection("level").doc("level_$level").update({
                      "time_taken": time,
                    });

                    showWinDialog("High Score $time sec", true);

                  }else{
                    showWinDialog("Congrats $time sec", true);
                  }

                  FirebaseFirestore.instance.collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid).collection("level").doc("level_$level").update({
                    "frequency": i,
                  });

                });

          }
        });
  }

  starSmall(){
    return AnimatedContainer(
      duration: durationShort,
      height: 3,
      width: 3,
      decoration: BoxDecoration(
        color: change == false ?
        Colors.transparent : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  starMedium(){
    return AnimatedContainer(
      duration: durationShort,
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: change == false ?
        Colors.transparent : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  starLarge(){
    return AnimatedContainer(
      duration: durationShort,
      height: 5,
      width: 5,
      decoration: BoxDecoration(
        color: change == false ?
        Colors.transparent : Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  starPosition(double mediaQH, double mediaQW){
    return Stack(
      children: [
        Positioned(
          top: mediaQH*0.05,
          left: mediaQW*0.08,
          child: starSmall(),
        ),
        Positioned(
          top: mediaQH*0.09,
          left: mediaQW*0.14,
          child: starSmall(),
        ),
        Positioned(
          top: mediaQH*0.3,
          left: mediaQW*0.075,
          child: starSmall(),
        ),
        Positioned(
          top: mediaQH*0.05,
          left: mediaQW*0.5,
          child: starMedium(),
        ),
        Positioned(
          top: mediaQH*0.2,
          left: mediaQW*0.3,
          child: starSmall(),
        ),
        Positioned(
          top: mediaQH*0.2,
          left: mediaQW*0.125,
          child: starLarge(),
        ),
        Positioned(
          top: mediaQH*0.3,
          right: mediaQW*0.4,
          child: starLarge(),
        ),
        Positioned(
          top: mediaQH*0.1,
          right: mediaQW*0.2,
          child: starLarge(),
        ),
        Positioned(
          top: mediaQH*0.2,
          right: mediaQW*0.1,
          child: starSmall(),
        ),
        Positioned(
          top: mediaQH*0.225,
          right: mediaQW*0.2,
          child: starMedium(),
        ),
      ],
    );
  }


  showCountDown(double mediaQH, double mediaQW){
    return count > 0 ?
    Container(
      height: mediaQH,
      width: mediaQW,
      color: Colors.black.withOpacity(0.3),
      alignment: Alignment.center,
      child: Text(countContent[count],
        style: TextStyle(
          color: Colors.white,
          fontSize: mediaQW*0.2,
          fontWeight: FontWeight.w600,
        ),),
    ) : Container();
    //     : Padding(
    //   padding: const EdgeInsets.only(top: 100),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //
    //       GestureDetector(
    //         onTap: (){
    //           showWinDialog("Congrats", true);
    //         },
    //         child: Container(
    //           height: 50,
    //           width: 100,
    //           color: Colors.green,
    //         ),
    //       ),
    //
    //       GestureDetector(
    //         onTap: (){
    //           showWinDialog("Lost lol", false);
    //         },
    //         child: Container(
    //           height: 50,
    //           width: 100,
    //           color: Colors.red,
    //         ),
    //       ),
    //
    //     ],
    //   ),
    // );
  }

  restart(){
    for(int i = 0; i < length; i++){
      setState(() {
        n[i] = -1;
        m[i] = false;
      });
    }
    setState(() {
      time = 0;
      win = false;
      selected = -1;
      secondDragStart = -1;
    });
    remainingTime();
  }

  nextLevel(){
    Future.delayed(Duration(milliseconds: 100),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return DragAndDrop(
            length: Data.level[level][0],
            side: Data.level[level][1],
            time: Data.level[level][2],
            level: level+1);
      }));
    });
    Navigator.of(context).pop();
  }

  showWinDialog(String yo, bool win) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
                  yo,
                )),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  win == true ?
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "cancel",
                        style: TextStyle(
                          fontSize: 21,
                          color: Color(0xff151515),
                        ),
                      ),
                    ),
                  ) :
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.3,
                    height: 50,
                    onPressed: () {
                      restart();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  win == true ?
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.3,
                    height: 50,
                    onPressed: () {
                      nextLevel();
                      // Navigator.of(context).pop();
                    },
                    child: Text(
                      'Next Level',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ) :
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.25,
                    height: 50,
                    onPressed: () async{
                      setState(() {
                        timer4.cancel();
                        startTimer = false;
                      });
                      await AdsProvider().showRewardedAd();
                      setState(() {
                        totalTime = totalTime + Data.level[level-1][3];
                        // remainingTime();
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      '+${Data.level[level-1][3]} sec',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  showConnectToInternet(String yo, bool connect) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
                  yo,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "cancel",
                        style: TextStyle(
                          fontSize: 21,
                          color: Color(0xff151515),
                        ),
                      ),
                    ),
                  ),
                  connect == true ?
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.3,
                    height: 50,
                    onPressed: () {
                      Future.delayed(const Duration(milliseconds: 125), () {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      });
                      Navigator.of(context).pop();
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                      //   return Level();
                      // }));
                    },
                    child: Text(
                      'Restart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ) :
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.3,
                    height: 50,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Start',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  share(String yo) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
                  yo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.75),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "cancel",
                        style: TextStyle(
                          fontSize: 21,
                          color: Color(0xff151515),
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: MediaQuery.of(context).size.width*0.3,
                    height: 50,
                    onPressed: () async{
                      await Share.share("https://play.google.com/store/apps/details?id=com.blackhole.drag_puzzle");
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Share',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }

}