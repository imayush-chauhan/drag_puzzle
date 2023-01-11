import 'dart:async';

import 'package:drag_puzzle/screens/about%20us.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({Key? key}) : super(key: key);

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {

  mail(String s) async{
    await launchUrl(Uri.parse(s));
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
    double mediaH = MediaQuery.of(context).size.height;
    double mediaW = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: mediaH,
        width: mediaW,
        decoration: BoxDecoration(
          gradient: LinearGradient(

            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            stops: [0,0.5,1],

            colors: [
              Color(0xffFFCC70),
              Color(0xffC850C0),
              Color(0xff4158D0),
            ],

          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: mediaH*0.07,),
              Container(
                height: mediaW*0.125,
                width: mediaW*0.45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: Center(
                    child: Text("How To Play",
                      style: TextStyle(
                        fontSize: mediaW*0.05,
                        fontFamily: "Source",
                        fontWeight: FontWeight.w600,
                        color: Color(0xffDD2A7B),
                      ),)
                ),
              ),
              SizedBox(height: mediaH*0.04,),
              Container(
                width: mediaW*0.85,
                padding: EdgeInsets.symmetric(vertical: mediaH*0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RichText(
                    softWrap: true,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'To win the game player need to rearrange ',
                            style: TextStyle(
                                color: Color(0xffDD2A7B).withOpacity(0.8),
                                fontSize: mediaW*0.04,
                                fontWeight: FontWeight.w600)),
                        TextSpan(text: 'the floating Image parts ',
                            style: TextStyle(
                                color: Colors.yellow.shade700,
                                fontSize: mediaW*0.04,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: ' to make a image, ',
                            style: TextStyle(
                                color: Color(0xffDD2A7B).withOpacity(0.8),
                                fontSize: mediaW*0.04,
                                fontWeight: FontWeight.w600)),
                        TextSpan(
                            text: 'Before the given time runs out',
                            style: TextStyle(
                                color: Color(0xffDD2A7B).withOpacity(0.8),
                                fontSize: mediaW*0.04,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: mediaH*0.04,),

              aboutUs(mediaW),

              SizedBox(height: mediaH*0.02,),

              licence(),

              social(),

              feedback(),

              SizedBox(height: mediaH*0.02,),
            ],
          ),
        ),
      ),
    );
  }

  aboutUs(double mediaW){
    return Container(
      height: mediaW*0.125,
      width: mediaW*0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Center(
          child: Text("About Us",
            style: TextStyle(
              fontSize: mediaW*0.05,
              fontFamily: "Source",
              fontWeight: FontWeight.w600,
              color: Color(0xffDD2A7B),
            ),)
      ),
    );
  }

  licence(){
    return Container(
      height: MediaQuery.of(context).size.height*0.28,
      width: MediaQuery.of(context).size.width*0.97,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Version Details",
              style: TextStyle(
                fontSize: 24,
                color: Colors.black.withOpacity(0.7),
              ),),
            Text("v1.0.0",
              style: TextStyle(
                fontSize: 22,
                color: Colors.black.withOpacity(0.7),
              ),),
            GestureDetector(
              onTap: (){
                showAboutDialog(
                  context: context,
                  applicationVersion: "1.0.0",
                );
              },
              child: Container(
                height: 55,
                width: 180,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black26),
                  ),
                  color: Colors.white,
                  child: Center(
                      child: Text("LICENSES",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black45,
                        ),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  social(){
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      width: MediaQuery.of(context).size.width*0.97,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Social Media",
              style: TextStyle(
                fontSize: 24,
                // fontFamily: Data.font,
                color: Colors.black.withOpacity(0.7),
              ),),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15,
                  right: 15
              ),
              child: Text(
                "If you enjoy playing Drag Game or want to know more about it, consider "
                    "following us on different social medias. You will get all the latest news "
                    "regarding to updates or ask any query we will always there to help you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5),
                ),),
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // socialMedias("instagram");
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.red.shade300),
                      ),
                      color: Colors.white,
                      child: Center(child: Text("Follow us on Instagram",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red.shade800
                        ),)),
                    ),
                  ),
                ),
                SizedBox(height: 6,),
                GestureDetector(
                  onTap: (){
                    // socialMedias("twitter");
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue.shade400),
                      ),
                      color: Colors.white,
                      child: Center(child: Text("Follow us on Twitter",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue
                        ),)),
                    ),
                  ),
                ),
                SizedBox(height: 6,),
                GestureDetector(
                  onTap: (){
                    // socialMedias("facebook");
                  },
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width*0.8,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(color: Colors.blue.shade800),
                      ),
                      color: Colors.white,
                      child: Center(child: Text("Follow us on Facebook",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade900
                        ),)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  feedback(){
    return
    Container(
      height: MediaQuery.of(context).size.height*0.28,
      width: MediaQuery.of(context).size.width*0.97,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Feedback",
              style: TextStyle(
                fontSize: 23,
                color: Colors.black.withOpacity(0.7),
              ),),
            Padding(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Text(
                "Give us feedback to improve the app\n"
                    "                     or Ask query",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.5),
                ),),
            ),
            GestureDetector(
              onTap: (){
                mail("mailto:ayush7known@gmail.com");
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width*0.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.blue,
                  child: Center(child: Text("Help & Feedback",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
