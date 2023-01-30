import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drag_puzzle/data/data.dart';
import 'package:drag_puzzle/screens/drag_puzzle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

class Level extends StatefulWidget {
  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {

  final InAppReview inAppReview = InAppReview.instance;

  review() async{
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
  }

  @override
  void initState() {
    super.initState();
    review();
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
    return Container(
      height: mediaQH,
      width: mediaQW,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [
            0, 0.5, 1
          ],
          colors: [
            Color(0xffFFCC70),
            Color(0xffC850C0),
            Color(0xff4158D0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Level",
            style: TextStyle(
              color: Colors.white,
              fontSize: mediaQW*0.057,
              fontWeight: FontWeight.w600,
            ),),
          centerTitle: true,
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: Icon(Icons.arrow_back_ios,color: Colors.white,),
            ),
          ),
          elevation: 0,
        ),
        body: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context,snapshot){
              
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: mediaQW*0.02),
                    child: GridView.builder(
                      itemCount: Data.level.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: mediaQH*0.03,
                        crossAxisSpacing: mediaQW*0.03,
                        mainAxisExtent: mediaQH*0.1,
                      ),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return index < snapshot.data!.get("level") ?
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                              return DragAndDrop(
                                level: index + 1,
                                length: Data.level[index][0],
                                side: Data.level[index][1],
                                time: Data.level[index][2],
                              );
                            },));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(mediaQW*0.05),
                            ),
                            alignment: Alignment.center,
                            child: Text("Level ${index+1}",
                              style: TextStyle(
                                color: Color(0xffC850C0),
                                fontSize: mediaQW*0.042,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                        ) :
                        GestureDetector(
                          onTap: (){
                            snackBar("Unlock level $index");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(mediaQW*0.05),
                            ),
                            alignment: Alignment.center,
                            child: Icon(Icons.lock,color: Colors.white,),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
              
            },
          ),
        ),
      ),
    );
  }
}