import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TestFile extends StatefulWidget {
  const TestFile({Key? key}) : super(key: key);

  @override
  State<TestFile> createState() => _TestFileState();
}

class _TestFileState extends State<TestFile> {

  String url = "https://firebasestorage.googleapis.com/v0/b/pokedex-dfadf.appspot.com/o/drag_level%2Flevel_1%2F0.png?alt=media&token=8648b993-3445-4e1b-b973-46c130990d15";

  String key = "Leve_1";
  Uint8List? image;
  List<String>? saveLevel1 = [];

  makeNull() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
    setState(() {});
  }

  getData() async{
    print("In getData>>>>>>>>>>>");
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList(key) != null){
      print("Hmmmm: " + prefs.getStringList(key)![0]);
      setState(() {
        saveLevel1 = prefs.getStringList(key)!;
      });

    }else{
      print("Level1 is Empty");
      getImage();
    }
  }

  setData(String key, List<String> list) async{

    print("In setData>>>>>>>>>>");

    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key).then((value) {
      setState(() {
        prefs.setStringList(key, list);
      });
    });

  }


  // urlToBase(List<dynamic> list) async{
  //
  //   print("In urlToBase>>>>>>>>>>>>>");
  //
  //   for(int i = 0; i < list.length; i++){
  //     image = (await NetworkAssetBundle(Uri.parse(list[i])).load(list[i])).buffer.asUint8List();
  //     saveLevel1.add(image!);
  //     // saveLevel1[url.substring(url.length - 4, url.length).toString()] = image!;
  //   }
  //
  //   setState(() {});
  //
  //   setData(key, saveLevel1);
  //
  // }


  FirebaseStorage storage = FirebaseStorage.instance;

  List<dynamic> list = [];

  // getImageUrl() async{
  //   for(int i = 0; i < 6; i ++){
  //     Reference ref = storage.ref().child("/drag_level/level_2/$i.png");
  //     String url = (await ref.getDownloadURL()).toString();
  //     // Uint8List image = (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
  //     list.add(url);
  //   }
  // }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    return base64Encode(bytes);
  }


  changeToBase(List data) async{

    print("In changeToBase>>>>>>>>>>>>>>>>");

    for(int i = 0; i < data.length; i++){
       saveLevel1!.add(await networkImageToBase64(data[i]));
    }

    setState(() {});

    print("Image: " + saveLevel1![0]);

    setImage(saveLevel1![0]);
    // setData(key, saveLevel1!);

  }

  setImage(String data){
    FirebaseFirestore.instance
        .collection("drag_data")
        .doc("2")
        .update({
      "1" : data,
    }).onError((error, stackTrace) {
      print("Error: $error");
    }).whenComplete(() {
      print("Success!!!!!!");
    });
  }

  getImage() {

    print("In getImage>>>>>>>>>>>>>>>>");

    FirebaseFirestore.instance
        .collection("drag_data")
        .doc("1")
        .get().then((value) {
          list = value.get("1");
    }).onError((error, stackTrace) {
      print("Error: $error");
    }).whenComplete(() {
      print("Success");
      print(list);
      changeToBase(list);
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            GestureDetector(
              onTap: (){
                print(saveLevel1![0]);
              },
              child: Container(
                height: 100,
                width: 100,
                color: Colors.blue,
              ),
            ),

            saveLevel1 != null && saveLevel1!.isNotEmpty ?
            Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: Image.memory(base64Decode(saveLevel1![0]),fit: BoxFit.contain,)) :
            Center(child: Text("No Image")),

          ],
        ),
      ),
    );
  }
}
