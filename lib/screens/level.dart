import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Level extends StatefulWidget {
  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> {


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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: mediaQW*0.02),
                child: GridView.builder(
                  itemCount: 15,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: mediaQH*0.05,
                    crossAxisSpacing: mediaQW*0.03,
                    mainAxisExtent: mediaQH*0.08,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return Container(
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
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
