import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class DragAndDrop extends StatefulWidget {
  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> with SingleTickerProviderStateMixin{

  Duration durationLong = const Duration(seconds: 60);
  Duration durationShort = const Duration(seconds: 30);
  Duration durationShort2 = const Duration(seconds: 6);

  late AnimationController _controller;

  int length = 9;
  late Timer timer;
  late Timer timer2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: durationLong,
      vsync: this,
    );
    _controller.repeat();
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

    timer2 = Timer.periodic(durationShort2, (timer) {
      setState(() {
        move();
      });
    });
  }

  bool change = false;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _controller.dispose();
  }

  var r = Random();
  bool first = false;

  int selected = -1;

  List n = [];

  List y = [];
  List m = [];

  give(BuildContext context){
    location.clear();
    for(int i = 0; i < length; i++){
      setState(() {
        y.add(false);
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
        child: Stack(
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
            // hmm == true ?
            // starPosition(mediaQH, mediaQW) :
            // Container(),

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


            Align(
              alignment: Alignment.bottomCenter*0.9,
              child: Container(
                // height: mediaQH*0.5,
                width: mediaQW*0.9,
                child: GridView.builder(
                  itemCount: length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return n[index] == -1 ?
                    DragTarget<bool>(
                      onWillAccept: (val) => val != true,
                      onLeave: (val){
                        setState(() {
                          print("Leave");
                        });
                      },
                      onAccept: (_){
                        print("accept");
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
                          height: mediaQW*0.28,
                          width: mediaQW*0.28,
                          color: Colors.transparent,
                        ) :
                        Container(
                          height: mediaQW*0.28,
                          width: mediaQW*0.28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                          ),
                        );
                      },
                    )  :
                    // : selected != -1 ?
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          m[n[index]] = false;
                          n[index] = -1;
                        });
                      },
                      // onPanUpdate: (_){
                      //   location[index.toString()][0] = _.delta.dx;
                      //   location[index.toString()][1] = _.delta.dy;
                      //   setState(() {});
                      // },

                      onPanCancel: (){
                        setState(() {
                          m[n[index]] = false;
                          n[index] = -1;
                        });
                      },
                      child: Container(
                        height: mediaQW*0.28,
                        width: mediaQW*0.28,
                        color: Colors.white,
                        child:
                        // selected == -1 ?
                        //     Text("") :
                        Image.asset("assets/images/${n[index]}.png",fit: BoxFit.contain,),
                      ),
                    ) ;
                  },
                ),
              ),
            ),

            for(int i = 0; i < length; i++)
              position(mediaQH, mediaQW, location[i.toString()][0], location[i.toString()][1], i)

          ],
        ),
      ),
    );
  }

  position(double mediaQH, double mediaQW, double left, double top, int inx){
    return AnimatedPositioned(
      duration: durationShort2,
      curve: Curves.easeInOut,
      left: left,
      top: top,
      child: item(mediaQW, inx),
    );
  }

  item(double mediaQW,int inx){
    return Draggable<bool>(
      data: y[inx],
      onDragStarted: (){
        setState(() {
          m[inx] = true;
        });
      },
      onDragCompleted: (){
        print("drag complete");
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
        height: mediaQW*0.28,
        width: mediaQW*0.28,
        color: Colors.transparent,
        child: Image.asset(
          "assets/images/$inx.png",
          fit: BoxFit.contain,
        ),
      ) : Container(),
      feedback: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: mediaQW*0.28,
          width: mediaQW*0.28,
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: Image.asset("assets/images/$inx.png",fit: BoxFit.contain,),
        ),
      ),
    );
  }

  check(){
    int hmm = -1;
    for(int i = 0; i < 9; i++){
      if(n[i] == i){
        hmm++;
      }
    }
    if(hmm == 8){
      print("success");
      showWinDialog("Congrats");
    }
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

  restart(){
    // n.clear();
    // y.clear();
    // m.clear();
    for(int i = 0; i < 9; i++){
      setState(() {
        n[i] = -1;
        y[i] = false;
        m[i] = false;
      });
    }
    setState(() {
      selected = -1;
    });
  }

  showWinDialog(String yo) {
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.14,
                  ),
                  MaterialButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.red,
                    minWidth: 120,
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
                ],
              ),
            ],
          );
        });
  }

}
