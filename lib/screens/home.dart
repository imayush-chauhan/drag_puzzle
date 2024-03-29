import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_puzzle/screens/how%20to%20pllay.dart';
import 'package:drag_puzzle/screens/level.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool change = false;
  late Timer timer;

  BannerAd? _ad;

  bannerAds()async{
    print("in");
    try{
      _ad = BannerAd(
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (_){
              print("ad loaded");
            },
            onAdFailedToLoad: (_ad,error){
              print("Ad failed to load on Error: $error");
            }
        ),
      );
    }catch(e){
      print("Error: $e");
    }

    await _ad!.load();
    setState(() {

    });
  }

  bool newGame = false;
  bool level = false;
  bool how = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 2700), (timer) {
      setState(() {
        change = !change;
      });
    });
    signInAnonymously();
    bannerAds();
  }

  void signInAnonymously() async{
    if(FirebaseAuth.instance.currentUser == null) {
      await _auth.signInAnonymously().then((value) {
        setData();
      }).catchError((e){
        snackBar("Error: $e");
      });
    }
  }

  setData()async{
    await FirebaseFirestore.instance.collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid).set({
      "user": FirebaseAuth.instance.currentUser!.uid,
      "date": DateTime.now(),
      "level": 1,

    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    _ad!.dispose();
  }

  add() async{
    await FirebaseStorage.instance.ref().child("drag_level").child("level_7").listAll().then((value) {
      value.items.elementAt(0).getDownloadURL().then((value) {
      });
    });
  }

  snackBar(String s){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        content: Text(s,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: mediaQH-200,
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
                              WavyAnimatedText("Puzzle ",
                                  speed: Duration(milliseconds: 450),
                                  textStyle: TextStyle(
                                    fontSize: mediaQW*0.085,
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
                          level = true;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          setState(() {
                            level = false;
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Level();
                              },
                            ));
                          });
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        height:
                        level == false ? mediaQH * 0.085 : mediaQH * 0.078,
                        width: level == false ? mediaQW * 0.5 : mediaQW * 0.45,
                        child: Card(
                          margin: EdgeInsets.all(0),
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          child: Center(
                              child: Text(
                                "Levels",
                                style: TextStyle(
                                  fontSize: mediaQW * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffDD2A7B),
                                ),
                              )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          newGame = true;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          setState(() {
                            newGame = false;
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return HowToPlay();
                            }));
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
                                "How to play",
                                style: TextStyle(
                                  fontSize: mediaQW * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xffDD2A7B),
                                ),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: ()async{
                            await launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.blackhole.drag_puzzle"),mode: LaunchMode.externalApplication,);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Icon(Icons.star,color: Colors.white,),
                          ),
                        ),
                        InkWell(
                          onTap: ()async{
                            await Share.share("https://play.google.com/store/apps/details?id=com.blackhole.drag_puzzle");
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Icon(Icons.share,color: Colors.white,),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return HowToPlay();
                            }));
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Icon(Icons.settings,color: Colors.white,),
                          ),
                        ),

                      ],
                    ),
                  ),

                  _ad != null ?
                  Container(
                    alignment: Alignment.center,
                    child: AdWidget(ad: _ad!,),
                    width: _ad!.size.width.toDouble(),
                    height: _ad!.size.height.toDouble(),
                  ) :
                  Container(),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}