import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final fireStore = Firebase.initializeApp();
  //
  // socialMedias(String s) async{
  //   fireStore.then((value) async {
  //     FirebaseFirestore.instance.
  //     collection("memory").doc("1")
  //         .get().then((result){
  //       if(result.get(s) == ""){
  //         snackBar("We don't have $s account try Instagram");
  //       }else{
  //         launch(result.get(s));
  //       }
  //     });
  //   });
  // }

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
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0,0.46,1],
              colors: [
                Color(0xffFFCC70),
                Color(0xffC850C0),
                Color(0xff4158D0),
              ]
          )
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("About",
            style: TextStyle(
              // fontFamily: Data.font,
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*1.1,
              ),
              Positioned(
                top: 10,
                child: Container(
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
                        Text("v1.1.20",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black.withOpacity(0.7),
                          ),),
                        GestureDetector(
                          onTap: (){
                            showAboutDialog(
                              context: context,
                              applicationVersion: "1.1.20",
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
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.3,
                child: Container(
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
                            "If you enjoy using Memory Game or want to know more about it, consider "
                                "following us on different social medias. You will get all the latest news "
                                "regarding to updates or ask any query we will always there to help you.",
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
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.81,
                child: Container(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
